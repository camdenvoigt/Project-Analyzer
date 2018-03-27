<?xml version='1.0' encoding='UTF-8' ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:my="http://pmd.sourceforge.net/report/2.0.0">

 	<xsl:output method="html"/>
  	<xsl:template match="/">
  		<html>
  		<head>
  			<style>
  				tr:nth-child(even) {background: #CCCC}
				tr:nth-child(odd) {background: #FFFF}
  			</style>
  		</head>
  		<body>
  		<h2>PMD Report</h2>
		<table border="1">
			<tr>
				<th>Rule</th>
				<th>Message</th>
				<th>Package</th>
				<th>Class</th>
				<th>Method</th>
				<th>Line</th>
			</tr>
			<xsl:for-each select="//my:violation">
				<tr>
					<td align="center"><xsl:value-of select="@rule"/></td>
					<td align="center"><xsl:value-of select="."/></td>
					<td align="center"><xsl:value-of select="@package"/></td>
					<td align="center"><xsl:value-of select="@class"/></td>
					<td align="center"><xsl:value-of select="@method"/></td>
					<td align="center"><xsl:value-of select="@beginline"/></td>
				</tr>
			</xsl:for-each>
	    </table>
		</body>
		</html>
   	</xsl:template>
</xsl:stylesheet>