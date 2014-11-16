<?xml version='1.0'?>
 
<!--
        Copyright 2009 Andrew Beekhof
        License: GPL
        Author: Andrew Beekhof <andrew@beekhof.net>
-->

<!DOCTYPE xsl:stylesheet [
<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
 ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'
                xmlns="http://www.w3.org/TR/xhtml1/transitional"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                exclude-result-prefixes="#default">

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>
<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/graphics.xsl"/>
<xsl:import href="../../../xsl/html-single.xsl"/>
<xsl:import href="common.xsl"/>

<xsl:template name="user.head.content">
  <!--
      Paths to document() are relative to the xml build directory under $book/tmp
      Not the location of this xslt
  -->
   <xsl:variable name="codefile1" select="document('/usr/share/publican/Common_Content/pcp-brand/xsl/header.html',/)"/>
   <xsl:copy-of select="$codefile1/htmlcode/node()"/>
</xsl:template>

<xsl:template name="user.header.content">
   <xsl:variable name="codefile2" select="document('/usr/share/publican/Common_Content/pcp-brand/xsl/navigation.html',/)"/>
   <xsl:copy-of select="$codefile2/htmlcode/node()"/>
</xsl:template>

<xsl:template name="user.footer.content">
   <xsl:variable name="codefile4" select="document('/usr/share/publican/Common_Content/pcp-brand/xsl/footer.html',/)"/>
   <xsl:copy-of select="$codefile4/htmlcode/node()"/>
</xsl:template>
</xsl:stylesheet>
