<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" exclude-result-prefixes="xi">
 <xsl:include href="report.xsl" />

 <xsl:template match="log">
  <html>
   <xsl:text>&#10;</xsl:text>
   <head>
    <title><xsl:value-of select="@title" /></title>
   </head>
   <xsl:text>&#10;</xsl:text>
   <body data-type="book">
    <nav data-type="toc"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
    <section data-type="bibliography">
     <h1>参考文献</h1>
     <xi:include xpointer="xmlns(h=http://www.w3.org/1999/xhtml) xpointer(//h:ol)">
      <xsl:attribute name="href"><xsl:value-of select="@bib"/>.bib.html</xsl:attribute>
     </xi:include>
    </section>
    <xsl:text>&#10;</xsl:text>
    <section data-type="index"/>
    <xsl:text>&#10;</xsl:text>
   </body>
  </html>
 </xsl:template>
</xsl:stylesheet>
