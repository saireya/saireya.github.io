<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" exclude-result-prefixes="xi">
 <xsl:import href="style.xsl" />

 <xsl:template name="head-module">
  <script src="script/jquery.toc.js" async="async" />
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
  <nav />
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
   <aside class="content">
    <section>
     <h1>参考文献</h1>
     <xsl:call-template name="biblist"/>
    </section>
   </aside>
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
 <xsl:template match="l"><a><xsl:attribute name="id"><xsl:value-of select="@n" /></xsl:attribute></a></xsl:template>
 <xsl:template match="r"><a class="ref"><xsl:attribute name="href">#<xsl:value-of select="@n" /></xsl:attribute><xsl:value-of select="@n" /></a></xsl:template>
 <xsl:template match="cite"><a class="cite"><xsl:attribute name="href">#cite:<xsl:value-of select="@id"/></xsl:attribute>[cite:<xsl:value-of select="@id"/>]</a></xsl:template>

 <xsl:template match="h | hh | hhh">
  <xsl:element name="h{string-length(name()) + 2}">
   <xsl:attribute name="class">num</xsl:attribute>
   <xsl:if test="@n"><xsl:attribute name="id"><xsl:value-of select="@n"/></xsl:attribute></xsl:if>
   <xsl:apply-templates />
  </xsl:element>
 </xsl:template>

 <xsl:template match="s">
  <section>
   <h1 class="num">
    <xsl:if test="@n"><xsl:attribute name="id"><xsl:value-of select="@n"/></xsl:attribute></xsl:if>
    <xsl:value-of select="@h"/>
   </h1>
   <xsl:apply-templates />
  </section>
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
  <aside>
   <xsl:attribute name="class">block <xsl:value-of select="@class"/></xsl:attribute>
   <h6><xsl:value-of select="@h"/></h6>
   <xsl:apply-templates />
  </aside>
 </xsl:template>
</xsl:stylesheet>
