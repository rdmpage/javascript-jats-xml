<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' 
	xmlns:tei='http://www.tei-c.org/ns/1.0'
	exclude-result-prefixes="tei"
	>

<xsl:output method='html' version='1.0' encoding='utf-8' indent='yes'/>


<xsl:template match="/">
	<h1><xsl:value-of select="//tei:titleStmt/tei:title" /></h1>
	
	<xsl:value-of select="//tei:profileDesc/tei:abstract" />
	
	
	
	<xsl:apply-templates select="//tei:body" />
	
	<!-- <xsl:apply-templates select="//tei:listBibl" /> -->
	
	
</xsl:template>

<xsl:template match="tei:body">
	<xsl:apply-templates select="//tei:div" />
</xsl:template>

<xsl:template match="tei:div">
	<div>
	<!-- <xsl:apply-templates select="tei:head" /> -->
	<!-- <xsl:apply-templates select="tei:p" /> -->
	<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="tei:head">
	<h2><xsl:value-of select="." /></h2>
</xsl:template>

<xsl:template match="tei:p">
	<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="tei:figure">
   <p>
   	<b><xsl:value-of select="tei:head" /></b>
   	<xsl:value-of select="tei:figDesc" />
	</p>
			
</xsl:template>

<xsl:template match="tei:ref">
   <xsl:choose>
   		<xsl:when test="@type='bibr'">
			<a>
				<xsl:attribute name="href"><xsl:value-of select="@target" /></xsl:attribute>
				<xsl:value-of select="." />
			</a>
		</xsl:when>
		<xsl:otherwise>
			<b><xsl:value-of select="." /></b>
		</xsl:otherwise>
	</xsl:choose>
			
</xsl:template>

<xsl:template match="tei:listBibl">
	<ol>
	<xsl:apply-templates select="tei:biblStruct" />
	</ol>
</xsl:template>

<xsl:template match="tei:biblStruct">
	<li>
	<a>
		<xsl:attribute name="name">
			<xsl:value-of select="@xml:id" />
		</xsl:attribute>
	</a>
	
	<xsl:value-of select="tei:analytic/tei:title" />
	
	<xsl:apply-templates select="tei:monogr" />
	</li>
</xsl:template>

<xsl:template match="tei:monogr">
	
	<i><xsl:value-of select="tei:title" /></i>
	<xsl:apply-templates select="tei:imprint" />
	
</xsl:template>

<xsl:template match="tei:imprint">
	
	<xsl:apply-templates select="tei:biblScope" />
	
	(<xsl:value-of select="tei:date/@when" />)
	
</xsl:template>

<xsl:template match="tei:biblScope">
   <xsl:choose>
   		<xsl:when test="@unit='volume'">
   			<xsl:text>: </xsl:text>
			<b>
				<xsl:value-of select="." />
			</b>
			<xsl:text>: </xsl:text>
		</xsl:when>
   		<xsl:when test="@unit='page'">
			<xsl:value-of select="@from" />
			<xsl:text>-</xsl:text>
			<xsl:value-of select="@to" />
		</xsl:when>		
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
			
</xsl:template>



</xsl:stylesheet>
