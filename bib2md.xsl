<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:b="http://bibtexml.sf.net/" xmlns:xi="http://www.w3.org/2001/XInclude">
 <xsl:output method="text" encoding="utf-8"/>
 <!-- To remove line breaks -->
 <xsl:strip-space elements="*"/>

 <xsl:template match="/">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="b:entry/*">
  <xsl:text>[</xsl:text>
  <xsl:value-of select="../@id"/>
  <xsl:text>]: "</xsl:text>
  <xsl:choose>
   <xsl:when test="b:url"><xsl:value-of select="b:url"/></xsl:when>
   <xsl:when test="b:isbn">http://amazon.jp/dp/<xsl:value-of select="b:isbn"/></xsl:when>
   <xsl:when test="b:doi">http://dx.doi.org/<xsl:value-of select="b:doi"/></xsl:when>
   <xsl:otherwise>https://scholar.google.co.jp/scholar?q=<xsl:apply-templates select='b:author'/>,<xsl:value-of select='b:title'/></xsl:otherwise>
  </xsl:choose>
  <xsl:text>" "</xsl:text>
  <xsl:apply-templates select='b:author'/><xsl:apply-templates select='b:editor'/>
  <xsl:text>『</xsl:text>
  <xsl:value-of select='b:title'/>
  <xsl:text>』</xsl:text>
  <xsl:if test="b:pages">(pp. <xsl:value-of select='b:pages'/>)</xsl:if>
  <xsl:if test="b:booktitle">in <xsl:value-of select='b:booktitle'/></xsl:if>
  <xsl:if test="b:journal"  >in <xsl:value-of select='b:journal'  />
   <xsl:if test="b:volume"> vol. <xsl:value-of select='b:volume'/></xsl:if>
   <xsl:if test="b:number"> no. <xsl:value-of select='b:number'/></xsl:if>
  </xsl:if>
  <xsl:if test="b:year">
   <xsl:text>(</xsl:text>
   <xsl:value-of select='b:year'/>
   <xsl:if test="b:month">/<xsl:value-of select='b:month'/></xsl:if>
   <xsl:text>)</xsl:text>
  </xsl:if>
  <xsl:if test="b:publisher">(<xsl:value-of select='b:publisher'/>)</xsl:if>
  <xsl:text>"&#10;&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="b:author | b:editor">
  <xsl:choose>
   <xsl:when test='*'><xsl:apply-templates/></xsl:when>
   <xsl:otherwise><xsl:value-of select='text()'/></xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="b:person">
  <xsl:apply-templates/>
  <xsl:text>, </xsl:text>
 </xsl:template>

 <xsl:template match="xi:include">
  <xsl:apply-templates select="document(@href)"/>
 </xsl:template>

</xsl:stylesheet>
