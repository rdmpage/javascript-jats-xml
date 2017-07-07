<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="4.0" encoding="iso-8859-1"
		indent="yes" />

	<!-- general pdfx template -->
	<xsl:template match="pdfx">
		<!-- leave out the <meta> tag, just process the article -->
		<xsl:apply-templates select="article" />
	</xsl:template>

	<!-- article template -->
	<xsl:template match="article">

		<!-- an article has only 2 parts: Head and Main (which also contains the 
			bibliography - there is no Back matter) -->
		<div id="article">

			<!-- everything that's in the <front> tag of the XMl goes in the #article-head -->
			<div id="article-head">
				<xsl:apply-templates select="front" />
			</div>

         <!-- everything else, goes in #article-main -->
			<div id="article-main">
			
			   <!-- this is set to gobble everything but will ignore figures & tables -->
				<div id="article-main-content" class="us">
					<xsl:apply-templates select="body" />
				</div>

            <!-- the sidebar will catch figures & tables -->
				<div id="article-sidebar">
					<div class="highslide-gallery">
						<xsl:apply-templates select="//region[(@class='DoCO:FigureBox') or (@class='DoCO:TableBox')]" />
					</div>
				</div>

				<hr />
			</div>
		</div>

		<!-- The footer with links, etc., not part of the article itself -->
		<div id="footer">
			<p>
				<a href="http://pdfx.cs.man.ac.uk">Home</a> |
				<a href="javascript:history.back(-1)">Go Back</a>
			</p>

			<div id="footer-info">
				<span>
					This page was generated automatically by:
					<a title="pdfx homepage" href="http://pdfx.cs.man.ac.uk" rel="creator"
						rev="creatorOf" xml:lang="en">
						pdfx
					</a>
				</span>
			</div>
		</div>
	</xsl:template>

	<!-- <front> tag display rules -->
	<xsl:template match="front">

		<!-- display outsiders (such as journal names) at the top. These are the 
			only outsiders to be displayed -->
		<xsl:for-each select="outsider">
			<div class="outsider">
				<xsl:value-of select="." />
			</div>
		</xsl:for-each>

		<!-- display title -->
		<xsl:for-each select="title-group/article-title">
			<h1 id="article-title">
				<xsl:value-of select="." />
			</h1>
		</xsl:for-each>


		<xsl:for-each select="contrib-group">
			<div class="contrib-group">
				<xsl:for-each select="contrib">
					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="self::aff">
								<sup>
									<xsl:value-of select="." />
								</sup>
								<xsl:if test="position() != last()">
									<sup>,</sup>
								</xsl:if>
							</xsl:when>

							<xsl:otherwise>
								<xsl:value-of select="." />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					<xsl:if test="position() != last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</div>
		</xsl:for-each>

		<xsl:for-each select="footnote">
			<div id="author-footnote">
				<xsl:value-of select="." />
			</div>
		</xsl:for-each>

		<xsl:if test="abstract">
			<div id="abstract">
				<h3 class="h2-div">Abstract</h3>
				<xsl:for-each select="abstract">
					<div class="summary">
						<xsl:value-of select="." />
					</div>
				</xsl:for-each>
			</div>

		</xsl:if>

		<!-- this if for the rest, unknown regions such as 
		     citation information, etc -->
		<xsl:for-each select="region">
			<xsl:if test="@class='DoCO:TextChunk' or @class='unknown'">
				<div class="front-matter-extra">
					<xsl:value-of select="." />
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

   <!-- <body> tag display rules -->
	<xsl:template match="body">
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="self::region">
					<xsl:if test="@class!='DoCO:FigureBox' and @class!='DoCO:TableBox'">
						<xsl:apply-templates select="." />
					</xsl:if>
				</xsl:when>

				<xsl:otherwise>
					<xsl:apply-templates select="." />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="section">
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="self::region">
					<xsl:if test="@class!='DoCO:FigureBox' and @class!='DoCO:TableBox'">
						<xsl:apply-templates select="." />
					</xsl:if>
				</xsl:when>

				<xsl:otherwise>
					<xsl:apply-templates select="." />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="h1">
		<div class="h1-div">
			<h2>
				<xsl:value-of select="." />
			</h2>
		</div>
	</xsl:template>

	<xsl:template match="h2">
		<div class="h2-div">
			<h3>
				<xsl:value-of select="." />
			</h3>
		</div>
	</xsl:template>

	<xsl:template match="h3">
		<div class="h3-div">
			<h4>
				<xsl:value-of select="." />
			</h4>
		</div>
	</xsl:template>

	<xsl:template match="h4">
		<div class="h4-div">
			<h5>
				<xsl:value-of select="." />
			</h5>
		</div>
	</xsl:template>

	<xsl:template match="footnote">
		<div>
			<small>
				<i>
					<xsl:value-of select="." />
				</i>
			</small>
		</div>
	</xsl:template>

	<xsl:template match="ref-list">
		<div>
			<small>
				<i>
					<ul>
						<xsl:for-each select="ref">
							<li>
								<xsl:attribute name="id"><xsl:value-of select="@rid"/>
							    </xsl:attribute>
								<xsl:attribute name="name"><xsl:value-of select="@rid"/>
							    </xsl:attribute>
								<xsl:value-of select="." />

                        <xsl:if test="(@doi) and not (@confidence)">
                           <a href="{@doi}" target="_blank">
                              &#160;[DOI]
                           </a>
                        </xsl:if>
                        <xsl:if test="(@doi) and (@confidence)">
                           <i><a href="{@doi}" target="_blank">
                              &#160;[possible DOI]
                           </a></i>
                        </xsl:if>
                        <xsl:if test="(@alt_doi)">
                           <i><a href="{@alt_doi}" target="_blank">
                              &#160;[alternative DOI]
                           </a></i>
                        </xsl:if>
							</li>
						</xsl:for-each>
					</ul>
				</i>
			</small>
		</div>
	</xsl:template>

	<!-- <xsl:template match="region"> <xsl:if test="@class='DoCO:TextChunk' 
		or @class='unknown'"> <p> <div> <xsl:value-of select="." /> </div> </p> </xsl:if> 
		</xsl:template> -->

	<!-- default rule: copy any node beneath <region> -->
	<xsl:template match="region//*">
		<xsl:if test="../@class!='DoCO:FigureBox' and @class!='../DoCO:TableBox'">
			<xsl:copy>
				<xsl:copy-of select="@*" />
				<xsl:apply-templates />
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- default rule: ignore any unspecific text node -->
	<xsl:template match="text()" />

   <!-- override rule: allow sentences in there -->
   <xsl:template match="region//s">
      <xsl:apply-templates />
   </xsl:template>

	<!-- override rule: <ext-link> nodes get special treatment -->
	<xsl:template match="region//ext-link">
		<a href="{@href}">
			<xsl:value-of select="." />
			<!-- <xsl:apply-templates /> -->
		</a>
	</xsl:template>

	<!-- override rule: figure <xref> nodes get special treatment -->
	<xsl:template match="region//xref[@ref-type='fig']">
		<xsl:variable name="frid">
			<xsl:value-of select="@rid" />
		</xsl:variable>

		<a gallery="" title="">
			<xsl:attribute name="href">#<xsl:value-of select="//region[@id=$frid][1]/@id" /></xsl:attribute>

			<xsl:attribute name="alt">
				<!-- with an incorrect variable name (e.g. $rid), it would stop article rendering in its tracks. -->
		 	   <xsl:value-of select="//region[@id=$frid][1]/image[1]/@src" />
		    </xsl:attribute>

			<xsl:value-of select="." />
			<!-- <xsl:apply-templates /> -->
		</a>
	</xsl:template>

	<!-- override rule: table <xref> nodes also get special treatment -->
	<xsl:template match="region//xref[@ref-type='table']">
		<xsl:variable name="trid">
			<xsl:value-of select="@rid" />
		</xsl:variable>

		<a gallery="" title="">
			<xsl:attribute name="href">#<xsl:value-of
				select="//region[@id=$trid][1]/@id" />
		    </xsl:attribute>

			<xsl:value-of select="." />
			<!-- <xsl:apply-templates /> -->
		</a>
	</xsl:template>

	<!-- override rule: ITRP <xref> nodes also get special treatment -->
	<xsl:template match="region//xref[@ref-type='bibr']">
		<xsl:variable name="irid">
			<xsl:value-of select="@rid" />
		</xsl:variable>

		<a gallery="" title="">
			<xsl:attribute name="href">#<xsl:value-of
				select="$irid"/>
		    </xsl:attribute>

			<xsl:value-of select="." />
			<!-- <xsl:apply-templates /> -->
		</a>
	</xsl:template>

	<!-- override rule: insert line breaks before & after possible regions -->
	<xsl:template match="region[@confidence='possible']">
		<br/>
		<xsl:text>&#160;&#160;&#160;</xsl:text>
		<xsl:apply-templates />
		<br/>
	</xsl:template>

	<!-- override rule: copy any text node beneath region (body text, basically) -->
	<xsl:template match="region//text()">
		<xsl:copy-of select="." />
	</xsl:template>


	<xsl:template match="region[@class='DoCO:FigureBox']">
		<div class="sidebar-figure">
			<xsl:for-each select="child::image">
				<a class="sidebar-a">
					<xsl:attribute name="name">
						<xsl:value-of select="../@id" />
					</xsl:attribute>
				
					<xsl:attribute name="gallery">
						 <xsl:value-of select="../@number" />
					 </xsl:attribute>

					<!--<xsl:attribute name="title">
						 <xsl:value-of select="../caption[1]/text()" />
					 </xsl:attribute>-->
					 
					<xsl:attribute name="onclick">
						return hs.htmlExpand(this, { wrapperClassName: 'titlebar', align: 'center'}) <!--, headingText: '<xsl:value-of select="../caption[1]" />' -->
					</xsl:attribute>

					<xsl:attribute name="href">#</xsl:attribute>

					<xsl:attribute name="alt"> 
						 <xsl:value-of select="@src" />
					 </xsl:attribute>

					<img class="border">

						<xsl:attribute name="id"> 
							 <xsl:value-of select="../@id" />
						 </xsl:attribute>

						<xsl:attribute name="src">
							 <xsl:value-of select="/pdfx/meta/base_name/text()" />/<xsl:value-of select="@thmb" />
						 </xsl:attribute>
						<xsl:attribute name="alt"> 
							 <xsl:value-of select="@thmb" />
						 </xsl:attribute>
					</img>
				</a>

				<div class="highslide-maincontent">
					<div class="highslide-in-content-caption">
						<xsl:value-of select="../caption[1]" />
					</div>
					
					<img class="highslide-image" align="right" width="100%" height="auto"
						title="Click to close, click and drag to move. Use arrow keys for next and previous.">

						<xsl:attribute name="src">										
							 <xsl:value-of select="/pdfx/meta/base_name/text()" />/<xsl:value-of select="@src" />
					   </xsl:attribute>
					</img>
				</div>
			</xsl:for-each>

			<div class="sidebar-caption">
				<xsl:for-each select="child::caption">
					<xsl:value-of select="." />
				</xsl:for-each>
			</div>
		</div>

		
		<!--<div class="sidebar-separator"> *************************** </div>-->

	</xsl:template>

	<xsl:template match="region[@class='DoCO:TableBox']">

		<div class="sidebar-table">
			
			<div class="sidebar-caption">
				<xsl:for-each select="child::caption">
					<xsl:value-of select="." />
				</xsl:for-each>
			</div>
	
			<div class="sidebar-tabular-data">
				<xsl:for-each select="child::content">
					<xsl:for-each select="child::h1">
						<xsl:attribute name="class">
							 <xsl:value-of select="@class" />
						 </xsl:attribute>
						<xsl:value-of select="." />
					</xsl:for-each>

					<xsl:for-each select="child::table">
						<a class="sidebar-a">
							<xsl:attribute name="name">
								<xsl:value-of select="../@id" />
							</xsl:attribute>
						
							<!--<xsl:attribute name="title">
								 <xsl:value-of select="../../caption[1]" />
							</xsl:attribute>-->

							<xsl:attribute name="href">#</xsl:attribute>

							<xsl:variable name="table_heading">
							  <xsl:value-of select="../../caption[1]" />
							</xsl:variable>

							<!--<xsl:attribute name="onclick">
								return hs.htmlExpand(this, { wrapperClassName: 'titlebar', align: 'center', captionOverlay: { position: 'above'} })
							</xsl:attribute>-->

							<xsl:attribute name="onclick">
								return hs.htmlExpand(this, { wrapperClassName: 'titlebar', align: 'center' }) <!--, headingText: '<xsl:value-of select="../../caption[1]" />'-->
							</xsl:attribute>

							<table>
							
								<xsl:attribute name="id"> 
								     <xsl:value-of select="../../@id" />
   							    </xsl:attribute>

								<xsl:attribute name="class">
									<xsl:value-of select="@class" />
								</xsl:attribute>

								<thead style="text-align:center">
									<xsl:attribute name="class">
										<xsl:value-of select="@class" />
									</xsl:attribute>

									<xsl:for-each select="thead/tr">
										<tr>
											<xsl:attribute name="class"><xsl:value-of
												select="@class" /></xsl:attribute>

											<xsl:for-each select="child::th[position()&lt;3]">
												<th>
													<xsl:attribute name="class">
														<xsl:value-of select="@class" />
													</xsl:attribute>

													<xsl:value-of select="."></xsl:value-of>
												</th>
											</xsl:for-each>

											<xsl:if test="count(th)&gt;2">
												<th class="filler">...</th>
											</xsl:if>

										</tr>
									</xsl:for-each>


								</thead>

								<xsl:variable name="columns">
									<!--Conditionally instantiate a value to be assigned to the variable -->
									<xsl:choose>
										<xsl:when test="count(tbody/tr/td)&gt;2">
											<xsl:value-of select="3" /><!-- We either instantiate 
												a "3" -->
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="count(td)" /><!-- ...or the 
												actual count -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<tbody>
									<xsl:attribute name="class"><xsl:value-of
										select="@class" /></xsl:attribute>
									<xsl:for-each select="tbody/tr[position()&lt;5]">
										<tr>
											<xsl:attribute name="class"><xsl:value-of
												select="@class" /></xsl:attribute>

											<xsl:for-each select="child::td[position()&lt;3]">
												<td>
													<xsl:attribute name="class"><xsl:value-of
														select="@class" /></xsl:attribute>

													<xsl:attribute name="rowspan"><xsl:value-of
														select="@rowspan" /></xsl:attribute>

													<xsl:value-of select="."></xsl:value-of>
												</td>
											</xsl:for-each>

											<xsl:if test="count(td)&gt;2">
												<td class="filler">...</td>
											</xsl:if>
										</tr>
									</xsl:for-each>

									<xsl:if test="count(tbody/tr)&gt;4">
										<tr>
											<xsl:for-each select="./thead/tr/th">
												<xsl:if test="position()&lt;($columns+1)">
													<td class="table">...</td>
												</xsl:if>
											</xsl:for-each>
										</tr>
									</xsl:if>
								</tbody>

								<tfoot>
									<xsl:attribute name="class"><xsl:value-of
										select="@class" /></xsl:attribute>

									<xsl:for-each select="tfoot/tr">
										<tr>
											<xsl:attribute name="class"><xsl:value-of
												select="@class" /></xsl:attribute>

											<xsl:for-each select="child::th[position()&lt;3]">
												<th>
													<xsl:attribute name="class">
														<xsl:value-of select="@class" />
													</xsl:attribute>

													<xsl:value-of select="."></xsl:value-of>
												</th>
											</xsl:for-each>

											<xsl:if test="count(th)&gt;2">
												<th class="filler">...</th>
											</xsl:if>
										</tr>
									</xsl:for-each>
								</tfoot>

							</table>
						</a>
						
						

						<div class="highslide-maincontent">
						
							<div class="highslide-in-content-caption">
								<xsl:value-of select="../../caption[1]" />
							</div>
							
							<table>
								<xsl:attribute name="class">
									<xsl:value-of select="@class" /> sortable
								</xsl:attribute>

								<thead>
									<xsl:attribute name="class">table</xsl:attribute>

									<xsl:for-each select="thead/tr">
										<tr>
											<xsl:attribute name="class">
												<xsl:value-of select="@class" />
											</xsl:attribute>

											<xsl:for-each select="child::th">
												<th>
													<xsl:attribute name="class">
														<xsl:value-of select="@class" />
													</xsl:attribute>

													<xsl:value-of select="."></xsl:value-of>
												</th>
											</xsl:for-each>
										</tr>
									</xsl:for-each>

								</thead>

								<tbody>
									<xsl:attribute name="class">table</xsl:attribute>
									<xsl:for-each select="tbody/tr">
										<tr>
											<xsl:attribute name="class">
												<xsl:value-of select="@class" />
											</xsl:attribute>

											<xsl:for-each select="child::td">
												<td>
													<xsl:attribute name="class">
														<xsl:value-of select="@class" />
													</xsl:attribute>

													<xsl:attribute name="rowspan"><xsl:value-of
														select="@rowspan" /></xsl:attribute>

													<xsl:value-of select="."></xsl:value-of>
												</td>
											</xsl:for-each>
										</tr>
									</xsl:for-each>
								</tbody>

								<tfoot>
									<xsl:attribute name="class">table</xsl:attribute>

									<xsl:for-each select="tfoot/tr">
										<tr>
											<xsl:attribute name="class">table</xsl:attribute>

											<xsl:for-each select="child::th">
												<th>
													<xsl:attribute name="class">
														<xsl:value-of select="@class" />
													</xsl:attribute>

													<xsl:value-of select="."></xsl:value-of>
												</th>
											</xsl:for-each>
										</tr>
									</xsl:for-each>
								</tfoot>

							</table>
						</div>

					</xsl:for-each>


				</xsl:for-each>
			</div>
		</div>

	</xsl:template>

</xsl:stylesheet>
