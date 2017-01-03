<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
	xmlns:europeana="http://www.europeana.eu/schemas/ese/"
	xmlns:osa="http://greenfield.osaarchivum.org/ns/item" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html"/>
	
	<xsl:template match="/">
		<xsl:if test="//europeana:rights!=''">
		<dt>Rights Statement:</dt>
		<dd>
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="//europeana:rights" />						
				</xsl:attribute>
				<xsl:attribute name="target">
					<xsl:text>_new</xsl:text>
				</xsl:attribute>
				<xsl:if test="//europeana:rights='http://www.europeana.eu/rights/rr-f/'">
					<xsl:text>Rights Reserved - Free Access</xsl:text>
				</xsl:if>
			</a>
		</dd>
		</xsl:if>	
		<xsl:if test="//osa:rightsStatement!=''">
			<dt>Use Conditions:</dt>
			<dd><xsl:value-of select="//osa:rightsStatement"/></dd>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
