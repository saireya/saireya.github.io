<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings" extension-element-prefixes="str">
 <xsl:output method="html" version="5" doctype-system="about:legacy-compat" encoding="utf-8" indent="yes" />

 <!-- template -->
 <xsl:template name="head-module"/>
 <xsl:template name="head-footer"/>
 <xsl:template name="body-header"/>
 <xsl:template name="body-footer"/>

 <xsl:template name="root">
  <xsl:param name="title">Log</xsl:param>

  <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
    <title><xsl:value-of select="$title" /></title>
    <base href="/" />
    <script>
     less =
     {
       async: true,
       fileAsync: true,
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
   <body>
    <xsl:call-template name="body-header" />
    <main>
     <xsl:if test='@slide=1'>
      <xsl:attribute name="class">reveal</xsl:attribute>
     </xsl:if>
     <xsl:if test='@slide!=1'>
     <h1><xsl:value-of select="$title" /></h1>
     </xsl:if>
     <xsl:apply-templates/>
    </main>

    <xsl:call-template name="body-footer" />
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
  <article class="content">
   <xsl:apply-templates/>
   <aside>
    <ol class="footnotesList">
     <xsl:attribute name="id">autoFootnotes<xsl:value-of select="position() div 2 - 1"/></xsl:attribute>
    </ol>
   </aside>
  </article>
 </xsl:template>

 <xsl:template match="hide"><span class="hide"    ><xsl:apply-templates /></span></xsl:template>
 <xsl:template match="fn"  ><span class="footnote"><xsl:apply-templates /></span></xsl:template>

 <xsl:template match="img">
  <figure>
   <xsl:attribute name="id"><xsl:value-of select="@n" /></xsl:attribute>
   <object>
    <xsl:attribute name="data-data"><xsl:value-of select="@src"/></xsl:attribute>
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
     </a>:
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

 <xsl:template match="p | br | ul | ol | dl | dt | dd | table | tr | td | em | strong | hr">
  <xsl:element name="{name()}">
   <xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
   <xsl:apply-templates />
  </xsl:element>
 </xsl:template>
 <xsl:template match="alert"><strong><xsl:apply-templates /></strong></xsl:template>

 <xsl:template match="s">
  <section>
   <h1><xsl:value-of select="@h"/></h1>
   <xsl:apply-templates />
  </section>
 </xsl:template>

 <xsl:template match="appendix">
  <hr class="appendix"/>
  <aside class="content">
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
