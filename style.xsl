<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings" extension-element-prefixes="str">
 <xsl:output method="html" version="5" doctype-system="about:legacy-compat" encoding="utf-8" indent="yes" />
 <xsl:strip-space elements="*"/>

 <!-- template -->
 <xsl:template name="head-module"/>
 <xsl:template name="head-footer"/>
 <xsl:template name="body-header"/>
 <xsl:template name="body-footer"/>

 <xsl:template name="root">
  <xsl:param name="title">Log</xsl:param>

  <html>
   <xsl:text>&#10;</xsl:text>
   <head>
    <title><xsl:value-of select="$title" /></title>
    <base href="/" />
    <script>
     // private settings
     if (location.protocol == "file:")
     {
       baseurl = (navigator.platform.indexOf("Win") != -1)
//       ? 'G:'
         ? 'C:/Users/1400053'
         : "mnt/data";
       document.getElementsByTagName('base')[0].href = "file:///" + baseurl + "/Dropbox/Document/Education/Informatics/markup/";
     }
     less =
     {
       async: true,
     };
    </script>
    <link rel="stylesheet/less" type="text/css" href="style.less" />
    <link rel="stylesheet/less" type="text/css" href="report.less" />
    <link rel="stylesheet" type="text/css" href="script/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="syntax/shCoreDefault.css" />
    <!-- jQuery, syntaxhighlighterなど他のスクリプトに依存されるものはasync,deferにしない -->
    <script src="script/jquery.js" />
    <script src="script/jquery-ui.js" async="async" />
    <script src="script/jquery.csv.js" async="async" />
    <script src="syntax/xregexp.js" />
    <script src="syntax/shCore.js" />
    <script src="syntax/shAutoloader.js" />
    <script src="script/coffee-script.js" />
    <xsl:call-template name="head-module" />
    <!-- lessをasyncするとCSSの反映が遅くなる -->
    <!-- lessの読み込みは変換対象より後で行う -->
    <script src="script/less.js" />
    <script type="text/coffeescript" src="script/script.coffee"/>
    <xsl:call-template name="head-footer" />
   </head>
   <xsl:text>&#10;</xsl:text>
   <body data-type="book">
    <xsl:call-template name="body-header" />
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:call-template name="body-footer" />
    <section data-type="index"/>
    <xsl:text>&#10;</xsl:text>
   </body>
  </html>
 </xsl:template>

 <xsl:template match="log">
  <xsl:call-template name="root">
   <xsl:with-param name="title">
    <xsl:choose>
     <xsl:when test="@title"><xsl:value-of select="@title"/></xsl:when>
     <xsl:otherwise>Log</xsl:otherwise>
    </xsl:choose>
   </xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <xsl:template match="article">
  <xsl:apply-templates/>
  <aside role="doc-endnotes" data-type="endnotes">
   <ol class="footnotesList">
    <xsl:attribute name="id">autoFootnotes<xsl:value-of select="position() div 2 - 1"/></xsl:attribute>
   </ol>
  </aside>
 </xsl:template>

 <xsl:template match="hide"><span class="hide"><xsl:apply-templates /></span></xsl:template>
 <xsl:template match="fn"><span class="footnote" role="doc-footnote" data-type="footnote"><xsl:apply-templates /></span></xsl:template>

 <xsl:template match="img">
  <figure>
   <xsl:attribute name="id"><xsl:value-of select="@n" /></xsl:attribute>
   <object>
    <xsl:attribute name="data"><xsl:value-of select="@src"/></xsl:attribute>
    <xsl:attribute name="type">
     <!-- object要素ではdata属性かtype属性が必須で、type属性がないとChromeが正しく読み込めないので、type属性を指定 -->
     <xsl:choose>
      <xsl:when test="contains(@src,'.jpg')"><xsl:text>image/jpeg</xsl:text></xsl:when>
      <xsl:when test="contains(@src,'.png')"><xsl:text>image/png</xsl:text></xsl:when>
      <xsl:when test="contains(@src,'.svg')"><xsl:text>image/svg+xml</xsl:text></xsl:when>
     </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
    <xsl:if test="@scale">
<!-- <xsl:attribute name="style">transform-origin: 0 0; transform: scale(<xsl:value-of select="@scale"/>);</xsl:attribute>-->
     <xsl:attribute name="data-scale"><xsl:value-of select="@scale"/></xsl:attribute>
    </xsl:if>
    <xsl:value-of select="@alt"/>
   </object>
   <figcaption>
    <xsl:if test="@n">
     <a class="ref">
      <xsl:attribute name="href">#<xsl:value-of select="@n"/></xsl:attribute>
      <xsl:value-of select="@n"/>
     </a>
     <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:value-of select="@title"/>
   </figcaption>
  </figure>
 </xsl:template>

 <xsl:template match="code">
  <script type="syntaxhighlighter">
   <xsl:attribute name="class">brush:
    <xsl:choose>
     <xsl:when test="@class"><xsl:value-of select="@class"/></xsl:when>
     <xsl:when test="@src">
      <xsl:value-of select="str:tokenize(@src, '.')[last()]"/>
     </xsl:when>
     <xsl:otherwise>log</xsl:otherwise>
    </xsl:choose>
   </xsl:attribute>
   <xsl:if test="@src">
    <xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
   </xsl:if>
   <xsl:apply-templates /></script>
 </xsl:template>

 <xsl:template match="samp">
  <pre><samp><xsl:apply-templates /></samp></pre>
 </xsl:template>

 <xsl:template match="ins | del">
  <xsl:element name="{name()}"><xsl:apply-templates /></xsl:element>
  <time><xsl:value-of select="@datetime"/></time>
 </xsl:template>

 <xsl:template match="blockquote">
  <figure><blockquote><xsl:apply-templates /></blockquote></figure>
 </xsl:template>

 <xsl:template match="a">
  <a>
   <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
   <xsl:choose>
    <xsl:when test="text()"><xsl:apply-templates /></xsl:when>
    <xsl:otherwise><xsl:value-of select="@href"/></xsl:otherwise>
   </xsl:choose>
  </a>
 </xsl:template>

 <xsl:template match="li">
  <li><xsl:if test="@mark"><xsl:attribute name="data-mark"><xsl:value-of select="@mark"/></xsl:attribute></xsl:if><xsl:apply-templates /></li>
 </xsl:template>

 <xsl:template match="p | br | ul | ol | dl | dt | dd | table | tr | hr">
  <xsl:element name="{name()}">
   <xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
   <xsl:apply-templates />
  </xsl:element>
  <xsl:text>&#10;</xsl:text>
 </xsl:template>
 <xsl:template match="td | em | strong">
  <xsl:element name="{name()}">
   <xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
   <xsl:apply-templates />
  </xsl:element>
 </xsl:template>
 <xsl:template match="alert">
  <strong><xsl:apply-templates /></strong>
  <a data-type="indexterm"><xsl:attribute name="data-primary"><xsl:apply-templates /></xsl:attribute></a>
 </xsl:template>
 <xsl:template match="dfn">
  <dfn><xsl:apply-templates /></dfn>
  <a data-type="indexterm"><xsl:attribute name="data-primary"><xsl:apply-templates /></xsl:attribute></a>
  <xsl:if test="@abbr">
   <xsl:text>(</xsl:text>
   <abbr>
    <xsl:attribute name="title"><xsl:apply-templates /></xsl:attribute>
    <xsl:value-of select="@abbr"/>
   </abbr>
   <a data-type="indexterm"><xsl:attribute name="data-primary"><xsl:value-of select="@abbr"/></xsl:attribute></a>
   <xsl:text>)</xsl:text>
  </xsl:if>
  <xsl:if test="@en">
   <xsl:text>(</xsl:text>
   <dfn lang="en"><xsl:value-of select="@en"/></dfn>
   <a data-type="indexterm"><xsl:attribute name="data-primary"><xsl:value-of select="@en"/></xsl:attribute></a>
   <xsl:text>)</xsl:text>
  </xsl:if>
 </xsl:template>

 <xsl:template match="s">
  <section>
   <h1><xsl:value-of select="@h"/></h1>
   <xsl:apply-templates />
  </section>
 </xsl:template>

 <xsl:template match="appendix">
  <hr class="appendix"/>
  <aside class="content" role="doc-appendix" data-type="appendix">
   <xsl:apply-templates />
  </aside>
 </xsl:template>

 <xsl:template match="ruby">
  <ruby>
   <rb><xsl:apply-templates /></rb>
   <rt><xsl:value-of select="@r"/></rt>
  </ruby>
 </xsl:template>
</xsl:stylesheet>
