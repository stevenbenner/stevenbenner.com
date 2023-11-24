<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- set output mode as html -->
	<xsl:output method="html"/>

	<!-- template that matches the root node -->
	<xsl:template match="searchdata">
		<html>
		<head>
			<title>Search Results For <xsl:value-of select="query/search" /></title>
		</head>
		<body>
			<h1>Search results for <xsl:value-of select="query/search" /></h1>

			<!-- results table -->
			<table border="1" cellpadding="5">
				<tr>
					<th>Class ID</th>
					<th>Name</th>
					<th>Teacher</th>
					<th>Description</th>
					<th>Date &amp; Time</th>
				</tr>
				<!-- run the template that renders the classes in table rows -->
				<xsl:apply-templates select="results/class" />
			</table>
		</body>
		</html>
	</xsl:template>

	<!-- template that matches classes -->
	<xsl:template match="class">
		<tr>
			<td><xsl:value-of select="@id" /></td>
			<td><xsl:value-of select="@name" /></td>
			<td><xsl:value-of select="teacher" /></td>
			<td><xsl:value-of select="description" /></td>
			<td><xsl:value-of select="datetime" /></td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
