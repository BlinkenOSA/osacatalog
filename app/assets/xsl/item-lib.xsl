<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.loc.gov/MARC21/slim"
                xmlns:foxml="info:fedora/fedora-system:def/foxml#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html"/>

    <xsl:template match="/">
      <xsl:apply-templates select="foxml:digitalObject/foxml:datastream[@ID='ITEM-LIB-EN']"></xsl:apply-templates>
    </xsl:template>

	<xsl:template match="//foxml:datastream[@ID='ITEM-LIB-EN']//*[@tag='041']">
		<xsl:for-each select="./*[@code='a']">
			<xsl:choose>
				<xsl:when test="text()='hu'"><language>Hungarian</language></xsl:when>
				<xsl:when test="text()='hun'"><language>Hungarian</language></xsl:when>

				<xsl:when test="text()='en'"><language>English</language></xsl:when>
				<xsl:when test="text()='eng'"><language>English</language></xsl:when>

				<xsl:when test="text()='fr'"><language>French</language></xsl:when>
				<xsl:when test="text()='fre'"><language>French</language></xsl:when>

				<xsl:when test="text()='ru'"><language>Russian</language></xsl:when>
				<xsl:when test="text()='rus'"><language>Russian</language></xsl:when>

				<xsl:when test="text()='pl'"><language>Polish</language></xsl:when>
				<xsl:when test="text()='pol'"><language>Polish</language></xsl:when>

        <xsl:when test="text()='it'"><language>Italian</language></xsl:when>
        <xsl:when test="text()='ita'"><language>Italian</language></xsl:when>

        <xsl:when test="text()='be'"><language>Belarusian</language></xsl:when>
        <xsl:when test="text()='bel'"><language>Belarusian</language></xsl:when>

        <xsl:when test="text()='cs'"><language>Czech</language></xsl:when>
        <xsl:when test="text()='cze'"><language>Czech</language></xsl:when>

        <xsl:when test="text()='es'"><language>Spanish</language></xsl:when>
        <xsl:when test="text()='esp'"><language>Spanish</language></xsl:when>

        <xsl:when test="text()='uk'"><language>Ukranian</language></xsl:when>
        <xsl:when test="text()='ukr'"><language>Ukranian</language></xsl:when>
			</xsl:choose>
			<xsl:if test="not(position()=last())">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="foxml:digitalObject/foxml:datastream[@ID='ITEM-LIB-EN']">
		<h4 class="show-page-section"><i class="fa fa-list"></i>Collection Information</h4>
		<dl class="dl-horizontal  dl-invert data-details">
			[COLLECTION]
		</dl>

		<h4 class="show-page-section"><i class="fa fa-info"></i>General Information</h4>
		<dl class="dl-horizontal  dl-invert data-details">

				<xsl:if test=".//*[@tag='110']">
					<dt>Author:</dt>
					<dd>
						<xsl:for-each select=".//*[@tag='110']/*[@code='a']">
							<div>
								<a>
									<xsl:attribute name="href">
										<xsl:text>/catalog?f[creator_facet][]=</xsl:text>
										<xsl:value-of select="."/>
									</xsl:attribute>
									<xsl:value-of select="."/>
								</a>
							</div>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//*[@tag='242'] or .//*[@tag='245']">
					<dt>Title:</dt>
					<dd class="titleUC">
						<xsl:for-each select=".//*[@tag='245']/*[@code='a']">
							<xsl:value-of select="."/>
							<xsl:text/>
						</xsl:for-each>
						<xsl:for-each select=".//*[@tag='242']/*[@code='a']">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="."/>
							<xsl:text>]</xsl:text>
						</xsl:for-each>
						<xsl:for-each select=".//*[@tag='245']/*[@code='b']">
							<xsl:choose>
							<xsl:when test="substring(.,1,1)!='/'">
								<xsl:text> : </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> </xsl:text>
							</xsl:otherwise>
							</xsl:choose>
							<xsl:value-of select="."/>
						</xsl:for-each>
						<xsl:for-each select=".//*[@tag='245']/*[@code='c']">
							<xsl:text> / </xsl:text>
							<xsl:value-of select="."/>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//*[@tag='250']/*[@code='a']">
					<dt>Edition:</dt>
					<dd>
						<xsl:for-each select=".//*[@tag='250']/*[@code='a']">
							<xsl:value-of select="."/>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//*[@tag='260']/*[@code='a'] or .//*[@tag='260']/*[@code='b']">
					<dt>Published:</dt>
					<dd>
						<xsl:for-each select=".//*[@tag='260']/*[@code='a']">
							<xsl:value-of select="."/>
							<xsl:text> : </xsl:text>
						</xsl:for-each>
						<xsl:for-each select=".//*[@tag='260']/*[@code='b']">
							<xsl:value-of select="."/>
							<xsl:if test="not(position() = last())">
								<xsl:text> ; </xsl:text>
							</xsl:if>
							<xsl:if test="position() = last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select=".//*[@tag='260']/*[@code='c']">
							<xsl:value-of select="."/>
						</xsl:for-each>
						<xsl:if test=".//*[@tag='260']/*[@code='e'] or .//*[@tag='260']/*[@code='f']">
							<xsl:text> (</xsl:text>
							<xsl:for-each select=".//*[@tag='260']/*[@code='e']">
								<xsl:value-of select="."/>
								<xsl:if test="not(position() = last())">
									<xsl:text>; </xsl:text>
								</xsl:if>
							<xsl:if test=".//*[@tag='260']/*[@code='f']">
								<xsl:text> : </xsl:text>
							</xsl:if>
							</xsl:for-each>
							<xsl:for-each select=".//*[@tag='260']/*[@code='f']">
								<xsl:value-of select="."/>
								<xsl:if test="not(position() = last())">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:for-each>
							<xsl:text>)</xsl:text>
						</xsl:if>
					</dd>
				</xsl:if>

				<xsl:if test=".//*[@tag='041']">
					<dt>Language:</dt>
					<dd>
						<xsl:apply-templates select="//foxml:datastream[@ID='ITEM-LIB-EN']//*[@tag='041']"/>
					</dd>
				</xsl:if>

				<xsl:if test=".//*[@tag='300']">
					<dt>Physical Description:</dt>
					<dd>
						<xsl:for-each select=".//*[@tag='300']/*[@code='a']">
							<xsl:value-of select="."/>
						</xsl:for-each>
						<xsl:text> </xsl:text>
						<xsl:for-each select=".//*[@tag='300']/*[@code='b']">
							<xsl:value-of select="."/>
						</xsl:for-each>
						<xsl:text> </xsl:text>
						<xsl:for-each select=".//*[@tag='300']/*[@code='c']">
							<xsl:value-of select="."/>
						</xsl:for-each>

					</dd>
				</xsl:if>

			</dl>

			<h4 class="show-page-section"><i class="fa fa-list"></i>Content</h4>
			<dl class="dl-horizontal  dl-invert data-details">

				<xsl:if test=".//*[@tag='520']">
					<dt>Summary:</dt>
					<dd>
						<xsl:value-of select=".//*[@tag='520']/*[@code='a']"/>
					</dd>
				</xsl:if>

			</dl>

			<h4 class="show-page-section"><i class="fa fa-paperclip"></i>Context</h4>
      <dl class="dl-horizontal  dl-invert data-details">

				<xsl:if test=".//*[@tag='500'] or .//*[@tag='515'] or .//*[@tag='310'] or .//*[@tag='546'] or .//*[@tag='550']">
					<dt>Note:</dt>
					<dd>
						<xsl:for-each select=".//*[@tag='500']/*[@code='a']">
						<div>
							<xsl:value-of select="."/>
						</div>
						</xsl:for-each>
						<xsl:for-each select=".//*[@tag='515']/*[@code='a']">
						<div>
							<xsl:value-of select="."/>
						</div>
						</xsl:for-each>
						<xsl:for-each select=".//*[@tag='310']/*[@code='a']">
						<div>
							<xsl:value-of select="."/>
						</div>
						</xsl:for-each>
						<xsl:for-each select=".//*[@tag='546']/*[@code='a']">
						<div>
							<xsl:value-of select="."/>
						</div>
						</xsl:for-each>
						<xsl:for-each select=".//*[@tag='550']/*[@code='a']">
						<div>
							<xsl:value-of select="."/>
						</div>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//*[@tag='580']">
					<dt>Source:</dt>
					<dd>
						<xsl:value-of select=".//*[@tag='580']/*[@code='a']"/>
					</dd>
				</xsl:if>

				<xsl:if test=".//*[@tag='773']">
					<dt>Related Title:</dt>
					<dd>
					<xsl:for-each select=".//*[@tag='773']/*[@code='t']">
							<div>
									<xsl:value-of select="."/>
							</div>
						</xsl:for-each>
					</dd>
				</xsl:if>

				<xsl:if test=".//*[@tag='700'] or .//*[@tag='710']">
					<dt>Additional Authors/Names:</dt>
					<dd>
						<xsl:for-each select=".//*[@tag='700']">
							<div>
								<a>
									<xsl:attribute name="href">
										<xsl:text>/catalog?f[added_person_facet][]=</xsl:text>
										<xsl:value-of select="*[@code='a']"/>
									</xsl:attribute>
									<xsl:value-of select="*[@code='a']"/>
								</a>
								<xsl:if test="*[@code='d']">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="*[@code='d']"/>
								</xsl:if>
								<xsl:if test="*[@code='e']">
									<xsl:text> (</xsl:text>
									<xsl:value-of select="*[@code='e']"/>
									<xsl:text>)</xsl:text>
								</xsl:if>

							</div>
						</xsl:for-each>
						<xsl:for-each select=".//*[@tag='710']">
								<div>
							<a>
									<xsl:attribute name="href">
										<xsl:text>/catalog?f[added_corporation_facet][]=</xsl:text>
										<xsl:value-of select="*[@code='a']"/>
												<xsl:if test="*[@code='b']">

												<xsl:value-of select="*[@code='b']"/>
										</xsl:if>
									</xsl:attribute>
									<xsl:value-of select="*[@code='a']"/>
									<xsl:if test="*[@code='b']">
										<xsl:value-of select="*[@code='b']"/>
									</xsl:if>
							</a>
								</div>
						</xsl:for-each>
					</dd>
				</xsl:if>

			</dl>

			<h4 class="show-page-section"><i class="fa fa-globe"></i>Coverage</h4>
			<dl class="dl-horizontal  dl-invert data-details">

				<xsl:if test=".//*[@tag='653']">
					<dt>Collection Specific Tags:</dt>
					<dd>
						<xsl:for-each select=".//*[@tag='653']/*[@code='a']">
							<a>
								<xsl:attribute name="href">
									<xsl:text>/catalog?f[subject_facet][]=</xsl:text>
									<xsl:value-of select="."/>
								</xsl:attribute>
								<xsl:value-of select="."/>
							</a>
							<xsl:if test="not(position() = last())">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</dd>
				</xsl:if>
				<xsl:if test=".//*[@tag='600'] or .//*[@tag='610'] or .//*[@tag='650']">
					<dt>Subjects:</dt>
					<dd>
						<xsl:for-each select=".//*[@tag='600']">
						<div>
							<a>
								<xsl:attribute name="href">
									<xsl:text>/catalog?f[subject_person_facet][]=</xsl:text>
									<xsl:value-of select="./*[@code='a']"/>
									<xsl:if test="./*[@code='d']">
										<xsl:text> </xsl:text>
										<xsl:value-of select="./*[@code='d']"/>
									</xsl:if>
								</xsl:attribute>
								<xsl:value-of select="./*[@code='a']"/>
								<xsl:if test="./*[@code='d']">
									<xsl:text> </xsl:text>
									<xsl:value-of select="./*[@code='d']"/>
								</xsl:if>
							</a>
						</div>
						</xsl:for-each>

						<xsl:for-each select=".//*[@tag='610']">
						<div>
							<a>
								<xsl:attribute name="href">
									<xsl:text>/catalog?f[subject_corporation_facet][]=</xsl:text>
									<xsl:value-of select="./*[@code='a']"/>
									<xsl:if test="./*[@code='b']">
										<xsl:text> </xsl:text>
										<xsl:value-of select="./*[@code='b']"/>
									</xsl:if>
								</xsl:attribute>
								<xsl:value-of select="./*[@code='a']"/>
								<xsl:if test="./*[@code='b']">
									<xsl:text> </xsl:text>
									<xsl:value-of select="./*[@code='b']"/>
								</xsl:if>
							</a>
						</div>
						</xsl:for-each>

						<xsl:for-each select=".//*[@tag='650']">
						<div>
							<a>
								<xsl:attribute name="href">
									<xsl:text>/catalog?f[subject_facet][]=</xsl:text>
									<xsl:value-of select="./*[@code='a']"/>
									<xsl:if test="./*[@code='z']">
										<xsl:text> -- </xsl:text>
										<xsl:value-of select="./*[@code='z']"/>
									</xsl:if>
								</xsl:attribute>
								<xsl:value-of select="./*[@code='a']"/>
								<xsl:if test="./*[@code='z']">
									<xsl:text> -- </xsl:text>
									<xsl:value-of select="./*[@code='z']"/>
								</xsl:if>
							</a>
						</div>
						</xsl:for-each>

					</dd>
				</xsl:if>

				<xsl:if test=".//*[@tag='651']">
					<dt>Additional Places:</dt>
					<dd>
						<xsl:for-each select=".//*[@tag='651']/*[@code='a']">
							<div>
								<a>
									<xsl:attribute name="href">
										<xsl:text>/catalog?f[subject_geo_facet][]=</xsl:text>
										<xsl:value-of select="."/>
									</xsl:attribute>
									<xsl:value-of select="."/>
								</a>
							</div>
						</xsl:for-each>
					</dd>
				</xsl:if>
				<xsl:if test=".//*[@tag='655']">
					<dt>Form/Genre:</dt>
					<dd>
						<xsl:for-each select=".//*[@tag='655']/*[@code='a']">
							<div>
								<a>
									<xsl:attribute name="href">
										<xsl:text>/catalog?f[genre_facet][]=</xsl:text>
										<xsl:value-of select="."/>
									</xsl:attribute>
									<xsl:value-of select="."/>
								</a>
							</div>
						</xsl:for-each>
					</dd>
				</xsl:if>

			</dl>

			<h4 class="show-page-section"><i class="fa fa-copyright"></i>Access and Use</h4>
			<dl class="dl-horizontal  dl-invert data-details">

			[RIGHTS]

				<xsl:if test=".//*[@tag='099']">
					<dt>Library ID:</dt>
					<dd>
						<xsl:value-of select=".//*[@tag='099']/*[@code='a']"/>
						<xsl:value-of select=".//*[@tag='099']/*[@code='f']"/>
						<xsl:value-of select=".//*[@tag='099']/*[@code='e']"/>
					</dd>
				</xsl:if>

				<dt>Suggested Citation:</dt>
				<dd>
				<!-- Title -->
				<xsl:if test=".//*[@tag='242'] or .//*[@tag='245']">
					<xsl:for-each select=".//*[@tag='245']/*[@code='a']">
						<xsl:text>"</xsl:text>
						<xsl:value-of select="."/>
						<xsl:text>"</xsl:text>
					</xsl:for-each>
					<xsl:for-each select=".//*[@tag='242']/*[@code='a']">
						<xsl:text> [</xsl:text>
						<xsl:value-of select="."/>
						<xsl:text>]</xsl:text>
					</xsl:for-each>
					<xsl:for-each select=".//*[@tag='245']/*[@code='c']">
						<xsl:text> / </xsl:text>
						<xsl:value-of select="."/>
					</xsl:for-each>
					<xsl:text>,</xsl:text>
				</xsl:if>
				<!-- Date -->
				<xsl:if test=".//*[@tag='242'] or .//*[@tag='245']">
					<xsl:text> </xsl:text>
					<xsl:value-of select=".//*[@tag='260']/*[@code='c']"/>
					<xsl:text>.</xsl:text>
				</xsl:if>
				<!-- Library ID -->
				<xsl:if test=".//*[@tag='099']">
					<xsl:text> </xsl:text>
					<xsl:value-of select=".//*[@tag='099']/*[@code='a']"/>
					<xsl:value-of select=".//*[@tag='099']/*[@code='f']"/>
					<xsl:text>;</xsl:text>
				</xsl:if>
				<!-- Holdings -->
				<xsl:if test=".//*[@tag='580']">
					<xsl:text> </xsl:text>
					<xsl:value-of select=".//*[@tag='580']/*[@code='a']"/>
					<xsl:text>;</xsl:text>
				</xsl:if>
				<xsl:text> </xsl:text>
				<xsl:text>Open Society Archives at Central European University, Budapest.</xsl:text>
				</dd>

				<dt>Permanent URI:</dt>
				<dd>[HDL]</dd>

				<dt></dt>
				<dd class="info">When you cite the online source, the phrase "[Electronic record]" should be inserted into the standard citation after the item title and date. The citation should be followed by the URI with the date you last accessed the resource in square brackets.</dd>
			</dl>
	</xsl:template>
</xsl:stylesheet>
