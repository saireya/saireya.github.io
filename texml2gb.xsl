<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:exsl="http://exslt.org/common" xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="exsl str">
 <xsl:import href="texml2md.xsl" />

 <xsl:template name="root">
  <xsl:param name="title"></xsl:param>
  <xsl:text># </xsl:text>
  <xsl:value-of select="$title" />
  <xsl:text>&#10;</xsl:text>
  <exsl:document href="SUMMARY.md" method="text" encoding="utf-8">
    <xsl:text># Summary&#10;</xsl:text>
   <xsl:for-each select="article/s | article/multicols/s | appendix/s">
    <xsl:text>* [</xsl:text>
    <xsl:value-of select="@h"/>
    <xsl:text>](ch_</xsl:text>
    <xsl:value-of select="position()"/>
    <xsl:text>.md)&#10;</xsl:text>
    <xsl:for-each select="s">
     <xsl:text>&#09;* [</xsl:text>
     <xsl:value-of select="@h"/>
     <xsl:text>](ch_</xsl:text>
     <xsl:value-of select="count(../preceding-sibling::*)+1"/>
     <xsl:text>.md#</xsl:text>
     <xsl:value-of select="@h"/>
     <xsl:text>)&#10;</xsl:text>
    </xsl:for-each>
   </xsl:for-each>
  </exsl:document>
 </xsl:template>

 <xsl:template match="article/s | article/multicols/s | appendix/s">
  <exsl:document href="ch_{position()}.md" method="text" encoding="utf-8">
   <xsl:call-template name="heading">
    <xsl:with-param name="level"></xsl:with-param>
   </xsl:call-template>
   <xsl:text>!INCLUDE "bib.md"&#10;</xsl:text>
  </exsl:document>
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

 <xsl:template match="aside">
  <xsl:text>&gt; #### </xsl:text>
  <xsl:value-of select="@class"/>
  <xsl:text>::</xsl:text>
  <xsl:value-of select="@h"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:for-each select="p">
   <xsl:text>&gt;&#10;</xsl:text>
   <xsl:text>&gt; </xsl:text>
   <xsl:apply-templates />
   <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
  <xsl:text>&#10;</xsl:text>
 </xsl:template>
</xsl:stylesheet>
