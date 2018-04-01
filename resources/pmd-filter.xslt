<?xml version='1.0' encoding='UTF-8' ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:my="http://pmd.sourceforge.net/report/2.0.0">

 	<xsl:output method="html"/>
  	<xsl:template match="/">
  		<html>
  		<head>
  			<style>
  				tr:nth-child(even) {background: #CCCCCC}
				tr:nth-child(odd) {background: #FFFFFF}
  			</style>
  		</head>
  		<body>
  		<h2>PMD Report</h2>
		<table border="1">
			<tr>
				<th>Class</th>
				<th>Rule</th>
				<th>Message</th>
				<th>Location</th>
			</tr>
			<xsl:variable name="classValue" select="'test'"/>
			<xsl:for-each-group select="//my:violation" group-by="@class">
				<xsl:variable name="classValue" select="current-grouping-key()"/>
				<xsl:variable name="classCount" select="count(//my:violation[contains(@class, $classValue)])"/>

				<xsl:for-each select="current-group()">
					<xsl:choose>
					<xsl:when test="position() = 1">
						<tr>
							<td bgcolor="#FFFFFF" rowspan="{$classCount}" align="center"><xsl:value-of select="@class"/></td>
							<td align="center"><xsl:value-of select="@rule"/></td>
							<td align="center"><xsl:value-of select="."/></td>
							<td align="center">
								<p><xsl:value-of select="@package"/></p>
								<p><xsl:value-of select="@method"/></p>
								<p><xsl:value-of select="@beginline"/></p>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td align="center"><xsl:value-of select="@rule"/></td>
							<td align="center"><xsl:value-of select="."/></td>
							<td align="center">
								<p><xsl:value-of select="@package"/></p>
								<p><xsl:value-of select="@method"/></p>
								<p><xsl:value-of select="@beginline"/></p>
							</td>
						</tr>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:for-each-group>
	    </table>
		</body>
		</html>
   	</xsl:template>
</xsl:stylesheet>