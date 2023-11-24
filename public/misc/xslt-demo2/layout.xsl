<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:set="http://exslt.org/sets"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	exclude-result-prefixes="set msxsl">

	<msxsl:script language="JScript" implements-prefix="set">
	<![CDATA[
		this['distinct'] = function (values) {
			// create an MSXML DOMDocument
			var xmlDoc = new ActiveXObject('Msxml2.DOMDocument.3.0');
			xmlDoc.async = false;
			xmlDoc.loadXML('<?xml version="1.0" encoding="utf-8"?>\n<distinctRoot></distinctRoot>');

			var dedupe = [];
			// iteratre through the nodes passed to this function
			var node = values.nextNode();
			while (node) {
				var isDuplicate = false;
				// does this node already exist in our dedupe array?
				for (var i=0; i<dedupe.length; i++) {
					if (dedupe[i] == node.xml) {
						isDuplicate = true;
						break;
					}
				}
				if (!isDuplicate) {
					dedupe.push(node.xml);
					// append this node to the DOMDocument
					xmlDoc.documentElement.appendChild(node.cloneNode(true));
				}
				node = values.nextNode();
			}
			var tagName = xmlDoc.documentElement.childNodes[0].nodeName;
			return xmlDoc.documentElement.getElementsByTagName(tagName);
		}
	]]>
	</msxsl:script>

	<!-- set output mode as html -->
	<xsl:output method="html"/>

	<!-- this key is used to sort the results, if you don't need to sort then you don't need a key -->
	<xsl:key name="authorIds" match="author" use="@id" />

	<!-- store the books in a variable because we loose context in the foreach -->
	<xsl:variable name="books" select="/searchresults/book" />

	<!-- template that matches the root node -->
	<xsl:template match="searchresults">
		<html>
		<head>
			<title>Demo</title>
		</head>
		<body>
			<h1>Results by author</h1>

			<!-- for each unique author id -->
			<xsl:for-each select="set:distinct(book/author)">

				<!-- sort by author name -->
				<xsl:sort select="key('authorIds', @id)" order="ascending" />

				<!-- store the current id in a variable so we can use it for selects -->
				<xsl:variable name="authorId" select="@id" />

				<h2><xsl:value-of select="key('authorIds', @id)" /></h2>
				<dl>
					<!-- run the book template on every book with this autor -->
					<xsl:apply-templates select="$books[author/@id=$authorId]">
						<!-- sort by book name -->
						<xsl:sort select="title" order="ascending" />
					</xsl:apply-templates>
				</dl>

			</xsl:for-each>

		</body>
		</html>
	</xsl:template>

	<!-- template that matches books -->
	<xsl:template match="book">
		<dt><xsl:value-of select="title" /></dt>
		<dd>
			<xsl:value-of select="author" /> / <xsl:value-of select="releasedate" />
		</dd>
	</xsl:template>

</xsl:stylesheet>
