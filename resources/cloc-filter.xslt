<?xml version='1.0' encoding='UTF-8' ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/">
  		<h2>Code Metrics Report</h2>
		<table border="1">
		<tr>
			<th>File Type</th>
			<th>Number of Files</th>
			<th>Blank Lines</th>
			<th>Comment Lines</th>
			<th>Code Lines</th>
		</tr>
		<xsl:for-each select="//language">
			<tr>
				<td align="center"><xsl:value-of select="@name"/></td>
				<td align="center"><xsl:value-of select="@files_count"/></td>
				<td align="center"><xsl:value-of select="@blank"/></td>
				<td align="center"><xsl:value-of select="@comment"/></td>
				<td align="center"><xsl:value-of select="@code"/></td>
			</tr>
		</xsl:for-each>
    </table>
</xsl:template>
</xsl:stylesheet>