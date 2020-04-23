<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  exclude-result-prefixes="xsl" 
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  
  <xsl:output method="text" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
  
  <xsl:preserve-space elements="reg orig"/>
  <xsl:strip-space elements="teiHeader sourceDesc biblStruct monogr listWit witness text body div lg app cit notesStmt note"/>
  
  <!-- variables and keys -->
  <xsl:variable name="n">
    <xsl:text>
</xsl:text>
  </xsl:variable>

  <!-- templates -->
  <xsl:template match="/">
    <xsl:if test="TEI/teiHeader/fileDesc/titleStmt/author[text()]">
      <xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/author"/><xml:text>: </xml:text>
    </xsl:if>
    <xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title"/>
    <xsl:value-of select="$n"/>
    <xsl:value-of select="$n"/>
    <xsl:value-of select="$n"/>
    <xsl:text># Header</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:value-of select="$n"/>
    <xsl:apply-templates select="TEI/teiHeader"/>
    <xsl:value-of select="$n"/>
    <xsl:value-of select="$n"/>
    <xsl:text># Text</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:apply-templates select="TEI/text"/>
  </xsl:template>

  <!-- header -->
  <xsl:template match="teiHeader">
    <xsl:text>  This file is a plain text transformation of http://gretil.sub.uni-goettingen.de/gretil/corpustei/</xsl:text><xsl:value-of select="/TEI/@xml:id"/>
    <xsl:text>.xml</xsl:text><xsl:value-of select="$n"/>
    <xsl:text>  with a rudimentary header. For a more extensive header please refer to the source file.</xsl:text>
    <xsl:value-of select="$n"/><xsl:value-of select="$n"/>
    
    <xsl:text>## Data entry: </xsl:text>
    <xsl:apply-templates select="fileDesc/titleStmt/respStmt[child::resp[contains(.,'data entry')]][child::name]"/>
    <xsl:value-of select="$n"/>

    <xsl:if test="fileDesc/titleStmt/respStmt/resp[contains(.,'contribution to GRETIL')]">
      <xsl:text>## Contribution: </xsl:text>
      <xsl:apply-templates select="fileDesc/titleStmt/respStmt[child::resp[contains(.,'contribution to GRETIL')]][child::name]"/>
      <xsl:value-of select="$n"/>
    </xsl:if>
    
    <xsl:text>## Date of this version: </xsl:text><xsl:value-of select="fileDesc/publicationStmt/date/@when-iso"/>
    <xsl:value-of select="$n"/><xsl:value-of select="$n"/>
    
    <xsl:choose>
      <xsl:when test="count(fileDesc/sourceDesc/biblStruct | fileDesc/sourceDesc/bibl | fileDesc/sourceDesc/listWit/witness | fileDesc/sourceDesc/list/item) = 1">
	<xsl:text>## Source: </xsl:text>
	<xsl:apply-templates select="fileDesc/sourceDesc"/>
      </xsl:when>
      <xsl:when test="count(fileDesc/sourceDesc/biblStruct | fileDesc/sourceDesc/bibl | fileDesc/sourceDesc/listWit/witness | fileDesc/sourceDesc/list/item) > 1">
	<xsl:text>## Sources: </xsl:text>
	<xsl:apply-templates select="fileDesc/sourceDesc"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>## Source: </xsl:text><xsl:text>unknown</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$n"/><xsl:value-of select="$n"/>

    <xsl:text>## Publisher: </xsl:text><xsl:value-of select="fileDesc/publicationStmt/publisher"/>
    <xsl:value-of select="$n"/><xsl:value-of select="$n"/>
    
    <xsl:text>## Licence:</xsl:text><xsl:value-of select="$n"/>
    <xsl:for-each select="fileDesc/publicationStmt/availability/p | fileDesc/publicationStmt/availability/licence">
      <xsl:text>   </xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:value-of select="$n"/>
    </xsl:for-each>
    <xsl:value-of select="$n"/>
    
    <xsl:text>## Structure of references:</xsl:text><xsl:value-of select="$n"/>
    <xsl:text>   A reference is assembled consisting of</xsl:text>
    <xsl:apply-templates select="encodingDesc/refsDecl//list"/>
    
    <xsl:if test="fileDesc/notesStmt/note[text()] | fileDesc/notesStmt/note/p[text()]">
      <xsl:value-of select="$n"/>
      <xsl:text>## Notes:</xsl:text>
      <xsl:value-of select="$n"/>
      <xsl:apply-templates select="fileDesc/notesStmt/note"/>
    </xsl:if>
  </xsl:template>

  <!-- notes in header -->
  <xsl:template match="TEI/teiHeader/fileDesc/notesStmt/note">
    <xsl:choose>
      <xsl:when test="p">
	<xsl:apply-templates select="p"/>
	<xsl:value-of select="$n"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>   </xsl:text><xsl:apply-templates/><xsl:value-of select="$n"/>
	<xsl:value-of select="$n"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- p in header -->
  <xsl:template match="TEI/teiHeader//p">
    <xsl:text>   </xsl:text><xsl:apply-templates/><xsl:value-of select="$n"/>
  </xsl:template>
  
  <!-- lists in header -->
  <xsl:template match="TEI/teiHeader//list">
    <xsl:value-of select="$n"/>
    <xsl:apply-templates select="item"/>
  </xsl:template>

  <xsl:template match="TEI/teiHeader//item">
    <xsl:text>   - </xsl:text><xsl:apply-templates/><xsl:value-of select="$n"/>
  </xsl:template>

  <!-- source-templates -->
  <!-- names -->
  <xsl:template match="respStmt">
    <xsl:choose>
      <xsl:when test="count(child::name) = 1">
	<xsl:value-of select="normalize-space(./name)"/>
      </xsl:when>
      <xsl:when test="count(child::name) = 2">
	<xsl:value-of select="normalize-space(./name[1])"/>
	<xsl:text> and </xsl:text>
	<xsl:value-of select="normalize-space(./name[2])"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="normalize-space(./name[1])"/>
	<xsl:for-each select="./name[count(preceding-sibling::name) > 0][count(following-sibling::name) > 0]">
	  <xsl:text>, </xsl:text>
	  <xsl:value-of select="normalize-space(.)"/>
	</xsl:for-each>
	<xsl:text>, and </xsl:text>
	<xsl:value-of select="normalize-space(./name[count(following-sibling::name) = 0])"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- bibl -->
  <xsl:template match="sourceDesc/bibl | sourceDesc/listWit/witness ">
    <xsl:value-of select="$n"/><xsl:text>   - </xsl:text>
    <xsl:if test="@xml:id">
      <xsl:value-of select="@xml:id"/><xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="substring(normalize-space(.),string-length(normalize-space(.))) = string('.')"><!-- full stop at the end of the text node -->
	<xsl:apply-templates/>
	<!--<xsl:value-of select="normalize-space(.)"/>-->
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
	<!--<xsl:value-of select="normalize-space(.)"/>--><xsl:text>.</xsl:text><!-- no full stop in text node and therefor supplied -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- individual fields for all biblStruct -->
  <!-- multiple authors/editors-->
  <xsl:template match="author[1]">
    <xsl:choose>
      <xsl:when test="count(following-sibling::*[self::author|self::editor]) > 1">
	<xsl:value-of select="normalize-space(.)"/><xsl:text> et al.</xsl:text>
      </xsl:when>
      <xsl:when test="count(following-sibling::*[self::author|self::editor]) = 1">
	<xsl:value-of select="normalize-space(.)"/><xsl:text> and </xsl:text>
	<xsl:apply-templates select="following-sibling::*[self::author|self::editor][1]"/>
      </xsl:when>
      <xsl:when test="count(following-sibling::*[self::author|self::editor]) = 0">
	<xsl:value-of select="normalize-space(.)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="author[2]">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <xsl:template match="editor[1]">
    <xsl:choose>
      <xsl:when test="count(following-sibling::*[self::author|self::editor]) > 1">
	<xsl:value-of select="normalize-space(.)"/><xsl:text> (ed.) et al.</xsl:text>
      </xsl:when>
      <xsl:when test="count(following-sibling::author) = 1">
	<xsl:value-of select="normalize-space(.)"/><xsl:text> (ed.) and </xsl:text>
	<xsl:apply-templates select="following-sibling::*[self::author|self::editor][1]"/>
      </xsl:when>
      <xsl:when test="count(following-sibling::editor) = 1">
	<xsl:value-of select="normalize-space(.)"/><xsl:text> and </xsl:text>
	<xsl:apply-templates select="following-sibling::*[self::author|self::editor][1]"/>
      </xsl:when>
      <xsl:when test="count(following-sibling::editor) = 0">
	<xsl:value-of select="normalize-space(.)"/><xsl:text> (ed.)</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="editor[2]">
    <xsl:value-of select="normalize-space(.)"/><xsl:text> (eds.)</xsl:text>
  </xsl:template>
  
  <!-- volume(s) in monogr -->
  <xsl:template match="monogr/biblScope[@unit='volume']">
    <xsl:text> (Vol. </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="monogr/biblScope[@unit='volumes']">
    <xsl:text> (</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text> Vols.)</xsl:text>
  </xsl:template>

  <!-- series -->
  <xsl:template match="series[1]">
    <xsl:text> (</xsl:text>
    <xsl:value-of select="normalize-space(./title)"/>
    <xsl:if test="./biblScope[@unit='volume']">
      <xsl:text> </xsl:text>
      <xsl:value-of select="normalize-space(./biblScope[@unit='volume'])"/>
    </xsl:if>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- types of biblStruct -->
  <!-- monographs -->
  <xsl:template match="sourceDesc/biblStruct[child::monogr][not(child::analytic)]">
    <xsl:value-of select="$n"/><xsl:text>   - </xsl:text>
    <xsl:apply-templates select="./monogr/*[self::author|self::editor][1]"/><xsl:text>: </xsl:text>
    <xsl:value-of select="./monogr/title"/>
    <xsl:apply-templates select="./monogr/biblScope"/>
    <xsl:text>. </xsl:text>
    <xsl:value-of select="./monogr/imprint/pubPlace"/><xsl:text> </xsl:text>
    <xsl:choose>
      <xsl:when test="./monogr/imprint/date/@when-iso">
	<xsl:value-of select="./monogr/imprint/date/@when-iso"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="./monogr/imprint/date"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="./series[1]"/>
    <xsl:text>.</xsl:text>
  </xsl:template>

  <!-- article in collection -->
  <xsl:template match="sourceDesc/biblStruct[child::analytic[child::title]][child::monogr[not(child::title[@level='j'])]]">
    <xsl:value-of select="$n"/><xsl:text>   - </xsl:text>
    <xsl:if test="./analytic/*[self::author|self::editor]">
      <xsl:apply-templates select="./analytic/*[self::author|self::editor][1]"/><xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:text>»</xsl:text>
    <xsl:value-of select="./analytic/title"/><xsl:text>.« In: </xsl:text>
    <xsl:if test="./monogr/*[self::author|self::editor]/text()">
      <xsl:apply-templates select="./monogr/*[self::author|self::editor][1]"/><xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:value-of select="./monogr/title"/><xsl:text>. </xsl:text>
    <xsl:value-of select="./monogr/imprint/pubPlace"/><xsl:text> </xsl:text>
    <xsl:choose>
      <xsl:when test="./monogr/imprint/date/@when-iso">
	<xsl:value-of select="./monogr/imprint/date/@when-iso"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="./monogr/imprint/date"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="./series[1]"/><xsl:text>, pp. </xsl:text>
    <xsl:value-of select="./monogr/biblScope[@unit='page']"/>
    <xsl:text>.</xsl:text>
  </xsl:template>
  
  <!-- article in journal -->
  <xsl:template match="sourceDesc/biblStruct[child::analytic[child::title]][child::monogr[child::title[@level='j']]]">
    <xsl:value-of select="$n"/><xsl:text>   - </xsl:text>
    <xsl:apply-templates select="./analytic/*[self::author|self::editor][1]"/><xsl:text>: »</xsl:text>
    <xsl:value-of select="./analytic/title"/><xsl:text>.« In: </xsl:text>
    <xsl:value-of select="./monogr/title"/><xsl:text> </xsl:text>
    <xsl:value-of select="./monogr/biblScope[@unit='volume']"/><xsl:text> (</xsl:text>
    <xsl:choose>
      <xsl:when test="./monogr/imprint/date/@when-iso">
	<xsl:value-of select="./monogr/imprint/date/@when-iso"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="./monogr/imprint/date"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>), pp. </xsl:text>
    <xsl:value-of select="./monogr/biblScope[@unit='page']"/>
    <xsl:text>.</xsl:text>
  </xsl:template>
  
  
  <!-- text -->
  <!-- normalize output on all text nodes -->
  <xsl:template match="TEI/text//text()">
    <xsl:value-of select="lower-case(replace(., '\s+', ' '))"/>
  </xsl:template>

  <!--add whitespace for different contexts -->
  <xsl:template match="head">
    <xsl:value-of select="$n"/>
    <xsl:value-of select="$n"/>
    <xsl:apply-templates/>
    <xsl:value-of select="$n"/>
  </xsl:template>

  <xsl:template match="trailer">
    <xsl:value-of select="$n"/>
    <xsl:apply-templates/>
    <xsl:value-of select="$n"/>
  </xsl:template>

  <xsl:template match="p">
    <xsl:value-of select="$n"/>
    <xsl:apply-templates/>
    <xsl:if test="@xml:id">
      <xsl:text>(</xsl:text><xsl:call-template name="id2inlineref"/><xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:value-of select="$n"/>
  </xsl:template>

  <xsl:template match="lg">
    <xsl:value-of select="$n"/>
    <xsl:apply-templates/>
    <!-- print id if specified -->
    <xsl:if test="@xml:id">
      <xsl:text> </xsl:text><xsl:call-template name="id2inlineref"/>
    </xsl:if>
    <xsl:value-of select="$n"/>
  </xsl:template>

  <xsl:template match="lg/l">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::l">
      <xsl:value-of select="$n"/>
    </xsl:if>
  </xsl:template>
  
  <!-- prose div with ID -->
  <xsl:template match="div[@xml:id]">
    <xsl:apply-templates/>
    <xsl:text>(</xsl:text><xsl:call-template name="id2inlineref"/><xsl:text>)</xsl:text>
    <xsl:value-of select="$n"/>
  </xsl:template>

  <!-- commentary -->
  <xsl:template match="note[@type='commentary']">
    <xsl:element name="div">
      <xsl:apply-templates/>
      <!-- add id if specified -->
      <xsl:if test="@xml:id">
	<xsl:text>(</xsl:text><xsl:call-template name="id2inlineref"/><xsl:text>)</xsl:text>
	<xsl:value-of select="$n"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!-- add changed IDs inline -->
  <xsl:template name="id2inlineref">
    <xsl:choose>
      <!-- with @n attribute, always replace @xml:id -->
      <xsl:when test="@n">
	<xsl:value-of select="@n"/>
      </xsl:when>
      <!-- 4 levels -->
      <xsl:when test="matches(@xml:id, '\w+_\d+\.\d+\.\d+\.\d+')">
	<xsl:value-of select="replace(@xml:id, '(\w+_\d+)\.(\d+)\.(\d+)\.(\d+)', '$1;$2,$3.$4')"/>
      </xsl:when>
      <!-- 3 levels -->
      <xsl:when test="matches(@xml:id, '\w+_\d+\.\d+\.\d+')">
	<xsl:value-of select="replace(@xml:id, '(\w+_\d+)\.(\d+)\.(\d+)', '$1,$2.$3')"/>
      </xsl:when>
      <!-- 2 & 1 levels -->
      <xsl:otherwise>
	<xsl:value-of select="@xml:id"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- if corresp exists -->
    <xsl:if test="@corresp">
      <xsl:text> [= </xsl:text>
      <xsl:choose>
	<xsl:when test="starts-with(@corresp, '#')"><!-- internal link-->
	  <xsl:call-template name="id2inlinecorresp"/>
	</xsl:when>
	<xsl:when test="contains(@corresp, '.xml#')"><!-- external link-->
	    <xsl:call-template name="id2inlinecorresp"/>
	</xsl:when>
	<xsl:otherwise><!-- not a link-->
	  <xsl:value-of select="@corresp"/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="id2inlinecorresp">
    <xsl:choose>
      <!-- 4 levels -->
      <xsl:when test="matches(substring-after(@corresp, '#'), '\w+_\d+\.\d+\.\d+\.\d+')">
	<xsl:value-of select="replace(substring-after(@corresp, '#'), '(\w+_\d+)\.(\d+)\.(\d+)\.(\d+)', '$1;$2,$3.$4')"/>
      </xsl:when>
      <!-- 3 levels -->
      <xsl:when test="matches(substring-after(@corresp, '#'), '\w+_\d+\.\d+\.\d+')">
	<xsl:value-of select="replace(substring-after(@corresp, '#'), '(\w+_\d+)\.(\d+)\.(\d+)', '$1,$2.$3')"/>
      </xsl:when>
      <!-- 2 & 1 levels -->
      <xsl:otherwise>
	<xsl:value-of select="substring-after(@corresp, '#')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- choices -->
  <xsl:template match="choice">
    <xsl:value-of select="reg"/>
  </xsl:template>

  <!-- apparatus -->
  <xsl:template match="app//rdg | app/lem">
    <xsl:choose>
      <xsl:when test="lem">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="position() = 1">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

  <!-- special rules for header -->
  <!-- keep refs in header -->
  <xsl:template match="teiHeader//ref">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- gaps, both illegible and lacunae -->
  <xsl:template match="gap">
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
  
  <!-- deletions -->
  <xsl:template match="teiHeader/*"/>
  <xsl:template match="note"/>
  <xsl:template match="ref"/>
  <xsl:template match="witDetail"/>
  <xsl:template match="orig"/>
  <xsl:template match="pb"/>
  <xsl:template match="lb"/>
  <xsl:template match="milestone"/><!-- milestone-units, currently in use: with @unit="speaker" for a change of speakers inside <lg/> -->
  <xsl:template match="link"/>
  <xsl:template match="surplus"/>
  <xsl:template match="del"/>

  <!-- skips -->
  <xsl:template match="seg">
    <xsl:apply-templates/>
  </xsl:template>
  
</xsl:stylesheet>
