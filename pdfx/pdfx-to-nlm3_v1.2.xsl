<?xml version="1.0" encoding="UTF-8"?>
<!--
XSL for converting pdfx 1.8 XML to NLM 3.0 XML. 
Currently only uses the subset of NLM for which there are logical mappings in PDFX. 

Created by: Alex Garnett (PKP) - axfelix@gmail.com
Revised by: Alex Constantin (PDFX) - aconstantin@cs.man.ac.uk

October 2013.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
	<!-- <xsl:output method="xml" encoding="UTF-8" indent="yes" doctype-system="http://dtd.nlm.nih.gov/publishing/3.0/journalpublishing3.dtd"/> -->
	<xsl:output method="xml" encoding="UTF-8" indent="yes" doctype-system="http://dtd.nlm.nih.gov/archiving/3.0/archivearticle3.dtd"/>
	<xsl:template match="/">
		<article xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:for-each select="pdfx">
				<xsl:for-each select="article/front">
					<front>
						<journal-meta>
							<journal-id/>
							<journal-title-group>
								<journal-title/>
							</journal-title-group>
							<issn/>
							<publisher>
								<publisher-name/>
							</publisher>	
						</journal-meta>
						<article-meta>
							<xsl:for-each select="title-group/article-title">
								<title-group>
									<article-title>
										<xsl:value-of select="string(.)"/>
									</article-title>
								</title-group>
							</xsl:for-each>
							<xsl:for-each select="contrib-group">
								<contrib-group>
									<xsl:for-each select="contrib">
										<contrib>
											<xsl:for-each select="name">
											   <name>
                                       <surname>
                                          <xsl:value-of select="string(.)"/>
                                       </surname>
                                       <given-names>
                                       </given-names>
                                    </name>
											</xsl:for-each>
											<xsl:for-each select="aff">
												<xref ref-type="aff">
												   <!-- Added an 'A' at the beginning of rid -->
													<xsl:attribute name="rid">A<xsl:value-of select="string(.)"/>
													</xsl:attribute>
													<xsl:value-of select="string(.)"/>
												</xref>
											</xsl:for-each>
										</contrib>
									</xsl:for-each>
								</contrib-group>
							</xsl:for-each>
							<xsl:for-each select="footnote">
								<aff>
									<xsl:value-of select="string(.)"/>
								</aff>
							</xsl:for-each>
							<xsl:if test="region">
							   <supplement>
                           <xsl:for-each select="region">                        
                              <p>
                                 <xsl:apply-templates select="."/>
                              </p>
                           </xsl:for-each>	
                        </supplement>
							</xsl:if>
							<xsl:for-each select="abstract">
								<abstract>
									<sec>
										<p>
            							<xsl:apply-templates select="." />	
											<!--<xsl:value-of select="string(.)"/>-->
										</p>
									</sec>
								</abstract>
							</xsl:for-each>
						</article-meta>
					</front>
				</xsl:for-each>
				<body>
					<xsl:for-each select="article/body/section">
						<sec>
							<xsl:for-each select="h1">
								<title>
									<xsl:value-of select="string(.)"/>
								</title>
							</xsl:for-each>			
							
							<xsl:apply-templates select="region" />	
							
							<xsl:for-each select="section">
								<sec>
									<xsl:for-each select="h2">
										<title>
											<xsl:value-of select="string(.)"/>
										</title>
									</xsl:for-each>	
									<xsl:apply-templates select="region" />									
                           <xsl:for-each select="section">
                              <sec>
                                 <xsl:for-each select="h3">
                                    <title>
                                       <xsl:value-of select="string(.)"/>
                                    </title>
                                 </xsl:for-each>	
                                 <xsl:apply-templates select="region" />									
                                 <xsl:for-each select="section">
                                    <sec>
                                       <xsl:for-each select="h4">
                                          <title>
                                             <xsl:value-of select="string(.)"/>
                                          </title>
                                       </xsl:for-each>	
                                       <xsl:apply-templates select="region" />									
                                       <xsl:for-each select="section">
                                          <sec>
                                             <xsl:for-each select="h5">
                                                <title>
                                                   <xsl:value-of select="string(.)"/>
                                                </title>
                                             </xsl:for-each>	
                                             <xsl:apply-templates select="region" />									
                                          </sec>
                                       </xsl:for-each>
                                    </sec>
                                 </xsl:for-each>
                              </sec>
                           </xsl:for-each>
								</sec>
							</xsl:for-each>
						</sec>
					</xsl:for-each>
					<!-- This apply-templates will take care of converting pdfx xml as is, but invalidate the NLM wrt. its DTD 
					<xsl:apply-templates/>	-->
				</body>
				<back>
					<xsl:for-each select="article/body/section/ref-list">
						<ref-list>
							<xsl:for-each select="ref">
								<ref>
								   <!-- Note: changed ID to be PDFX RID -->
									<xsl:attribute name="id">
									   <xsl:choose>
                                 <xsl:when test="@rid">
                                    <xsl:value-of select="@rid"/>
                                 </xsl:when> 
                                 <!-- Note: adding an 'X' at the beginning of original ID, to make a valid identifier -->
											<xsl:otherwise>X<xsl:value-of select="@id"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>	
									<mixed-citation>
									   <xsl:apply-templates/>
										<!--<xsl:value-of select="string(.)"/>-->
									</mixed-citation>
								</ref>
							</xsl:for-each>
						</ref-list>
					</xsl:for-each>
				</back>
			</xsl:for-each>
		</article>
	</xsl:template>
	<!-- front/regions go into <supplement> so no <p> for them -->
	<xsl:template match="front/region">
  		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="region">
	   <p>
   		<xsl:apply-templates/>
   	</p>
	</xsl:template>
	<xsl:template match="xref">
		<xsl:variable name="var65_rid" select="@rid"/>
		<xsl:variable name="var66_reftype" select="@ref-type"/>
		<!-- Note: adding 'XR' to start of XREF ids, to make them valid XML identifiers -->
		<xsl:variable name="var67_id">XR<xsl:value-of select="@id"/>
		</xsl:variable>
		<xref>
			<!--<xsl:if test="@hidden">
				<xsl:attribute name="hidden">
					<xsl:value-of select="@hidden" />
				</xsl:attribute>
			</xsl:if>-->
			<xsl:variable name="var68_id">
				<xsl:if test="@id">
					<xsl:value-of select="'1'"/>
				</xsl:if>
			</xsl:variable>
			<xsl:if test="string(boolean(string($var68_id))) != 'false'">
				<xsl:attribute name="id">
					<xsl:value-of select="string($var67_id)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:variable name="var69_reftype">
				<xsl:if test="@ref-type">
					<xsl:value-of select="'1'"/>
				</xsl:if>
			</xsl:variable>
			<xsl:if test="string(boolean(string($var69_reftype))) != 'false'">
				<xsl:attribute name="ref-type">
					<xsl:value-of select="string($var66_reftype)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:variable name="var70_rid">
				<xsl:if test="@rid">
					<xsl:value-of select="'1'"/>
				</xsl:if>
			</xsl:variable>
				<xsl:if test="string(boolean(string($var70_rid))) != 'false'">
					<xsl:attribute name="rid">
						<xsl:value-of select="string($var65_rid)"/>
					</xsl:attribute>
				</xsl:if>	
			<xsl:for-each select="node()[boolean(self::text())]">
				<xsl:value-of select="string(.)"/>
			</xsl:for-each>
		</xref>
	</xsl:template>
	<xsl:template match="email">
	   <email>
   	   <xsl:value-of select="string(.)"/>
   	</email>
	</xsl:template>
	<xsl:template match="ext-link">
	   <ext-link>
         <xsl:attribute name="ext-link-type">
            <xsl:value-of select="@ext-link-type"/>
         </xsl:attribute>
         <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
         </xsl:attribute>
   	   <xsl:value-of select="string(.)"/>
   	</ext-link>
	</xsl:template>
	<xsl:template match="region[@class='DoCO:FigureBox']">
    	<fig xmlns:xlink="http://www.w3.org/1999/xlink">
         <xsl:attribute name="id">
            <xsl:value-of select="@id"/>
         </xsl:attribute>
         <caption>
           <p>
              <xsl:apply-templates select="caption"/>
           </p>
        </caption>
        <graphic xlink:href="{@src}" />
    	</fig>
	</xsl:template>
	<xsl:template match="region[@class='DoCO:TableBox']">
		<table-wrap>
         <xsl:attribute name="id">
            <xsl:value-of select="@id"/>
         </xsl:attribute>
         <caption>
    	      <p>
    	         <xsl:apply-templates select="caption"/>
        	   </p>
        	</caption>
			<xsl:for-each select="content/table">
				<table>
					<xsl:for-each select="thead">
					   <xsl:if test="string(.)">
                     <thead>
                        <xsl:for-each select="tr">
                           <tr>
                              <xsl:for-each select="th">
                                 <td>
                                    <xsl:value-of select="string(.)"/>
                                 </td>
                              </xsl:for-each>
                           </tr>
                        </xsl:for-each>
                     </thead>
                  </xsl:if>
					</xsl:for-each>
					<xsl:for-each select="tbody">
						<tbody>
							<xsl:for-each select="tr">
								<tr>
									<xsl:for-each select="td">
										<td>
											<xsl:value-of select="string(.)"/>
										</td>
									</xsl:for-each>
								</tr>
							</xsl:for-each>
						</tbody>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</table-wrap>
	</xsl:template>
	<xsl:template match="region[@class='TableInfo']">
	</xsl:template>
</xsl:stylesheet>
