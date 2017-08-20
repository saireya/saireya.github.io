# 文書のパスからディレクトリ名を取得。
loc = document.location.pathname
dir = loc.substring(0, loc.lastIndexOf('/') + 1)

# 文字列sを連想配列reのkey-value対応で置き換え
replaceArray = (s, re) ->
	for k of re
		s = s.replace(RegExp(k, "ig"), re[k])
	s

sanitize   = (s) -> replaceArray(s, {'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;'})
unsanitize = (s) -> replaceArray(s, {'&amp;': '&', '&lt;': '<', '&gt;': '>', '&quot;': '"'})

loadText = ($o, file) ->
	fetch(file)
	.then (r) ->
		r.text()
	.then (text) ->
		$o.append(sanitize(text))

# URN -> URL
# ISBN, DOI, CiNii
linkconv = ($x) ->
	$x.find("a").attr "href", (i, v) ->
		replaceArray v,
			"^urn:isbn:": "http://www.amazon.co.jp/o/ASIN/",
			"^doi:":      "https://doi.org/",
			"^cinii:":    "http://ci.nii.ac.jp/naid/"

# table.tabular($tb)内に記述されたcsvをhtmlへ変換
csv2html = ($tb, sep = ",", quote = "\"") ->
	# キーは空文字列でも良いらしい。
	map = {"c": "center", "l": "left", "r": "right", "": "center"}
	# <>を置き換えてから分割
	csv = $.csv(sep, quote)(unsanitize($tb.html()))

	# indexを使ってくり返し回数をカウントします
	$thead = $("<thead/>")
	$tbody = $("<tbody/>")
	# table内のテキストを削除し、thead,tbodyを追加。
	$tb.empty().append($thead).append($tbody)
	$(csv).each (n) ->
		$tr = $("<tr/>")
		if @.length == 1 && @[0] == ""
			return
		$(@).each (i) ->
			$tn = $("<td/>")
			cell = @.trim()
			if i == 0 && cell.match(/^\\rowcolor\{([^\}]+)\} (.+)$/)
				cell = RegExp.$2
				$tr.css("background-color", RegExp.$1)
			if cell.match(/\\multicolumn\{([^\}]+)\}\{\|*([^\}\|]+)\|*\}\{([^\}]+)\}/)
				cell = RegExp.$3
				$tn.attr("colspan", RegExp.$1).css("text-align", map[RegExp.$2])
			if cell.match(/\\multirow\{([^\}]+)\}\{\|*([^\}\|]+)\|*\}\{([^\}]+)\}/)
				cell = RegExp.$3
				$tn.attr("rowspan", RegExp.$1)
			if cell.match(/\\shortstack(\[(.)\])?\{(\\tiny )?([^\}]+)*\}/)
				cell = RegExp.$4
				$tn.css("text-align", map[RegExp.$2])
			# <>を置き換え。
			#cell = sanitize(cell)
			$tn.append(cell).appendTo($tr)
		# 特に指定がない場合は最初の行をtheadに追加。
		$tr.appendTo(if n == 0 && $tb.data("nohead") != 1 then $thead else $tbody)

	# parsing align string
	c = 0
	align = $tb.data("align")
	for i in [0 ... align.length]
		switch align[i]
			when "p"
				w = align.substring(i + 2, align.indexOf("}", i + 2))
				$tbody.find("tr > td:nth-child(#{++c})").css("width", w).css("text-align", "left")
				i += w.length + 1
			when "|"
			else
				$tbody.find("tr > td:nth-child(#{++c})").css("text-align", map[align[i]])

# 文書の読み込みが完了してから実行。
$ ->
	isSlide = $("main").hasClass("reveal")
	$("#title").html($("#title").text().replace("\\\\", "<br/>"))

	# BibTeXML
	bib = document.querySelector("#bib")
	if bib
		fetch(dir + bib.dataset.src)
		.then (r) ->
			r.text()
		.then (r1) ->
			fetch("bib.xsl")
			.then (r) ->
				r.text()
			.then (r2) ->
				# r1[0]がxml, r2[0]がxsl
				xsltProc = new XSLTProcessor()
				p = new DOMParser()
				xsltProc.importStylesheet(p.parseFromString(r2, "text/xml"))
				resultDocument = xsltProc.transformToDocument(p.parseFromString(r1, "text/xml"))
				bib.replaceWith(resultDocument.querySelector("#bib"))
				# thenは遅延実行なので、リンクを別に変換する必要がある
				# linkconv($bib)
	# リンクを変換
	linkconv($(@))

	# popup tooltip
	$(".footnoteLink, .cite, a[href^='#']").attr "title", -> $(@).attr("href")

	# keep tooltip visible on hovering it
	# http://forum.jquery.com/topic/ui-tooltip-how-to-keep-it-visible
	$("a[title]")
		.on "mouseleave", (e) ->
			e.stopImmediatePropagation()
			fixed = setTimeout('$("a[title]").tooltip("close")', 500)
			$(".ui-tooltip").hover ->
				clearTimeout(fixed)
			, ->
				$("a[title]").tooltip("close")
		.tooltip
			position: {my: "left top"}
			content: ->
				title = $(@).attr("title")
				if title[0] == "#"
					title = $(title.replace(":", "\\:")).html()
				unsanitize(title)

	# make table of contents
	#if ! isSlide
	#	$.when(
	#		$("nav").toc()
	#	).then ->
	#		# hyperlink inside file.
	#		# tocのリンクを有効にするため、tocの処理が終わってから変換
	#		$("a[href^='#']").attr "href", (i, v) -> loc + v

	# image file.
	# imgタグを使うと、SVGを表示したとき、SVGからリンクしている外部ファイルを表示できない
	$("object").each ->
		# emulating 'zoom' property for Firefox
		$o = $(@)
		i = new Image()
		# 属性名をdata-srcとすると、処理中になぜか読み込まれてしまう
		# Imageオブジェクトで読み込んでおくことで、ブラウザに先に画像を取得させる
		i.src = dir + $o.attr("data")
		i.onload = () ->
			scale = if $o.is("[data-scale]") then $o.data("scale") else 1.0
			$o.height(i.naturalHeight * scale * (if isSlide then 2.0 else 1.0))
				# 先にdataを書き換えると表示してからサイズ変更されるので、後回しに
				.attr "data", i.src
		i.onerror = () ->
			console.log("load error: " + i.src)

	# 外部ファイルのコードを強調表示
	$code = $('script[type="syntaxhighlighter"][src]')
	$code.each -> loadText($(@), dir + $(@).attr("src"))
	if $code[0]
		SyntaxHighlighter.autoloader(
			'c    syntax/shBrushCpp.js'
			'diff syntax/shBrushDiff.js'
			'hs   syntax/shBrushHaskell.js'
			'java syntax/shBrushJava.js'
			'js   syntax/shBrushJScript.js'
			'log  syntax/shBrushPlain.js'
			'm    syntax/shBrushOctave.js'
			'pde  syntax/shBrushProcessing.js'
			'php  syntax/shBrushPhp.js'
			'py   syntax/shBrushPython.js'
			'R    syntax/shBrushR.js'
			'rb   syntax/shBrushRuby.js'
			'scm  syntax/shBrushScheme.js'
			'sh   syntax/shBrushBash.js'
			'sql  syntax/shBrushSql.js'
			'txt  syntax/shBrushPlain.js'
			'tex  syntax/shBrushLatex.js'
			'xml  syntax/shBrushXml.js'
		)
		SyntaxHighlighter.all()

	# tabular
	$(".tabular").each ->
		$tb = $(@)
		if $tb.data("src")
			$.when(
				loadText($tb, dir + $tb.data("src"))
			).then ->
				# CSVでは引用符が現れうる。
				csv2html($tb)
		else
			# 引用符が出てきても無視する。
			csv2html($tb, "&", "")

	# include TeX macro file.
	loadText($("#macro"), "../TeX/mymacro.tex")

	Reveal.initialize(
		history: true
		transition: 'none'
		center: false
		width: 800
		height: 600
		slideNumber: 'c/t'
	)
