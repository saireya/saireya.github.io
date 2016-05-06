<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:import href="report.xsl" />

 <xsl:template name="head-module">
  <!-- reveal.js -->
  <link rel="stylesheet" href="reveal.js/css/reveal.css"/>
  <link rel="stylesheet/less" type="text/css" href="slide.less"/>
  <script src="reveal.js/js/reveal.js"/>
  <!-- Printing and PDF exports -->
  <script>
   var link = document.createElement('link');
   link.rel = 'stylesheet';
   link.type = 'text/css';
   link.href = 'reveal.js/css/print/' + (window.location.search.match(/print-pdf/gi) ? 'pdf' : 'paper') + '.css';
   document.getElementsByTagName('head')[0].appendChild(link);
  </script>
  <!-- Mathjax -->
  <script type="text/x-mathjax-config">
     MathJax.Hub.Config({
       messageStyle: "none",
       extensions: ["tex2jax.js", "MathEvents.js", "MathMenu.js", "MathZoom.js"],
       jax: ["input/TeX", "output/HTML-CSS"],//NativeMML"],
       tex2jax: {inlineMath: [['$','$'], ['\\[','\\]']]},
       TeX: {extensions: ["AMSsymbols.js", "newcommand.js"]},
       NativeMML: {scale: 85},
       "HTML-CSS": {scale: 85},
     });
  </script>
  <script src="MathJax/MathJax.js" />
 </xsl:template>

 <xsl:template name="body-header">
  <div id="macro" style="display: none">
   \[
     \newcommand{\mathbfit}[1]{\boldsymbol{#1}}
   \]
  </div>
 </xsl:template>

 <xsl:template name="body-footer">
 </xsl:template>

 <xsl:template match="article">
  <article class="slides">
   <section class="slide">
    <h1><xsl:value-of select="../@title"/></h1>
    <address><xsl:value-of select="../@by" /></address>
   </section>
   <xsl:apply-templates/>

   <!-- Reference -->
   <xsl:if test='../@bib'>
    <section class="slide">
     <h3>Reference</h3>
     <div class="block">
      <xsl:call-template name="biblist">
       <xsl:with-param name="bib"><xsl:value-of select="../@bib" /></xsl:with-param>
      </xsl:call-template>
     </div>
    </section>
   </xsl:if>
  </article>
 </xsl:template>

 <!-- Beamer -->
 <xsl:template match="frame">
  <section class="slide">
   <h3>
    <xsl:choose>
     <!-- FIXME: insert(sub)sectionがいずれも「現在の節見出し」を表示 -->
     <xsl:when test="@title='\insertsection'"><xsl:value-of select="../@h"/></xsl:when>
     <xsl:when test="@title='\insertsubsection'"><xsl:value-of select="../@h"/></xsl:when>
     <xsl:when test="@title='\insertsubsubsection'"><xsl:value-of select="../@h"/></xsl:when>
     <xsl:otherwise><xsl:value-of select="@title"/></xsl:otherwise>
    </xsl:choose>
   </h3>
   <!-- contents of slide -->
   <div class="stretch"><xsl:apply-templates /></div>
  </section>
 </xsl:template>

 <xsl:template match="block">
  <div>
   <xsl:attribute name="class">block <xsl:value-of select="@class"/></xsl:attribute>
   <xsl:if test="@title!='\insertsection' and @title!='\insertsubsection'">
    <h6><xsl:value-of select="@title"/></h6>
   </xsl:if>
   <xsl:apply-templates />
  </div>
 </xsl:template>

 <xsl:template match="s">
  <!-- 見出しは出力しない -->
  <xsl:apply-templates />
 </xsl:template>
</xsl:stylesheet>
