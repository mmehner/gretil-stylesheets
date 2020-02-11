<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    exclude-result-prefixes="xsl"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  
  <xsl:output method="xhtml"  encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>

  <!-- preliminary deletions -->
  
  <!-- templates -->
  <xsl:template match="/">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<title>
	  <xsl:if test="TEI/teiHeader/fileDesc/titleStmt/author[text()]">
	    <xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/author"/><xsl:text>: </xsl:text>
	  </xsl:if>
	  <xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title"/> (GRETIL)
	</title>
	<style>
	  @font-face {
	  font-family: LinuxLibertineDisplay0Regular, times, serif;
	  src: url(fonts/LinLibertine_DR.woff);
	  }
	  * {box-sizing: border-box;}
	  body {background-color: #FFFFFF; font-family: 'LinuxLibertineDisplayORegular'; font-weight: normal; font-style: normal; padding: 20px 40px 20px;}

	  ul {list-style: circle;}
	  
	  ul.dash {list-style: none; margin-left: .5em; padding-left: .5em;}
	  ul.dash <xsl:text disable-output-escaping='yes'>&gt;</xsl:text> li:before {display: inline-block; content: "–"; width: 1em; margin-left: 0em;}

	  a:link {color: black; text-decoration: underline;}
	  
	  a:visited {color: black; text-decoration: underline;}
	  
	  a:hover {color: black; text-decoration: none;}
	  
	  a:active {color: black; text-decoration: underline;}
	  
	  h4 {margin-bottom: 0px;}
	  mark {background-color: #FFFFCC;}
	  q:before {content: "»";}
	  q:after {content: "«";}
	  .stdindent {padding-left: .5em; padding-right: .5em;}
	  .noindent {padding: 0px;}
	  .comm {padding-left: 1em; padding-right: 1em;}
	  .app {width: 80%; text-align: right; font-size: 13px; padding-left: 1em;}
	  .lem {display:inline-block;}
	  .ref {font-size: 13px; padding: inherit;}
	  .lb {font-weight: bold; font-size: 13px;}
	  .lb:before {content: "["}
	  .lb:after {content: "]"}
	  .pb {font-weight: bold; font-size: 13px;}
	  .pb:before {content: " ["}
	  .pb:after {content: "] "}
	  .note {font-weight: bold; font-size: 13px;}
	  .note:before {content: " ["}
	  .note:after {content: "] "}
	  .subhead {font-weight: bold; font-size: 13px;}
	  .appnote {font-size: 13px;}
	  .appnote:before {content: " ["}
	  .appnote:after {content: "] "}
	  .hi {font-style: italic}
	  .sic:before {content: "†"}
	  .sic:after {content: "†"}
	  .corr {color: #008000;}
	  .supplied {color: #1E90FF;}
	  .surplus {color: #ff3333;}
	  .unclear {color: #D2B48C;}

	  .row:after {content: ""; display: table; clear: both;}
	  .column {float: left; width: 50%; padding-left: .5em; padding-right: .5em;}
	  .analysis {font-size: 13px; color: #0066ff; padding-left: .5em; padding-right: .5em; padding-top: .1em;}
	  .analysis:before {content: "["}
	  .analysis:after {content: "]"}
	  
	  div.wapp:hover  span.lem {background-color: #FFFFCC;}
	  
	  
	  @media screen and (max-width: 800px) {
	  body {padding: 0px;}
	  .column {width: 100%;}
	  .analysis {width: 100%;}
	  }

	  @media screen and (max-width: 1100px) {
	  body {padding: 0px;}
	  .app {width: 90%;}
	  }
	  
	  #toc_container {background: #f9f9f9 none repeat scroll 0 0; border: 1px solid #aaa; display: table; font-size: 95%; margin-bottom: 1em; padding: 1em; width: auto;}
	  .toc_title {font-weight: 700; text-align: center;}	  
	  #toc_container li, #toc_container ul, #toc_container ul li{list-style: outside none none !important; padding-left: .5em;}
	</style> 
      </head>
      <body>
	<h1>
	  <xsl:if test="TEI/teiHeader/fileDesc/titleStmt/author[text()]">
	    <xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/author"/><xsl:text>: </xsl:text>
	  </xsl:if>
	  <xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title"/>
	</h1>
	<xsl:if test="TEI/teiHeader/encodingDesc/refsDecl//label[@type='tocinclude']">
	  <xsl:call-template name="toc"/>
	</xsl:if>
	<xsl:apply-templates select="TEI/teiHeader"/>
	<hr/>
	<xsl:apply-templates select="TEI/text"/>
      </body>
    </html>
  </xsl:template>

  <!-- if nothing else matches: identity transformation for text nodes -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>

  <!-- general skips -->
  <xsl:template match="email | orig | cit | s | seg">
    <xsl:apply-templates select="node()" />
  </xsl:template>

  <!-- general skips for elements with attributes-->
  
  <!-- generate ids for toc -->
  <xsl:template match="div[@type]">
    <xsl:element name="{local-name()}">
      <!--<xsl:attribute name="title">
	  <xsl:value-of select="@n"/>
	  </xsl:attribute>-->
      <xsl:attribute name="id">
	<xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <xsl:if test="@xml:id">
	<xsl:element name="div">
	  <xsl:attribute name="class">
	    <xsl:text>ref</xsl:text>
	  </xsl:attribute>
	  <xsl:text>(</xsl:text>
	  <xsl:call-template name="id2inlineref"/>
	  <xsl:text>)</xsl:text>
	</xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!-- toc -->
  <xsl:template name="toc">
    <xsl:element name="div">
      <xsl:attribute name="id">toc_container</xsl:attribute>
      <p class="toc_title">Contents of
      <xsl:value-of select="TEI/text/@xml:id"/>
      </p>
      <xsl:element name="ul">
	<xsl:attribute name="class">toc_list</xsl:attribute>
	<xsl:apply-templates mode="toc" select="/TEI/text/body//div[@type = /TEI/teiHeader/encodingDesc/refsDecl//label[@type='tocinclude']/text()][not(ancestor::div[@type = /TEI/teiHeader/encodingDesc/refsDecl//label[@type='tocinclude']/text()])]"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template mode="toc" match="div">
    <li>
      <xsl:call-template name="tocitem"/>
      <xsl:choose>
	<xsl:when test="child::div[@type = /TEI/teiHeader/encodingDesc/refsDecl//label[@type='tocinclude']/text()]">
	  <ul>
	    <xsl:apply-templates mode="toc" select="child::div[@type = /TEI/teiHeader/encodingDesc/refsDecl//label[@type='tocinclude']/text()]"/>
	  </ul>
	</xsl:when>
	<xsl:when test="descendant::div[@type = /TEI/teiHeader/encodingDesc/refsDecl//label[@type='tocinclude']/text()]">
	  <ul>
	    <xsl:for-each select="*[child::div[@type = /TEI/teiHeader/encodingDesc/refsDecl//label[@type='tocinclude']/text()]][1]">
	      <xsl:apply-templates mode="toc" select="child::div[@type = /TEI/teiHeader/encodingDesc/refsDecl//label[@type='tocinclude']/text()]"/>
	    </xsl:for-each>
	  </ul>
	</xsl:when>
	<xsl:otherwise/>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template name="tocitem">
    <xsl:element name="a">
      <xsl:attribute name="href">
	<xsl:text>#</xsl:text><xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:value-of select="@type"/><xsl:text> </xsl:text>
      <xsl:call-template name="id2tocnumber"/>
    </xsl:element>
  </xsl:template>

  <!-- add id-numbers to toc -->
  <xsl:template name="id2tocnumber">
    <xsl:choose>
      <xsl:when test="@n">
	<xsl:value-of select="@n"/>
      </xsl:when>
      <!-- 4 levels -->
      <xsl:when test="matches(@xml:id, '\w+_\d+\.\d+\.\d+\.\d+')">
	<xsl:value-of select="replace(@xml:id, 'w+_(\d+)\.(\d+)\.(\d+)\.(\d+)', '$1;$2,$3.$4')"/>
      </xsl:when>
      <!-- 3 levels -->
      <xsl:when test="matches(@xml:id, '\w+_\d+\.\d+\.\d+')">
	<xsl:value-of select="replace(@xml:id, '\w+_(\d+)\.(\d+)\.(\d+)', '$1,$2.$3')"/>
      </xsl:when>
      <!-- 2 & 1 levels -->
      <xsl:otherwise>
	<xsl:value-of select="replace(@xml:id, '\w+_([\d.]+)', '$1')"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- if corresp exists -->
    <xsl:if test="@corresp">
      <xsl:text> [= </xsl:text>
      <xsl:choose>
	<xsl:when test="starts-with(@corresp, '#')"><!-- internal link-->
	  <a href="{@corresp}">
	    <xsl:call-template name="id2inlinecorresp"/>
	  </a>
	</xsl:when>
	<xsl:when test="contains(@corresp, '.xml#')"><!-- external link-->
	  <xsl:element name="a">
	    <xsl:attribute name="href">
	      <xsl:value-of select="replace(@corresp, '.xml', '.htm')"/>
	    </xsl:attribute>
	    <xsl:attribute name="target">
	      <xsl:text>_blank</xsl:text>
	    </xsl:attribute>
	    <xsl:call-template name="id2inlinecorresp"/>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise><!-- not a link-->
	  <xsl:value-of select="@corresp"/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>


  <!-- header -->
  <xsl:template match="teiHeader">
    <xsl:element name="h2">Header</xsl:element>
    <p>
      This file is an html transformation of <a href="http://gretil.sub.uni-goettingen.de/gretil/corpustei/{/TEI/@xml:id}.xml"><xsl:value-of select="/TEI/@xml:id"/>.xml</a> with a rudimentary header. For a more extensive header please refer to the source file.
    </p>
    
    <xsl:element name="p">
      <xsl:attribute name="class">noindent</xsl:attribute>
      <b>Data entry: </b>
      <xsl:apply-templates select="fileDesc/titleStmt/respStmt[child::resp[contains(.,'data entry')]][child::name]"/>
    </xsl:element>

    
    <xsl:if test="fileDesc/titleStmt/respStmt/resp[contains(.,'contribution to GRETIL')]">
      <p class="noindent">
	<b>Contribution: </b>
	<xsl:apply-templates select="fileDesc/titleStmt/respStmt[child::resp[contains(.,'contribution to GRETIL')]][child::name]"/>
      </p>
    </xsl:if>

    <p class="noindent">
      <b>Date of this version: </b><xsl:value-of select="fileDesc/publicationStmt/date/@when-iso"/>
    </p>
    
    <xsl:choose>
      <xsl:when test="count(fileDesc/sourceDesc/biblStruct | fileDesc/sourceDesc/bibl | fileDesc/sourceDesc/listWit/witness) = 1">
	<xsl:element name="h4">
	  <if test="fileDesc/sourceDesc/@xml:id">
	    <xsl:attribute  name="id">
	      <xsl:value-of select="fileDesc/sourceDesc/@xml:id"/>
	    </xsl:attribute>
	  </if>
	  Source:
	</xsl:element>
	<xsl:element name="ul">
	  <xsl:attribute name="class">dash</xsl:attribute>
	  <xsl:apply-templates select="fileDesc/sourceDesc/biblStruct | fileDesc/sourceDesc/bibl | fileDesc/sourceDesc/listWit/witness"/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="count(fileDesc/sourceDesc/biblStruct | fileDesc/sourceDesc/bibl | fileDesc/sourceDesc/listWit/witness) > 1">
	<xsl:element name="h4">
	  <if test="fileDesc/sourceDesc/@xml:id">
	    <xsl:attribute  name="id">
	      <xsl:value-of select="fileDesc/sourceDesc/@xml:id"/>
	    </xsl:attribute>
	  </if>
	  Sources:
	</xsl:element>
	<xsl:element name="ul">
	  <xsl:attribute name="class">dash</xsl:attribute>
	  <xsl:apply-templates select="fileDesc/sourceDesc/biblStruct | fileDesc/sourceDesc/bibl | fileDesc/sourceDesc/listWit/witness"/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<p class="noindent"><b>Source: </b>unknown</p>
      </xsl:otherwise>
    </xsl:choose>

    <p class="noindent">
      <b>Publisher: </b><xsl:value-of select="fileDesc/publicationStmt/publisher"/>
    </p>
    
    <h4>Licence:</h4>
    <xsl:apply-templates select="fileDesc/publicationStmt/availability/p"/>
    <xsl:apply-templates select="fileDesc/publicationStmt/availability/licence"/>

    <xsl:choose>
      <xsl:when test="/TEI/text/body//hi | /TEI/text/body//sic | /TEI/text/body//note[not(@type[.='commentary' or .='apparatus' or .='analysis'])] | /TEI/text/body//mentioned | /TEI/text/body//note[@type='analysis'] | /TEI/text/body//unclear | /TEI/text/body//del | /TEI/text/body//corr | /TEI/text/body//supplied | /TEI/text/body//surplus | /TEI/text/body//app">
	<h4>Interpretive markup:</h4>
	<xsl:element name="ul">
	  <xsl:attribute name="class">dash</xsl:attribute>
	  <xsl:if test="/TEI/text/body//hi">
	    <li><span class="hi">highlighted text</span></li>
	  </xsl:if>
	  <xsl:if test="/TEI/text/body//sic">
	    <li><span class="sic">corruptions</span></li>
	  </xsl:if>
	  <xsl:if test="/TEI/text/body//unclear">
	    <li><span class="unclear">unclear</span></li>
	  </xsl:if>
	  <xsl:if test="/TEI/text/body//del">
	    <li><del>deleted material</del></li>
	  </xsl:if>
	  <xsl:if test="/TEI/text/body//corr">
	    <li><span class="corr">corrections</span></li>
	  </xsl:if>
	  <xsl:if test="/TEI/text/body//supplied">
	    <li><span class="supplied">supplied material</span></li>
	  </xsl:if>
	  <xsl:if test="/TEI/text/body//surplus">
	    <li><span class="surplus">surplus material, as deemed by an editor</span></li>
	  </xsl:if>
	  <xsl:if test="/TEI/text/body//note[not(@type[.='commentary' or .='apparatus' or .='analysis' or .='subheading'])]">
	    <li><span class="note">remarks</span></li>
	  </xsl:if>
	  <xsl:if test="/TEI/text/body//mentioned">
	    <li><b>quotes from base text</b></li>
	  </xsl:if>
	   <xsl:if test="/TEI/text/body//note[@type='analysis']">
	    <li><span class="analysis">analysis</span></li>
	   </xsl:if>
	   <xsl:if test="/TEI/text/body//app">
	    <li><mark>reading(s) to that lemma in apparatus</mark></li>
	   </xsl:if>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<p class="noindent"><b>Interpretive markup: </b>none</p>
      </xsl:otherwise>
    </xsl:choose>
    
    <xsl:if test="fileDesc/notesStmt/note[text()] | fileDesc/notesStmt/note/p[text()]">
      <h4>Notes:</h4>
      <xsl:apply-templates select="fileDesc/notesStmt"/>
    </xsl:if>
  </xsl:template>

  <!-- notes in header -->
  <xsl:template match="TEI/teiHeader/fileDesc/notesStmt/note">
    <xsl:choose>
      <xsl:when test="p">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="p">
	  <xsl:attribute name="class">stdindent</xsl:attribute>
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- licence -->
  <xsl:template match="availability/licence">
    <xsl:element name="p">
      <xsl:attribute name="class">stdindent</xsl:attribute>
      <a href="{@target}"><xsl:value-of select="."/></a>
    </xsl:element>
  </xsl:template>
  
  <!-- references of all sorts -->
  <xsl:template match="ref">
    <xsl:choose>
      <!-- if internal link, add a title (primarily for apparatus)-->
      <xsl:when test="starts-with(@target, '#')">
	<xsl:variable name="idkey" select="substring-after(@target, '#')"/>
	<xsl:element name="a">
	  <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
	  <xsl:attribute name="title">
	    <xsl:value-of select="//*[@xml:id = $idkey]/normalize-space()"/>
	  </xsl:attribute>
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="@target">
	<a href="{@target}">
	  <xsl:apply-templates/>
	</a>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- links, preliminary -->
  <xsl:template match="link">
    <div id="{@xml:id}"/>
  </xsl:template>

  <!-- ul -->
  <xsl:template match="list">
    <xsl:element name="ul">
      <xsl:attribute name="class">dash</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="item">
    <xsl:element name="li">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <!-- source-templates -->
  <!-- names -->
  <xsl:template match="respStmt">
    <xsl:choose>
      <xsl:when test="count(child::name) = 1">
	<xsl:apply-templates select="./name"/>
      </xsl:when>
      <xsl:when test="count(child::name) = 2">
	<xsl:apply-templates select="./name[1]"/>
	<xsl:text> and </xsl:text>
	<xsl:apply-templates select="./name[2]"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="./name[1]"/>
	<xsl:for-each select="./name[count(preceding-sibling::name) > 0][count(following-sibling::name) > 0]">
	  <xsl:text>, </xsl:text>
	  <xsl:apply-templates select="."/>
	</xsl:for-each>
	<xsl:text>, and </xsl:text>
	<xsl:apply-templates select="./name[count(following-sibling::name) = 0]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="name">
    <xsl:choose>
      <xsl:when test="@xml:id">
	<xsl:element name="span">
	  <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
	  <xsl:value-of select="normalize-space(.)"/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="normalize-space(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- bibl -->
  <xsl:template match="sourceDesc/bibl  | sourceDesc/listWit/witness ">
    <xsl:element name="li">
      <xsl:if test="@xml:id">
	<xsl:attribute name="id">
	  <xsl:value-of select="@xml:id"/>
	</xsl:attribute>
	<xsl:element name="b">
	  <xsl:value-of select="@xml:id"/><xsl:text>: </xsl:text>
	</xsl:element>
      </xsl:if>
      <xsl:choose>
	<xsl:when test="substring(normalize-space(.),string-length(normalize-space(.))) = string('.')"><!-- full stop at the end of the text node -->
	  <xsl:apply-templates/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	  <xsl:text>.</xsl:text><!-- no full stop in text node and therefore supplied -->
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
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
    <xsl:element name="li">
      <xsl:attribute name="id">
	<xsl:value-of select="@xml:id"/>
      </xsl:attribute>
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
    </xsl:element>
  </xsl:template>

  <!-- article in collection -->
  <xsl:template match="sourceDesc/biblStruct[child::analytic[child::title]][child::monogr[not(child::title[@level='j'])]]">
    <xsl:element name="li">
      <xsl:attribute name="id">
	<xsl:value-of select="@xml:id"/>
      </xsl:attribute>
      <xsl:if test="./analytic/*[self::author|self::editor]">
	<xsl:apply-templates select="./analytic/*[self::author|self::editor][1]"/><xsl:text>: </xsl:text>
      </xsl:if>
      <xsl:text>»</xsl:text>
      <xsl:value-of select="./analytic/title"/>
      <xsl:text>.« In: </xsl:text>
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
    </xsl:element>
  </xsl:template>
  
  <!-- article in journal -->
  <xsl:template match="sourceDesc/biblStruct[child::analytic[child::title]][child::monogr[child::title[@level='j']]]">
    <xsl:element name="li">
      <xsl:attribute name="id">
	<xsl:value-of select="@xml:id"/>
      </xsl:attribute>
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
    </xsl:element>
  </xsl:template>
  
  <!-- single elements -->
  <xsl:template match="gi">&lt;<xsl:apply-templates/>&gt;</xsl:template>

  <!-- text -->
  <xsl:template match="text">
    <h2>Text</h2>
    <xsl:element name="div">
      <xsl:copy-of select="@xml:lang"/>
      <xsl:apply-templates select="body/node()"/>
    </xsl:element>
  </xsl:template>
  
  <!-- elements -->
  <!-- main headings -->
  <xsl:template match="head">
    <h3><xsl:apply-templates/></h3>
  </xsl:template>

  <!-- subheadings in note-elements -->
  <xsl:template match="note[@type='subheading']">
    <xsl:choose>
      <xsl:when test="ancestor::lg">
	<xsl:element name="span">
	  <xsl:attribute name="class">subhead</xsl:attribute>
	  <xsl:apply-templates/><br/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="div">
	  <xsl:attribute name="class">subhead</xsl:attribute>
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- p / lg -->
  <xsl:template match="p|lg">
    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
    <xsl:choose>
      <!-- look for matching corresp-->
      <xsl:when test="//note[@type='analysis']/@corresp = $correspkey">
	<xsl:element name="div">
	  <xsl:attribute name="class">
	    <xsl:text>row</xsl:text>
	  </xsl:attribute>
	  <xsl:element name="div">
	    <xsl:attribute name="class">
	      <xsl:text>column</xsl:text>
	    </xsl:attribute>
	    <!-- look for apparatus and apply templates a second time -->
	    <xsl:call-template name="apptest"/>
	  </xsl:element>
	  <xsl:element name="div">
	    <xsl:attribute name="class">
	      <xsl:text>column</xsl:text>
	    </xsl:attribute>
	    <!-- analysis -->
	    <xsl:for-each select="//note[@type='analysis' and @corresp = $correspkey]">
	      <xsl:element name="p">
		<xsl:attribute name="class">
		  <xsl:text>analysis</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	      </xsl:element>		
	    </xsl:for-each>
	  </xsl:element>
	</xsl:element>
      </xsl:when>
      <!-- -->
      <xsl:otherwise>
	<!-- look for apparatus and apply templates a second time -->
	<xsl:call-template name="apptest"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="apptest">
    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
    <xsl:choose>
      <xsl:when test="(//note[@type='apparatus']/@target = $correspkey) or (descendant::app)">
	<xsl:element name="div">
	  <xsl:attribute name="class">
	    <xsl:text>wapp</xsl:text>
	  </xsl:attribute>
	  <!-- apply templates a second time -->
	  <xsl:apply-templates select="." mode="content"/>
	  <!-- strictly structured apparatus -->
	  <xsl:for-each select="descendant::app">
	    <xsl:call-template name="apparatus"/>
	  </xsl:for-each>
	  <!-- loosely structured apparatus -->
	  <xsl:for-each select="//note[@type='apparatus' and @target = $correspkey]">
	    <xsl:element name="div">
	      <xsl:attribute name="class">app</xsl:attribute>
	      <xsl:apply-templates/>
	    </xsl:element>
	  </xsl:for-each>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<!-- apply templates a second time -->  
	<xsl:apply-templates select="." mode="content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="p|lg" mode="content">
    <xsl:element name="p">
      <xsl:attribute name="class">
	<xsl:text>stdindent</xsl:text>
      </xsl:attribute>
      <!-- add ids if specified -->
      <xsl:if test="@xml:id">
	<xsl:attribute name="id">
	  <xsl:value-of select="@xml:id"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
      <!-- print id if specified -->
      <xsl:if test="@xml:id">
	<xsl:text> </xsl:text>
	<xsl:element name="span">
	  <xsl:attribute name="class">ref</xsl:attribute>
	  <xsl:if test="self::p"><xsl:text>(</xsl:text></xsl:if>
	  <xsl:call-template name="id2inlineref"/>
	  <xsl:if test="self::p"><xsl:text>)</xsl:text></xsl:if>
	</xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="lg/l">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::l">
      <br/>
    </xsl:if>
  </xsl:template>

  <!-- add changed IDs inline -->
  <xsl:template name="id2inlineref">
    <xsl:choose>
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
	  <a href="{@corresp}">
	    <xsl:call-template name="id2inlinecorresp"/>
	  </a>
	</xsl:when>
	<xsl:when test="contains(@corresp, '.xml#')"><!-- external link-->
	  <xsl:element name="a">
	    <xsl:attribute name="href">
	      <xsl:value-of select="replace(@corresp, '.xml', '.htm')"/>
	    </xsl:attribute>
	    <xsl:attribute name="target">
	      <xsl:text>_blank</xsl:text>
	    </xsl:attribute>
	    <xsl:call-template name="id2inlinecorresp"/>
	  </xsl:element>
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

  <!-- milestone-elements -->
  <!-- @unit="speaker" for a change of speakers inside <lg/> -->
  <xsl:template match="milestone[@unit='speaker']">
    <xsl:value-of select="@n"/>
  </xsl:template>

  <!-- lemma-choice -->
  <xsl:template match="app[descendant::rdg] | app[descendant::lem]">
    <mark>
      <xsl:choose>
	<xsl:when test="lem">
	  <xsl:apply-templates select="lem/node()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="descendant::rdg[1]/node()"/>
	</xsl:otherwise>
      </xsl:choose>
    </mark>
  </xsl:template>

  <!-- apparatus -->
  <xsl:template name="apparatus">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>app</xsl:text>
      </xsl:attribute>
      <xsl:choose>
	<xsl:when test="lem">
	  <xsl:element name="span">
	    <xsl:attribute name="class">lem</xsl:attribute>
	    <xsl:apply-templates select="lem"/>
	    <xsl:text> ]</xsl:text>
	    </xsl:element><xsl:text> </xsl:text>
	    <xsl:for-each select="descendant::rdg[not(position() = last())]">
	      <xsl:apply-templates select="."/><xsl:text>, </xsl:text>
	    </xsl:for-each>
	    <xsl:apply-templates select="descendant::rdg[position() = last()]"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:element name="span">
	    <xsl:attribute name="class">lem</xsl:attribute>
	    <xsl:apply-templates select="descendant::rdg[1]"/>
	    <xsl:text> ]</xsl:text>
	    </xsl:element><xsl:text> </xsl:text>
	    <xsl:for-each select="descendant::rdg[position() > 1][not(position() = last())]">
	      <xsl:apply-templates select="."/><xsl:text>, </xsl:text>
	    </xsl:for-each>
	    <xsl:apply-templates select="descendant::rdg[position() = last()]"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="lem|rdg">
    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
    <xsl:apply-templates/>
    <xsl:if test="@wit">
      <xsl:text> (</xsl:text>
      <xsl:variable name="tree" select="//*"/>
      <xsl:for-each select="tokenize(@wit,'\s+')">
	<xsl:variable name="token" select="."/>
	<xsl:if test="position()>=2">
	  <xsl:text> </xsl:text>
	</xsl:if>
	<xsl:choose>
	  <xsl:when test="starts-with(., '#')">
	    <xsl:variable name="idkey" select="substring-after(., '#')"/>
	    <xsl:element name="a">
	      <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
	      <xsl:attribute name="title">
		<xsl:value-of select="normalize-space($tree[@xml:id = $idkey])"/>
	      </xsl:attribute>
	      <xsl:value-of select="substring-after(., '#')"/>
	    </xsl:element>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="."/>
	  </xsl:otherwise>
	</xsl:choose>
	<!-- add witDetail as superscript here -->
	<xsl:for-each select="$tree[self::witDetail and @target = $correspkey and @wit = $token]">
	  <xsl:element name="sup">
	    <xsl:value-of select="."/>
	  </xsl:element>
	</xsl:for-each>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <!-- add Comments to the readings in brackets-->
    <xsl:variable name="tree" select="//*"/>
    <xsl:for-each select="$tree[self::note and @target = $correspkey and @type = 'apparatus']">
      <xsl:element name="span">
	<xsl:attribute name="class">appnote</xsl:attribute>
	<xsl:apply-templates/>
	<!-- add resp -->
	<xsl:if test="@resp">
	  <xsl:text> (</xsl:text>
	  <xsl:choose>
	    <xsl:when test="starts-with(@resp, '#')">
	      <xsl:variable name="idkey" select="substring-after(@resp, '#')"/>
	      <xsl:element name="a">
		<xsl:attribute name="href"><xsl:value-of select="@resp"/></xsl:attribute>
		<xsl:attribute name="title">
		  <xsl:value-of select="//*[@xml:id = $idkey]/normalize-space()"/>
		</xsl:attribute>
		<xsl:value-of select="substring-after(@resp, '#')"/>
	      </xsl:element>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="@resp"/>
	    </xsl:otherwise>
	  </xsl:choose>
	  <xsl:text>)</xsl:text>
	</xsl:if>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  <!-- choices -->
  <xsl:template match="choice">
    <xsl:choose>
      <xsl:when test="corr">
	<xsl:apply-templates select="corr"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="orig"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- simple corrections -->
  <xsl:template match="corr">
    <xsl:element name="span">
      <xsl:attribute name="class">corr</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- supplied material in case of illegibility -->
  <xsl:template match="supplied">
    <xsl:element name="span">
      <xsl:attribute name="class">supplied</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- surplus material, as deemed by an editor, to be distinguished from material deleted in the original source <del> -->
  <xsl:template match="surplus">
    <xsl:element name="span">
      <xsl:attribute name="class">surplus</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- deletions, meaning material deleted in the original source -->
  <xsl:template match="del">
    <xsl:element name="del">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- unclear -->
  <xsl:template match="unclear">
    <xsl:element name="span">
      <xsl:attribute name="class">unclear</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- gaps, both illegible and lacunae -->
  <xsl:template match="gap">
    <xsl:element name="span">
      <xsl:choose>
	<xsl:when test="ancestor::app|ancestor::note[@type='apparatus']">
	  <xsl:attribute name="class">appnote</xsl:attribute>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="class">note</xsl:attribute>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
	<xsl:when test="@reason">
	  <xsl:value-of select="@reason"/>
	</xsl:when>
	<xsl:when test="@extent or (@unit and @quantity)">
	  <xsl:text>gap</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>…</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
	<xsl:when test="@unit and @quantity">
	  <xsl:text>: </xsl:text>
	  <xsl:value-of select="@quantity"/>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="@unit"/>
	</xsl:when>
	<xsl:when test="@extent">
	  <xsl:text>: </xsl:text>
	  <xsl:value-of select="@extent"/>
	</xsl:when>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <!-- whitespace -->
  <xsl:template match="lb">
    <xsl:choose>
      <xsl:when test="starts-with(@edRef, '#')">
	<xsl:variable name="idkey" select="substring-after(@edRef, '#')"/>
	<xsl:element name="span">
	  <xsl:attribute name="class">lb</xsl:attribute>
	  <xsl:element name="a">
	    <xsl:attribute name="href"><xsl:value-of select="@edRef"/></xsl:attribute>
	    <xsl:attribute name="title">
	      <xsl:value-of select="//*[@xml:id = $idkey]/normalize-space()"/>
	    </xsl:attribute>
	    <xsl:value-of select="substring-after(@edRef, '#')"/>
	  </xsl:element>
	  <xsl:if test="@n">
	    <xsl:text>, l. </xsl:text>
	    <xsl:value-of select="@n"/>
	  </xsl:if>
	</xsl:element>
      </xsl:when>
      <xsl:when test="@n">
	<xsl:element name="span">
	  <xsl:attribute name="class">lb</xsl:attribute>
	  <xsl:text>l. </xsl:text>
	  <xsl:value-of select="@n"/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- page breaks -->
  <xsl:template match="pb">
    <xsl:text> </xsl:text>
    <xsl:element name="span">
      <xsl:attribute name="class">pb</xsl:attribute>
      <xsl:choose>
	<xsl:when test="starts-with(@edRef, '#')">
	  <xsl:variable name="idkey" select="substring-after(@edRef, '#')"/>
	  <xsl:element name="a">
	    <xsl:attribute name="href"><xsl:value-of select="@edRef"/></xsl:attribute>
	    <xsl:attribute name="title">
	      <xsl:value-of select="//*[@xml:id = $idkey]/normalize-space()"/>
	    </xsl:attribute>
	    <xsl:value-of select="substring-after(@edRef, '#')"/>
	  </xsl:element>
	  <xsl:text>, </xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@edRef"/>
	  <xsl:text>, </xsl:text>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:text>p. </xsl:text>
      <xsl:value-of select="@n"/>
    </xsl:element>
  </xsl:template>

  <!-- corruptions -->
  <xsl:template match="sic">
    <xsl:element name="span">
      <xsl:attribute name="class">sic</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- notes -->
  <xsl:template match="text/body//note[not(@type[.='commentary' or .='apparatus' or .='analysis' or .='subheading'])]">
    <xsl:element name="span">
      <xsl:attribute name="class">note</xsl:attribute>
      <xsl:apply-templates/>
      <xsl:if test="@resp">
	<xsl:text> (</xsl:text>
	<xsl:choose>
	  <xsl:when test="starts-with(@resp, '#')">
	    <xsl:variable name="idkey" select="substring-after(@resp, '#')"/>
	    <xsl:element name="a">
	      <xsl:attribute name="href"><xsl:value-of select="@resp"/></xsl:attribute>
	      <xsl:attribute name="title">
		<xsl:value-of select="//*[@xml:id = $idkey]/normalize-space()"/>
	      </xsl:attribute>
	      <xsl:value-of select="substring-after(@resp, '#')"/>
	    </xsl:element>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@resp"/>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!-- special notes -->
  <!-- commentaries -->
  <xsl:template match="note[@type='commentary']">
    <xsl:element name="div">
      <xsl:attribute name="class">comm</xsl:attribute>
      <xsl:attribute name="id">
	<xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <!-- add id if specified -->
      <xsl:if test="@xml:id">
	<xsl:element name="div">
	  <xsl:attribute name="class">
	    <xsl:text>ref</xsl:text>
	  </xsl:attribute>
	  <xsl:text>(</xsl:text>
	  <xsl:call-template name="id2inlineref"/>
	  <xsl:text>)</xsl:text>
	</xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!-- loosely structured apparatus in notes -->
  <xsl:template match="note[@type='apparatus']">
  </xsl:template>
  
  <!-- analysis in notes -->
  <xsl:template match="note[@type='analysis']">
  </xsl:template>

  <!-- witDetail -->
  <xsl:template match="witDetail">
  </xsl:template>
  
  <!-- quotes -->
  <xsl:template match="q">
    <xsl:element name="q">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- hi -->
  <!-- without further specification -->
  <xsl:template match="hi">
    <xsl:element name="span">
      <xsl:attribute name="class">hi</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <!-- explicitly bold -->
  <xsl:template match="hi[@rend[.='bold' or .='textbf' or .='bf' or .='b']]">
    <xsl:element name="b">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- explicitly italic -->
  <xsl:template match="hi[@rend[.='italic' or .='textit' or .='it' or .='i']]">
    <xsl:element name="i">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- explicitly superscript in orig -->
   <xsl:template match="orig[@rend[.='superscript' or .='super' or .='sup']]">
     <xsl:element name="sup">
       <xsl:apply-templates/>
     </xsl:element>
  </xsl:template>

  <!-- pratīkas -->
  <xsl:template match="mentioned">
    <xsl:element name="b">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>