<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" exclude-result-prefixes="xi">
 <xsl:import href="style.xsl" />

 <xsl:template name="head-module">
  <!--<script src="script/jquery.toc.js" async="async" />-->
  <script type="text/x-mathjax-config">
     MathJax.Hub.Config({
       messageStyle: "none",
       extensions: ["tex2jax.js"],
       jax: ["input/TeX", "output/NativeMML"],
       tex2jax: {inlineMath: [['$','$'], ['\\[','\\]']]},
       TeX: {extensions: ["AMSsymbols.js"]},
       NativeMML: {scale: 85},
     });
  </script>
  <script src="MathJax/MathJax.js" async="async" />
 </xsl:template>

 <xsl:template name="body-header">
  <div id="macro" style="display: none">
   \[
     \newcommand{\mathbfit}[1]{\boldsymbol{#1}}
   \]
  </div>
  <nav data-type="toc"/>
 </xsl:template>

 <xsl:template name="biblist">
  <xsl:param name="bib"><xsl:value-of select="@bib" /></xsl:param>
  <ol id="bib">
   <xsl:attribute name="data-src"><xsl:value-of select="$bib" />.bibtexml</xsl:attribute>
   <!-- 基準ディレクトリを変更しているので下記では読み込めない -->
   <!--<xsl:apply-templates select="document(concat($bib, '.bibtexml'))"/>-->
  </ol>
 </xsl:template>

 <xsl:template name="body-footer">
  <!-- Reference -->
  <xsl:if test='@bib'>
   <section data-type="bibliography" role="doc-bibliography">
    <h1>参考文献</h1>
    <xsl:call-template name="biblist"/>
   </section>
  </xsl:if>
 </xsl:template>

 <xsl:template match="xi:include">
  <xsl:apply-templates select="document(@href)/*"/>
 </xsl:template>

 <!-- math -->
 <xsl:template match="m">
  <xsl:variable name="env">{align<xsl:if test="@no!=1">*</xsl:if>}</xsl:variable>
  <xsl:if test="@n"><a><xsl:attribute name="id"><xsl:value-of select="@n" /></xsl:attribute></a></xsl:if>
\begin<xsl:value-of select="$env" /><xsl:apply-templates />
\end<xsl:value-of select="$env" />
 </xsl:template>

 <!-- reference -->
 <xsl:template match="img"   mode="ref"><xsl:number level="any"/></xsl:template>
 <xsl:template match="s"     mode="ref"><xsl:number level="single"   count="s"/></xsl:template>
 <xsl:template match="s/s"   mode="ref"><xsl:number level="multiple" count="s"/></xsl:template>
 <xsl:template match="s/s/s" mode="ref"><xsl:number level="multiple" count="s"/></xsl:template>
 <xsl:template match="l">
  <a><xsl:attribute name="id"><xsl:value-of select="@n" /></xsl:attribute></a>
 </xsl:template>
 <xsl:template match="r">
  <a class="ref" data-type="xref"><xsl:attribute name="href">#<xsl:value-of select="@n" /></xsl:attribute>
   <xsl:apply-templates select="//img[@n=current()/@n]" mode="ref"/>
   <xsl:apply-templates select="//s[@n=current()/@n]"   mode="ref"/>
  </a>
 </xsl:template>
 <xsl:template match="cite">
  <a class="cite" role="doc-biblioref" data-type="xref"><xsl:attribute name="href">#cite:<xsl:value-of select="@id"/></xsl:attribute><xsl:value-of select="@id"/></a>
 </xsl:template>

 <xsl:template match="h | hh | hhh">
  <xsl:element name="h{string-length(name()) + 2}">
   <xsl:attribute name="class">num</xsl:attribute>
   <xsl:if test="@n"><xsl:attribute name="id"><xsl:value-of select="@n"/></xsl:attribute></xsl:if>
   <xsl:apply-templates />
  </xsl:element>
 </xsl:template>

 <xsl:template match="s">
  <section>
   <xsl:if test="@n"><xsl:attribute name="id"><xsl:value-of select="@n"/></xsl:attribute></xsl:if>
   <h1 class="num">
    <xsl:value-of select="@h"/>
   </h1>
   <xsl:text>&#10;</xsl:text>
   <xsl:apply-templates />
  </section>
  <xsl:text>&#10;</xsl:text>
 </xsl:template>

 <!-- heading -->
 <xsl:template name="heading">
  <xsl:param name="level"/>
  <xsl:param name="type"/>
  <section>
   <xsl:attribute name="data-type"><xsl:value-of select="$type"/></xsl:attribute>
   <xsl:element name="h{$level}">
    <xsl:attribute name="class">num</xsl:attribute>
    <xsl:if test="@n"><xsl:attribute name="id"><xsl:value-of select="@n"/></xsl:attribute></xsl:if>
    <xsl:value-of select="@h"/>
   </xsl:element>
   <xsl:text>&#10;</xsl:text>
   <xsl:apply-templates />
  </section>
  <xsl:text>&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="article/s | article/multicols/s | appendix/s">
  <xsl:call-template name="heading">
   <xsl:with-param name="type">chapter</xsl:with-param>
   <xsl:with-param name="level">1</xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <xsl:template match="article/s/s | article/multicols/s/s | appendix/s/s">
  <xsl:call-template name="heading">
   <xsl:with-param name="type">sect1</xsl:with-param>
   <xsl:with-param name="level">1</xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <xsl:template match="article/s/s/s | article/multicols/s/s/s | appendix/s/s/s">
  <xsl:call-template name="heading">
   <xsl:with-param name="type">sect2</xsl:with-param>
   <xsl:with-param name="level">2</xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <xsl:template match="u"   ><span style="text-decoration: underline"><xsl:apply-templates /></span></xsl:template>
 <xsl:template match="c"   ><span><xsl:attribute name="style">color:     <xsl:value-of select="@fg"  /></xsl:attribute><xsl:apply-templates /></span></xsl:template>
 <xsl:template match="size"><span><xsl:attribute name="style">font-size: <xsl:value-of select="@size"/></xsl:attribute><xsl:apply-templates /></span></xsl:template>

 <xsl:template match="multicols">
  <div>
   <xsl:choose>
    <xsl:when test="@flex">
     <xsl:attribute name="style">display: flex; align-items: center; justify-content: center</xsl:attribute>
    </xsl:when>
    <xsl:when test="@num">
     <xsl:attribute name="style">-moz-column-count: <xsl:value-of select="@num"/>; -webkit-column-count: <xsl:value-of select="@num"/></xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
     <xsl:attribute name="class">multicols</xsl:attribute>
    </xsl:otherwise>
   </xsl:choose>
   <xsl:apply-templates />
  </div>
 </xsl:template>

 <xsl:template match="column">
  <div><xsl:apply-templates /></div>
 </xsl:template>

 <xsl:template match="tabular">
  <figure>
   <xsl:attribute name="id"        ><xsl:value-of select="@n"    /></xsl:attribute>
   <figcaption>
    <xsl:if test="@n">
     <a class="ref">
      <xsl:attribute name="href">#<xsl:value-of select="@n"/></xsl:attribute>
      <xsl:value-of select="@n"/>
     </a>:
    </xsl:if>
    <xsl:value-of select="@title"/>
   </figcaption>
   <table class="tabular">
    <xsl:attribute name="data-src"   ><xsl:value-of select="@src"   /></xsl:attribute>
    <xsl:attribute name="data-align" ><xsl:value-of select="@align" /></xsl:attribute>
    <xsl:attribute name="data-nohead"><xsl:value-of select="@nohead"/></xsl:attribute>
    <xsl:apply-templates />
   </table>
  </figure>
 </xsl:template>

 <!-- shortstack -->
 <xsl:template match="ss"><xsl:apply-templates /></xsl:template>

 <!-- additional command -->
 <xsl:template match="cmd">
  <xsl:choose>
   <xsl:when test="@name='setcounter'">
    <div><xsl:attribute name="style">counter-reset: <xsl:value-of select="parm[1]" />&#160;<xsl:value-of select="parm[2]" /></xsl:attribute></div>
   </xsl:when>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="aside">
  <aside data-type="tip">
   <xsl:attribute name="class">block <xsl:value-of select="@class"/></xsl:attribute>
   <h6><xsl:value-of select="@h"/></h6>
   <xsl:apply-templates />
  </aside>
 </xsl:template>
</xsl:stylesheet>
