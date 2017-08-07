<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:b="http://bibtexml.sf.net/" xmlns:xi="http://www.w3.org/2001/XInclude" exclude-result-prefixes="xi">
 <xsl:import href="style.xsl" />

 <xsl:template match="/">
  <xsl:call-template name="root">
   <xsl:with-param name="title">Reference</xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <xsl:template match="b:file">
  <ol id="bib">
   <xsl:text>&#10;</xsl:text>
   <xsl:apply-templates/>
  </ol>
 </xsl:template>

 <xsl:template match="b:entry/*">
  <xsl:variable name="c">cite:<xsl:value-of select="../@id"/></xsl:variable>
  <xsl:variable name="u">
   <xsl:choose>
    <xsl:when test="b:url"><xsl:value-of select="b:url"/></xsl:when>
    <xsl:when test="b:isbn">urn:isbn:<xsl:value-of select="b:isbn"/></xsl:when>
    <xsl:when test="b:doi">doi:<xsl:value-of select="b:doi"/></xsl:when>
    <xsl:otherwise></xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <li>
   <xsl:attribute name="id"><xsl:value-of select="$c"/></xsl:attribute>
   <a class="cite"><xsl:attribute name="href">#<xsl:value-of select="$c"/></xsl:attribute>[<xsl:value-of select="$c"/>]</a>
   <xsl:text>&#160;</xsl:text>
   <xsl:apply-templates select='b:author'/><xsl:apply-templates select='b:editor'/>
   <xsl:choose>
    <xsl:when test="$u!=''"><a><xsl:attribute name="href"><xsl:value-of select="$u"/></xsl:attribute>『<xsl:value-of select='b:title'/>』</a></xsl:when>
    <xsl:otherwise><xsl:text>『</xsl:text><xsl:value-of select='b:title'/><xsl:text>』</xsl:text></xsl:otherwise>
   </xsl:choose>
   <xsl:if test="b:pages"><xsl:text> (pp. </xsl:text><xsl:value-of select='b:pages'/><xsl:text>)</xsl:text></xsl:if>
   <xsl:if test="b:booktitle"><xsl:text> in </xsl:text><xsl:value-of select='b:booktitle'/></xsl:if>
   <xsl:if test="b:journal"  ><xsl:text> in </xsl:text><xsl:value-of select='b:journal'  />
    <xsl:if test="b:volume"><xsl:text> vol. </xsl:text><xsl:value-of select='b:volume'/></xsl:if>
    <xsl:if test="b:number"><xsl:text> no. </xsl:text><xsl:value-of select='b:number'/></xsl:if>
   </xsl:if>
   <xsl:if test="b:year">
    <time><xsl:value-of select='b:year'/>
     <xsl:if test="b:month"><xsl:text>/</xsl:text><xsl:value-of select='b:month'/></xsl:if>
    </time>
   </xsl:if>
   <xsl:if test="b:publisher"><xsl:text>(</xsl:text><xsl:value-of select='b:publisher'/><xsl:text>)</xsl:text></xsl:if>
  </li>
  <xsl:text>&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="b:author | b:editor">
  <xsl:choose>
   <xsl:when test='*'><xsl:apply-templates/></xsl:when>
   <xsl:otherwise><span class="person"><xsl:value-of select='text()'/></span></xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="b:person">
  <span class="person"><xsl:apply-templates/></span>
 </xsl:template>

 <xsl:template match="xi:include">
  <xsl:apply-templates select="document(@href)"/>
 </xsl:template>

</xsl:stylesheet>
