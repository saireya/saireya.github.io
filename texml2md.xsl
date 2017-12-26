<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings" extension-element-prefixes="str">
 <xsl:output method="text" encoding="utf-8"/>
 <!-- To get correct position() of nodes -->
 <xsl:strip-space elements="*"/>

 <xsl:template name="root">
  <xsl:param name="title"></xsl:param>
  <xsl:text># </xsl:text>
  <xsl:value-of select="$title" />
  <xsl:text>&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="log">
  <xsl:call-template name="root">
   <xsl:with-param name="title"><xsl:value-of select="@title"/></xsl:with-param>
  </xsl:call-template>
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="article">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="img">
  <xsl:text>![</xsl:text>
  <xsl:value-of select="@n"/>
  <xsl:text>. </xsl:text>
  <xsl:value-of select="@title"/>
  <xsl:text>](</xsl:text>
  <xsl:value-of select="@src"/>
  <xsl:text>)&#10;&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="blockquote">
  <xsl:text>&gt; </xsl:text>
  <xsl:apply-templates />
  <xsl:text>&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="ol/li">
  <xsl:text>0. </xsl:text>
  <xsl:apply-templates />
  <xsl:text>&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="ul/li">
  <xsl:text>- </xsl:text>
  <xsl:apply-templates />
  <xsl:text>&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="p">
  <xsl:apply-templates />
  <xsl:text>&#10;&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="em">
  <xsl:text> *</xsl:text>
  <xsl:apply-templates />
  <xsl:text>* </xsl:text>
 </xsl:template>

 <xsl:template match="alert | strong">
  <xsl:text> **</xsl:text>
  <xsl:apply-templates />
  <xsl:text>** </xsl:text>
 </xsl:template>
 <xsl:template match="dfn">
  <xsl:variable name="mark">
   <xsl:choose>
    <xsl:when test="@strong=0">*</xsl:when>
    <xsl:otherwise>**</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:text> </xsl:text><xsl:value-of select="$mark"/>
  <xsl:apply-templates />
  <xsl:value-of select="$mark"/><xsl:text> </xsl:text>
  <xsl:if test="@abbr">
   <xsl:text>(</xsl:text><xsl:value-of select="$mark"/>
   <xsl:value-of select="@abbr"/>
   <xsl:value-of select="$mark"/><xsl:text>)</xsl:text>
  </xsl:if>
  <xsl:if test="@en">
   <xsl:text>(</xsl:text><xsl:value-of select="$mark"/>
   <xsl:value-of select="@en"/>
   <xsl:value-of select="$mark"/><xsl:text>)</xsl:text>
  </xsl:if>
 </xsl:template>

 <!-- heading -->
 <xsl:template name="heading">
  <xsl:param name="level"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:value-of select="$level"/>
  <xsl:text>## </xsl:text>
  <xsl:value-of select="@h"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="article/s | article/multicols/s | appendix/s">
  <xsl:call-template name="heading"/>
 </xsl:template>

 <xsl:template match="article/s/s | article/multicols/s/s | appendix/s/s">
  <xsl:call-template name="heading">
   <xsl:with-param name="level">#</xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <xsl:template match="article/s/s/s | article/multicols/s/s/s | appendix/s/s/s">
  <xsl:call-template name="heading">
   <xsl:with-param name="level">##</xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <xsl:template match="cite">
  <xsl:text>\[[</xsl:text>
  <xsl:value-of select="@id"/>
  <xsl:text>]\]</xsl:text>
 </xsl:template>

</xsl:stylesheet>
