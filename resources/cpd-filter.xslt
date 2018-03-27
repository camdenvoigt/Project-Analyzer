<?xml version='1.0' encoding='UTF-8' ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/">
  		<h2>CPD Report</h2>
		<table border="1">
		<tr>
			<th>Number of Duplicate Lines</th>
			<th>Number of Duplicate Tokens</th>
			<th>First File Line Number</th>
			<th>First File Path</th>
			<th>Second File Line Number</th>
			<th>Second File Path</th>
		</tr>
		<xsl:for-each select="//duplication">
			<tr>
				<td align="center"><xsl:value-of select="@lines"/></td>
				<td align="center"><xsl:value-of select="@tokens"/></td>
				<xsl:for-each select=".//file">
					<td align="center"><xsl:value-of select="@line"/></td>
					<td align="center"><xsl:value-of select="@path"/></td>
				</xsl:for-each>
			</tr>
		</xsl:for-each>
    </table>
</xsl:template>
</xsl:stylesheet>