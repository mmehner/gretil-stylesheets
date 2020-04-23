<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    exclude-result-prefixes="xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:mm=" ">
  
  <xsl:output method="html"  encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>
  
  <!-- variable for pāda node-set -->
  <xsl:variable name="pAdanodes" select="/gretilcorpus/text/document(@href)/t:TEI/t:text//t:seg[@type='pāda' and not(ancestor::t:note)]"/>

  <!-- templates -->
  <xsl:template match="/">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<title>
	  <xsl:text>Cumulative pāda index of </xsl:text>
	  <xsl:value-of select="gretilcorpus/meta/title"/>
	  <xsl:text> (GRETIL)</xsl:text>
	</title>
	<link rel="stylesheet" type="text/css" href="style/html_style.css" />
      </head>
      <body>
	<h1><xsl:text>Cumulative pāda index of </xsl:text><xsl:value-of select="gretilcorpus/meta/title"/></h1>
	<xsl:element name="h3">Currently including:</xsl:element>
	<xsl:element name="ul">
       	  <xsl:apply-templates select="gretilcorpus/text/document(@href)/t:TEI/t:teiHeader/t:fileDesc/t:titleStmt/t:title"/>
	</xsl:element>
	<hr/>
	<xsl:element name="h2">Index</xsl:element>
	<xsl:element name="ul">
	  <!-- sorted list -->
	  <xsl:for-each select="$pAdanodes">
	    <xsl:sort select="mm:sortkey(string-join(mm:plaintext(.)))"/>
	    <li>
	      <xsl:value-of select="string-join(mm:plaintext(.))"/>
	      <xsl:text> (</xsl:text>
	      <xsl:element name="a">
		<xsl:attribute name="href"><xsl:value-of select="ancestor::t:TEI/@xml:id"/><xsl:text>.htm#</xsl:text><xsl:value-of select="ancestor::t:lg/@xml:id"/></xsl:attribute>
		<xsl:attribute name="title">
		  <xsl:value-of select="ancestor::t:TEI/t:teiHeader/t:fileDesc/t:titleStmt/t:title"/>
		</xsl:attribute>
		<xsl:value-of select="ancestor::t:lg/@xml:id"/><xsl:value-of select="@n"/>
	      </xsl:element>
	      <xsl:text>)</xsl:text>
	    </li>
	  </xsl:for-each>
	</xsl:element>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="t:title">
    <li>
      <xsl:element name="a">
	<xsl:attribute name="href"><xsl:value-of select="ancestor::t:TEI/@xml:id"/><xsl:text>.htm</xsl:text></xsl:attribute>
	<xsl:value-of select="."/>
      </xsl:element>
    </li>
  </xsl:template>
  
  <!-- plaintext-function -->
  <xsl:function name="mm:plaintext">
    <xsl:param name="pAda-node"/>
    <xsl:apply-templates select="$pAda-node" mode="serialize"/>
  </xsl:function>

  <!-- sortkey-function for Sanskrit-->
  <xsl:function name="mm:sortkey">
    <xsl:param name="sortstring"/>
    <xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace($sortstring, '[ -\[\]…]+', ''),
			  'ṃ([kgṅ])', 'ṅ$1'), 
			  'ṃ([cjñ])', 'ñ$1'),
			  'ṃ([ṭḍṇ])', 'ṇ$1'),
			  'ṃ([tdn])', 'n$1'),
			  'ṃ([pbm])', 'm$1'),
			  'ai', '12.'),
			  'au', '14.'),
			  '''''', '02.'),
			  '\.', '00.'),
			  'a', '01.'),
			  '''', '01.'),
			  'ā', '02.'),
			  'i', '03.'),
			  'ī', '04.'),
			  'u', '05.'),
			  'ū', '06.'),
			  'ṛ', '07.'),
			  'ṝ', '08.'),
			  'ḷ', '09.'),
			  'ḹ', '10.'),
			  'e', '11.'),
			  'o', '13.'),
			  'ṃ', '15.'),
			  'ḥ', '16.'),
			  'kh', '18.'),
			  'gh', '20.'),
			  'ch', '23.'),
			  'jh', '25.'),
			  'ṭh', '28.'),
			  'ḍh', '30.'),
			  'th', '33.'),
			  'dh', '35.'),
			  'ph', '38.'),
			  'bh', '40.'),
			  'k', '17.'),
			  'g', '19.'),
			  'ṅ', '21.'),
			  'c', '22.'),
			  'j', '24.'),
			  'ñ', '26.'),
			  'ṭ', '27.'),
			  'ḍ', '29.'),
			  'ṇ', '31.'),
			  't', '32.'),
			  'd', '34.'),
			  'n', '36.'),
			  'p', '37.'),
			  'b', '39.'),
			  'm', '41.'),
			  'y', '42.'),
			  'r', '43.'),
			  'l', '44.'),
			  'v', '45.'),
			  'ś', '46.'),
			  'ṣ', '47.'),
			  's', '48.'),
			  'h', '49.')"/>
  </xsl:function>

  <!-- serialization -->
  <!-- primitives -->
  <xsl:template match="*" mode="serialize">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates mode="serialize"/>
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="@*" mode="serialize">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="text()" mode="serialize">
    <xsl:value-of select="lower-case(replace(., '\s+', ' '))"/>
  </xsl:template>

  <!-- gaps, both illegible and lacunae -->
  <xsl:template match="t:gap" mode="serialize">
    <xsl:choose>
      <xsl:when test="(@quantity and (@unit='akṣaras' or @unit='syllables' or @unit='characters'))">
	<xsl:text>[</xsl:text>
	<xsl:for-each select="1 to @quantity">.. </xsl:for-each>
	<xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>[…]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- choices -->
  <xsl:template match="t:choice" mode="serialize">
    <xsl:value-of select="t:reg"/>
  </xsl:template>

  <!-- apparatus -->
  <xsl:template match="t:app//t:rdg | t:app/t:lem" mode="serialize">
    <xsl:choose>
      <xsl:when test="t:lem">
	<xsl:apply-templates mode="serialize"/>
      </xsl:when>
      <xsl:when test="position() = 1">
	<xsl:apply-templates mode="serialize"/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  
  <!-- skips -->
  <xsl:template match="t:seg" mode="serialize">
    <xsl:apply-templates mode="serialize"/>
  </xsl:template>
  <xsl:template match="t:app" mode="serialize">
    <xsl:apply-templates mode="serialize"/>
  </xsl:template>

  <!-- deletions -->
  <xsl:template match="t:orig" mode="serialize"/>
  <xsl:template match="t:note" mode="serialize"/>
  <xsl:template match="t:ref" mode="serialize"/>
  <xsl:template match="t:witDetail" mode="serialize"/>
  <xsl:template match="t:pb" mode="serialize"/>
  <xsl:template match="t:lb" mode="serialize"/>
  <xsl:template match="t:milestone" mode="serialize"/>
  <xsl:template match="t:link" mode="serialize"/>
  <xsl:template match="t:surplus" mode="serialize"/>
  <xsl:template match="t:del" mode="serialize"/>
  
</xsl:stylesheet>
