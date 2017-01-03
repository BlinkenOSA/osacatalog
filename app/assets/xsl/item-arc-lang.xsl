<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:foxml="info:fedora/fedora-system:def/foxml#"
                xmlns:osa="http://greenfield.osaarchivum.org/ns/item"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html"/>

    <xsl:param name="ds"/>

	<xsl:template name="string-replace-all">
	    <xsl:param name="text" />
	    <xsl:param name="replace" />
	    <xsl:param name="by" />
	    <xsl:choose>
	        <xsl:when test="contains($text, $replace)">
	            <xsl:value-of select="substring-before($text,$replace)" />
	            <xsl:value-of select="$by" />
	            <xsl:call-template name="string-replace-all">
	                <xsl:with-param name="text" select="substring-after($text,$replace)" />
	                <xsl:with-param name="replace" select="$replace" />
	                <xsl:with-param name="by" select="$by" />
	            </xsl:call-template>
	        </xsl:when>
	        <xsl:otherwise>
	            <xsl:value-of select="$text" />
	        </xsl:otherwise>
	    </xsl:choose>
	</xsl:template>

    <xsl:template match="/">
      <xsl:apply-templates select="foxml:digitalObject/foxml:datastream[@ID=$ds]"></xsl:apply-templates>
    </xsl:template>

	<xsl:template match="foxml:digitalObject/foxml:datastream[@ID='ITEM-ARC-RU'] |
	                     foxml:digitalObject/foxml:datastream[@ID='ITEM-ARC-PL'] |
	                     foxml:digitalObject/foxml:datastream[@ID='ITEM-ARC-HU']">
			<h4 class="show-page-section"><i class="fa fa-list"></i>Collection Information</h4>
			<dl class="dl-horizontal  dl-invert data-details">
				[COLLECTION]
			</dl>

			<h4 class="show-page-section"><i class="fa fa-info"></i>General Information</h4>
      <dl class="dl-horizontal  dl-invert data-details">
				<xsl:if test=".//osa:creatorPersonalFree!='' or
				              .//osa:creatorCorporateFree!=''">
					<xsl:choose>
					<xsl:when test=".//osa:creatorPersonalFree/osa:role = 'collector' or .//osa:creatorCorporateFree/osa:role = 'collector'">
						<dt>Collector:</dt>
					</xsl:when>
					<xsl:otherwise>
						<dt>Creator:</dt>
					</xsl:otherwise>
					</xsl:choose>
					<dd>
					<div>
					<xsl:for-each select=".//osa:creatorPersonalFree |
					                      .//osa:creatorCorporateFree">
						<a>
						<xsl:attribute name="href">
							<xsl:text>/catalog?f[creator_facet][]=</xsl:text>
                            <xsl:variable name="element" select="name(.)"/>
                            <xsl:variable name="pos" select="position()"/>
							<xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/osa:name" />
						</xsl:attribute>
						<xsl:value-of select="osa:name" />
						</a>
						<xsl:if test="not(position()=last())">
							<xsl:text>; </xsl:text>
						</xsl:if>
					</xsl:for-each>
					</div>
					</dd>
				</xsl:if>

					<dt>Title:</dt>
					<dd class="titleUC">
					<div>
						<xsl:choose>
						<xsl:when test=".//osa:primaryTitle/osa:titleGiven = 'true'">
							<xsl:text>[</xsl:text>
							<xsl:value-of select=".//osa:primaryTitle/osa:title"/>
							<xsl:text>]</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select=".//osa:primaryTitle/osa:title"/>
						</xsl:otherwise>
						</xsl:choose>

						<xsl:if test=".//osa:alternativeTitle!=''">
							<xsl:if test="not(.//osa:alternativeTitle/osa:title = .//osa:primaryTitle/osa:title)">
								<xsl:choose>
								<xsl:when test=".//osa:primaryTitle/osa:titleGiven = 'false' and
										.//osa:alternativeTitle/osa:titleGiven = 'false'">
									<xsl:text> = </xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text> </xsl:text>
								</xsl:otherwise>
								</xsl:choose>

								<xsl:choose>
								<xsl:when test=".//osa:alternativeTitle/osa:titleGiven = 'true'">
									<xsl:text>[</xsl:text>
									<xsl:value-of select=".//osa:alternativeTitle/osa:title"/>
									<xsl:text>]</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select=".//osa:alternativeTitle/osa:title"/>
								</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:if>
					</div>
					</dd>

					<dt>Created:</dt>
					<dd>
						<div>
						<xsl:for-each select=".//osa:placeOfCreation">
							<xsl:value-of select="."/>
							<xsl:if test="not(position()=last())">
								<xsl:text>; </xsl:text>
							</xsl:if>
							<xsl:if test="position()=last()">
								<xsl:text>: </xsl:text>
							</xsl:if>
						</xsl:for-each>

						<xsl:choose>
						<xsl:when test=".//osa:dateOfCreationCa = 'true'">
							<xsl:text>[ca. </xsl:text>
							<xsl:value-of select=".//osa:dateOfCreation"/>
							<xsl:text>]</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select=".//osa:dateOfCreation"/>
						</xsl:otherwise>
						</xsl:choose>
						</div>
					</dd>

				<xsl:if test=".//osa:documentLanguage!='' or
				              .//osa:documentLanguageStatement!=''">
					<dt>Language:</dt>
					<dd>
						<div>
						<xsl:if test=".//osa:documentLanguage!=''">
							<xsl:for-each select=".//osa:documentLanguage">
								<xsl:value-of select="."/>
								<xsl:if test="not(position()=last())">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test=".//osa:documentLanguageStatement!=''">
							<xsl:text>. </xsl:text>
							<xsl:value-of select=".//osa:documentLanguageStatement"/>
						</xsl:if>
						</div>
					</dd>
				</xsl:if>

				<xsl:if test=".//osa:subExtent!=''">
					<dt>Physical Description:</dt>
					<dd>
						<div>
							<xsl:if test="count(.//osa:subExtent) > 1">
								<xsl:value-of select="count(.//osa:subExtent)" />
								<xsl:text> </xsl:text>
								<xsl:value-of select=".//osa:extentUnit" />
								<xsl:text>s (</xsl:text>
							</xsl:if>

							<xsl:for-each select=".//osa:subExtent">
								<xsl:value-of select=".//osa:subExtentNumber" />
								<xsl:text> </xsl:text>
								<xsl:choose>
									<xsl:when test="translate(.//osa:subExtentUnit, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') ='page'">
										<xsl:text>p.</xsl:text>
									</xsl:when>
									<xsl:when test="translate(.//osa:subExtentUnit, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') ='hh:mm:ss'">
										<xsl:text></xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select=".//osa:subExtentUnit" />
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="not(position()=last())">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:for-each>

							<xsl:if test="count(.//osa:subExtent) > 1">
								<xsl:text>)</xsl:text>
							</xsl:if>


							<xsl:if test=".//osa:materialForm!='' or
							              .//osa:isIllustrated='true' or
										  .//osa:illustrationStatement!='' or
										  .//osa:isSound='false' or
										  .//osa:isSoundStatement!='' or
										  .//osa:isColor!='' or
										  .//osa:isColorStatement!='' or
										  .//osa:isPhyisicalDescription!=''">
								<xsl:text>: </xsl:text>
							</xsl:if>

							<xsl:if test=".//osa:materialForm!=''">
								<xsl:for-each select=".//osa:materialForm">
									<xsl:value-of select="." />
									<xsl:if test="not(position()=last())">
										<xsl:text> </xsl:text>
									</xsl:if>
								</xsl:for-each>
								<xsl:if test=".//osa:isIllustrated='true' or
											  .//osa:illustrationStatement!='' or
											  .//osa:isSound='false' or
										      .//osa:soundStatement!='' or
										      .//osa:isColor!='' or
										      .//osa:colorStatement!='' or
										      .//osa:phyisicalDescription!=''">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:if>

							<xsl:if test=".//osa:isIllustrated='true'">
								<xsl:text>ill.</xsl:text>
								<xsl:if test=".//osa:illustrationStatement!='' or
											  .//osa:isSound='false' or
										      .//osa:soundStatement!='' or
										      .//osa:isColor!='' or
										      .//osa:colorStatement!='' or
										      .//osa:phyisicalDescription!=''">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:if>

							<xsl:if test=".//osa:illustrationStatement!=''">
								<xsl:value-of select=".//osa:illustrationStatement" />
								<xsl:if test=".//osa:isSound='false' or
										      .//osa:soundStatement!='' or
										      .//osa:isColor!='' or
										      .//osa:colorStatement!='' or
										      .//osa:phyisicalDescription!=''">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:if>

							<xsl:if test=".//osa:isSound='false'">
								<xsl:text>si.</xsl:text>
								<xsl:if test=".//osa:soundStatement!='' or
										      .//osa:isColor!='' or
										      .//osa:colorStatement!='' or
										      .//osa:phyisicalDescription!=''">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:if>

							<xsl:if test=".//osa:soundStatement!=''">
								<xsl:value-of select=".//osa:soundStatement" />
								<xsl:if test=".//osa:isColor!='' or
										      .//osa:colorStatement!='' or
										      .//osa:phyisicalDescription!=''">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:if>

							<xsl:if test=".//osa:isColor!='' and
							              translate(.//osa:primaryType, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'image'">
								<xsl:if test=".//osa:isColor='false'">
									<xsl:text>b&amp;w</xsl:text>
								</xsl:if>
								<xsl:if test=".//osa:colorStatement!='' or
										      .//osa:phyisicalDescription!=''">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:if>

							<xsl:if test=".//osa:isColor!='' and
							              translate(.//osa:primaryType, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'moving image'">
								<xsl:if test=".//osa:isColor='false'">
									<xsl:text>b&amp;w</xsl:text>
								</xsl:if>
								<xsl:if test=".//osa:isColor='true'">
									<xsl:text>col.</xsl:text>
								</xsl:if>
								<xsl:if test=".//osa:colorStatement!='' or
										      .//osa:phyisicalDescription!=''">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:if>

							<xsl:if test=".//osa:colorStatement!=''">
								<xsl:value-of select=".//osa:colorStatement" />
								<xsl:if test=".//osa:phyisicalDescription!=''">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:if>

							<xsl:if test=".//osa:dimensions!=''">
								<xsl:text>; </xsl:text>
								<xsl:value-of select=".//osa:dimensions" />
							</xsl:if>
						</div>
					</dd>
				</xsl:if>

				<xsl:if test=".//osa:formGenre!=''">
					<dt>Form/Genre:</dt>
					<dd>
					<xsl:for-each select=".//osa:formGenre">
						<div>
							<a>
							<xsl:attribute name="href">
								<xsl:text>/catalog?f[genre_facet][]=</xsl:text>
                                <xsl:variable name="element" select="name(.)"/>
                                <xsl:variable name="pos" select="position()"/>
                                <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/osa:genre" />
							</xsl:attribute>
							<xsl:value-of select="osa:genre" />
							</a>
						</div>
					</xsl:for-each>
					</dd>
				</xsl:if>
			</dl>

			<xsl:if test=".//osa:contentsSummary!='' or .//osa:contentsTable!=''">
				<h4 class="show-page-section"><i class="fa fa-list"></i>Content</h4>
				<dl class="dl-horizontal  dl-invert data-details">

					<xsl:if test=".//osa:contentsSummary!=''">
						<dt>Summary:</dt>
						<dd>
								[SUMMARY]
						</dd>
					</xsl:if>

					<xsl:if test=".//osa:contentsTable!=''">
						<dt>Content Table:</dt>
						<dd>
						<xsl:choose>
							<xsl:when test="count(.//osa:contentsTable) > 1">
								<ol>
								<xsl:for-each select=".//osa:contentsTable">
									<li><xsl:value-of select="." /></li>
								</xsl:for-each>
								</ol>
							</xsl:when>
							<xsl:otherwise>
								<div><xsl:value-of select=".//osa:contentsTable"/></div>
							</xsl:otherwise>
						</xsl:choose>
						</dd>
					</xsl:if>

				</dl>
			</xsl:if>

			<h4 class="show-page-section"><i class="fa fa-paperclip"></i>Context</h4>
      <dl class="dl-horizontal  dl-invert data-details">

				<xsl:if test=".//osa:administrativeHistory!=''">
					<dt>Creation Note:</dt>
					<dd>
						<xsl:for-each select=".//osa:administrativeHistory">
						<div><xsl:value-of select="."/></div>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//osa:additionalNotes!=''">
					<dt>Note:</dt>
					<dd>
						<xsl:for-each select=".//osa:additionalNotes">
						<div><xsl:value-of select="."/></div>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//osa:alliedMaterialStatement!=''">
					<dt>Note:</dt>
					<dd>
						<xsl:for-each select=".//osa:alliedMaterialStatement">
						<div><xsl:value-of select="."/></div>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//osa:relatedMaterialStatement!=''">
					<dt>Note:</dt>
					<dd>
						<xsl:for-each select=".//osa:relatedMaterialStatement">
						<div><xsl:value-of select="."/></div>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//osa:physicalDescription!=''">
					<dt>Note:</dt>
					<dd>
						<xsl:for-each select=".//osa:physicalDescription">
						<div><xsl:value-of select="."/></div>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//osa:physicalCondition!=''">
					<dt>Note:</dt>
					<dd>
						<xsl:for-each select=".//osa:physicalCondition">
						<div><xsl:value-of select="."/></div>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//osa:sourceUnitName!='' or
				              .//osa:sourceUnitID!=''">
					<dt>Source:</dt>
					<dd>
						<div>
							<xsl:value-of select=".//osa:sourceUnitName" />
							<xsl:text> (</xsl:text>
							<xsl:choose>
							<xsl:when test=".//osa:sourceUnitURL!=''">
								<a>
								<xsl:attribute name="href">

									<xsl:variable name="newurl">
									    <xsl:call-template name="string-replace-all">
									        <xsl:with-param name="text" select=".//osa:sourceUnitID" />
									        <xsl:with-param name="replace" select="'HU OSA '" />
									        <xsl:with-param name="by" select="''" />
									    </xsl:call-template>
									</xsl:variable>

									http:.//catalog.osaarchivum.org/db/fa/<xsl:value-of select="$newurl" />
								</xsl:attribute>
								<xsl:value-of select=".//osa:sourceUnitID" />
								</a>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select=".//osa:sourceUnitID" />
							</xsl:otherwise>
							</xsl:choose>
							<xsl:text>)</xsl:text>

						<xsl:if test=".//osa:folderName!=''">
							<xsl:text>; </xsl:text>
							<xsl:value-of select=".//osa:folder" />
						</xsl:if>

						</div>
					</dd>
				</xsl:if>

				<xsl:if test=".//osa:associatedCorporate!='' or
							  .//osa:associatedPersonal!=''">
					<dt>Associated Names:</dt>
					<dd>
						<xsl:for-each select=".//osa:associatedPersonal">
							<div>
							<a>
							<xsl:attribute name="href">
								<xsl:text>/catalog?f[added_person_facet][]=</xsl:text>
                                <xsl:variable name="element" select="name(.)"/>
                                <xsl:variable name="pos" select="position()"/>
                                <xsl:choose>
                                  <xsl:when test="osa:primary_name!=''">
                                    <xsl:value-of select="osa:primary_name" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/osa:name" />
                                  </xsl:otherwise>
                                </xsl:choose>
							</xsl:attribute>
							<xsl:value-of select="osa:name" />
							</a>
							<xsl:if test="osa:role!=''">
								<xsl:text> (</xsl:text>
								<xsl:value-of select="osa:role"/>
								<xsl:text>)</xsl:text>
							</xsl:if>
							</div>
						</xsl:for-each>
						<xsl:for-each select=".//osa:associatedCorporate">
							<div>
							<a>
							<xsl:attribute name="href">
								<xsl:text>/catalog?f[added_corporation_facet][]=</xsl:text>
                                <xsl:variable name="element" select="name(.)"/>
                                <xsl:variable name="pos" select="position()"/>
                                <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/osa:name" />
								<xsl:value-of select="osa:name" />
							</xsl:attribute>
							<xsl:value-of select="osa:name" />
							</a>
							<xsl:if test="osa:role!=''">
								<xsl:text> (</xsl:text>
								<xsl:value-of select="osa:role"/>
								<xsl:text>)</xsl:text>
							</xsl:if>
							</div>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//osa:associatedCountry!='' or
							  .//osa:associatedPlace!=''">
					<dt>Associated Places:</dt>
					<dd>
						<xsl:for-each select=".//osa:associatedCountry">
							<div>
							<a>
							<xsl:attribute name="href">
								<xsl:text>/catalog?f[added_country_facet][]=</xsl:text>
                                <xsl:variable name="element" select="name(.)"/>
                                <xsl:variable name="pos" select="position()"/>
                                <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/osa:country" />
							</xsl:attribute>
							<xsl:value-of select="osa:country" />
							</a>
							</div>
						</xsl:for-each>
						<xsl:for-each select=".//osa:associatedPlace">
							<div>
							<a>
							<xsl:attribute name="href">
								<xsl:text>/catalog?f[added_geo_facet][]=</xsl:text>
                                <xsl:variable name="element" select="name(.)"/>
                                <xsl:variable name="pos" select="position()"/>
                                <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/osa:place" />
							</xsl:attribute>
							<xsl:value-of select="osa:place" />
							</a>
							</div>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//osa:seriesTitle!=''">
					<dt>Part of Series:</dt>
					<dd>
						<xsl:for-each select=".//osa:seriesTitle">
							<div>
								<xsl:value-of select="."/>
							</div>
						</xsl:for-each>
					</dd>
				</xsl:if>
			</dl>

			<h4 class="show-page-section"><i class="fa fa-globe"></i>Coverage</h4>
      <dl class="dl-horizontal  dl-invert data-details">

			<xsl:if test=".//osa:spatialCoverageFree!='' or
						  .//osa:subjectPersonalFree!='' or
						  .//osa:subjectCorporateFree!='' or
						  .//osa:subjectTopicalFree !='' or
						  .//osa:subjectFree!=''">
				<dt>Collection Specific Tags:</dt>
				<dd>

					<xsl:for-each select=".//osa:spatialCoverageFree">
						<a>
						<xsl:attribute name="href">
							<xsl:text>/catalog?f[subject_geo_facet][]=</xsl:text>
                            <xsl:variable name="element" select="name(.)"/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/." />
						</xsl:attribute>
						<xsl:value-of select="." />
						</a>
						<xsl:choose>
							<xsl:when test="not(position()=last())">
								<xsl:text>, </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test=".//osa:subjectPersonalFree!='' or
											.//osa:subjectCorporateFree!= '' or
											.//osa:subjectTopicalFree!='' or
											.//osa:subjectFree!=''">
											<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					<xsl:for-each select=".//osa:subjectPersonalFree">
						<a>
						<xsl:attribute name="href">
							<xsl:text>/catalog?f[subject_person_facet][]=</xsl:text>
                            <xsl:variable name="element" select="name(.)"/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/." />
						</xsl:attribute>
						<xsl:value-of select="." />
						</a>
						<xsl:choose>
							<xsl:when test="not(position()=last())">
								<xsl:text>, </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test=".//osa:subjectCorporateFree!= '' or
											.//osa:subjectTopicalFree!='' or
											.//osa:subjectFree!=''">
											<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					<xsl:for-each select=".//osa:subjectCorporateFree">
						<a>
						<xsl:attribute name="href">
							<xsl:text>/catalog?f[subject_corporation_facet][]=</xsl:text>
                            <xsl:variable name="element" select="name(.)"/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/." />
						</xsl:attribute>
						<xsl:value-of select="." />
						</a>
						<xsl:choose>
							<xsl:when test="not(position()=last())">
								<xsl:text>, </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test=".//osa:subjectTopicalFree!='' or
											.//osa:subjectFree!=''">
											<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					<xsl:for-each select=".//osa:subjectTopicalFree | .//osa:subjectFree">
						<a>
						<xsl:attribute name="href">
							<xsl:text>/catalog?f[subject_facet][]=</xsl:text>
                            <xsl:variable name="element" select="name(.)"/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/." />
						</xsl:attribute>
						<xsl:value-of select="." />
						</a>
						<xsl:if test="not(position()=last())">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</dd>
			</xsl:if>

			<xsl:if test=".//osa:subjectLC!=''">
				<dt>Subjects:</dt>
				<dd>
					<xsl:for-each select=".//osa:subjectLC">
						<div>
						<a>
						<xsl:attribute name="href">
							<xsl:text>/catalog?f[subject_facet][]=</xsl:text>
                            <xsl:variable name="element" select="name(.)"/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/." />
						</xsl:attribute>
						<xsl:value-of select="." />
						</a>
						</div>
					</xsl:for-each>
				</dd>
			</xsl:if>

			<xsl:if test=".//osa:subjectPersonal!='' or
						  .//osa:subjectCorporate!=''">
				<dt>Authors/Names:</dt>
				<dd>
					<xsl:for-each select=".//osa:subjectPersonal">
						<div>
						<a>
						<xsl:attribute name="href">
							<xsl:text>/catalog?f[subject_person_facet][]=</xsl:text>
                            <xsl:variable name="element" select="name(.)"/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/osa:name" />
						</xsl:attribute>
						<xsl:value-of select="osa:name" />
						</a>
						</div>
					</xsl:for-each>
					<xsl:for-each select=".//osa:subjectCorporate">
						<div>
						<a>
						<xsl:attribute name="href">
							<xsl:text>/catalog?f[subject_corporation_facet][]=</xsl:text>
                            <xsl:variable name="element" select="name(.)"/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/osa:name" />
						</xsl:attribute>
						<xsl:value-of select="osa:name" />
						</a>
						</div>
					</xsl:for-each>
				</dd>
			</xsl:if>

			<xsl:if test=".//osa:spatialCoverageCountry!='' or
						  .//osa:spatialCoverage!=''">
				<dt>Additional Places:</dt>
				<dd>
					<xsl:for-each select=".//osa:spatialCoverageCountry">
						<div>
						<a>
						<xsl:attribute name="href">
							<xsl:text>/catalog?f[subject_geo_facet][]=</xsl:text>
                            <xsl:variable name="element" select="name(.)"/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/osa:country" />
						</xsl:attribute>
						<xsl:value-of select="osa:country" />
						</a>
						</div>
					</xsl:for-each>
					<xsl:for-each select=".//osa:spatialCoverage">
						<div>
						<a>
						<xsl:attribute name="href">
							<xsl:text>/catalog?f[subject_geo_facet][]=</xsl:text>
                            <xsl:variable name="element" select="name(.)"/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:value-of select="//foxml:datastream[@ID='ITEM-ARC-EN']//*[name()=$element][$pos]/osa:coverage" />
						</xsl:attribute>
						<xsl:value-of select="osa:coverage" />
						</a>
						</div>
					</xsl:for-each>
				</dd>
			</xsl:if>

			<xsl:if test=".//osa:locationOfOriginalLocalSystem!='' or
						  .//osa:locationOfOriginalUnit!='' or
						  .//osa:locationOfOriginal">
				<dt>Location of Originals:</dt>
				<dd>
				<xsl:for-each select=".//osa:locationOfOriginalLocalSystem | .//osa:locationOfOriginalUnit">
				<div>
					<xsl:value-of select="osa:location" />
					<xsl:text> (</xsl:text>
					<a>
						<xsl:attribute name="href">
						<xsl:value-of select="osa:locationURL" />
						</xsl:attribute>
						<xsl:value-of select="osa:locationID" />
					</a>
					<xsl:text>)</xsl:text>
				</div>
				</xsl:for-each>
				<xsl:for-each select=".//osa:locationOfOriginal">
					<div><xsl:value-of select="." /></div>
				</xsl:for-each>
				</dd>
			</xsl:if>

			<xsl:if test=".//osa:locationOfCopiesLocalSystem!='' or
						  .//osa:locationOfCopiesUnit!='' or
						  .//osa:locationOfCopies">
				<dt>Location of Copies:</dt>
				<dd>
				<xsl:for-each select=".//osa:locationOfCopiesLocalSystem">
					<xsl:value-of select="osa:location" />
					<xsl:text> (</xsl:text>
					<a>
						<xsl:attribute name="href">
						<xsl:value-of select="osa:locationURL" />
						</xsl:attribute>
						<xsl:value-of select="osa:locationID" />
					</a>
					<xsl:text>)</xsl:text>
					<xsl:if test=".//osa:locationOfCopiesUnit!='' or
								  .//osa:locationOfCopies!='' or
							      not(position()=last())">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>

				<xsl:for-each select=".//osa:locationOfCopiesUnit">
					<xsl:value-of select="osa:location" />
					<xsl:text> (</xsl:text>
					<a>
						<xsl:attribute name="href">
						<xsl:value-of select="osa:locationURL" />
						</xsl:attribute>
						<xsl:value-of select="osa:locationID" />
					</a>
					<xsl:text>)</xsl:text>
					<xsl:if test=".//osa:locationOfCopies!='' or
							      not(position()=last())">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>

				<xsl:for-each select=".//osa:locationOfCopies">
					<xsl:value-of select="." />
				</xsl:for-each>
				</dd>

			</xsl:if>

			<xsl:if test=".//osa:relatedMaterialLocalSystem!='' or
						  .//osa:relatedMaterialUnit!='' or
						  .//osa:relatedMaterial!=''">
				<dt>Related Material:</dt>
				<dd>
				<xsl:for-each select=".//osa:relatedMaterialLocalSystem">
					<xsl:value-of select="osa:material" />
					<xsl:text> (</xsl:text>
					<a>
						<xsl:attribute name="href">
						<xsl:value-of select="osa:materialURL" />
						</xsl:attribute>
						<xsl:value-of select="osa:materialID" />
					</a>
					<xsl:text>)</xsl:text>
					<xsl:if test=".//osa:relatedMaterialUnit!='' or
								  .//osa:relatedMaterial!='' or
							      not(position()=last())">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>

				<xsl:for-each select=".//osa:relatedMaterialUnit">
					<xsl:value-of select="osa:material" />
					<xsl:text> (</xsl:text>
					<a>
						<xsl:attribute name="href">
						<xsl:value-of select="osa:materialURL" />
						</xsl:attribute>
						<xsl:value-of select="osa:materialID" />
					</a>
					<xsl:text>)</xsl:text>
					<xsl:if test=".//osa:relatedMaterial!='' or
							      not(position()=last())">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>

				<xsl:for-each select=".//osa:relatedMaterial">
					<xsl:value-of select="." />
				</xsl:for-each>
				</dd>
			</xsl:if>
		</dl>

		<h4 class="show-page-section"><i class="fa fa-copyright"></i>Access and Use</h4>
		<dl class="dl-horizontal  dl-invert data-details">

			[RIGHTS]

			<xsl:if test=".//osa:archivalReferenceNumber!=''">
				<dt>Archival ID:</dt>
				<dd>
					<div><xsl:value-of select=".//osa:archivalReferenceNumber"/></div>
				</dd>
			</xsl:if>

				<dt>Suggested Citation:</dt>
				<dd>
					<div>
					<xsl:text>"</xsl:text>
					<xsl:value-of select=".//osa:primaryTitle/osa:title"/>
					<xsl:text>", </xsl:text>
					<xsl:value-of select=".//osa:dateOfCreation" />
					<xsl:text>. </xsl:text>
					<xsl:value-of select=".//osa:archivalReferenceNumber" />
					<xsl:text>; </xsl:text>
					<xsl:value-of select=".//osa:sourceUnitName" />
					<xsl:text>; </xsl:text>
					<xsl:text>Open Society Archives at Central European University, Budapest.</xsl:text>
					</div>
				</dd>

			<xsl:if test=".//osa:itemGUID!=''">
				<dt>Permanent URI:</dt>
				<dd>
					<xsl:element name="a">
					    <xsl:attribute name="href">
									http://hdl.handle.net/10891/<xsl:value-of select=".//osa:itemGUID"/>
					    </xsl:attribute>
					    http://hdl.handle.net/10891/<xsl:value-of select=".//osa:itemGUID"/>
					</xsl:element>
			</xsl:if>

			<dt></dt>
			<dd class="info">When you cite the online source, the phrase "[Electronic record]" should be inserted into the standard citation after the item title and date. The citation should be followed by the URI with the date you last accessed the resource in square brackets.</dd>

		</dl>
	</xsl:template>
</xsl:stylesheet>
