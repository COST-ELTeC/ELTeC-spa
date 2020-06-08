<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude"
 xmlns:h="http://www.w3.org/1999/xhtml" xmlns:t="http://www.tei-c.org/ns/1.0"
 xmlns:cligs="https://cligs.hypotheses.org/ns/cligs" exclude-result-prefixes="xs h t xi cligs"
 xmlns="http://www.tei-c.org/ns/1.0" version="2.0">

 <xsl:variable name="today">
  <xsl:value-of select="substring(string(current-date()), 1, 10)"/>
 </xsl:variable>

 <xsl:variable name="cligsId">
  <xsl:value-of select="//t:teiHeader/t:fileDesc/t:publicationStmt/t:idno[@type = 'cligs']"/>
 </xsl:variable>

 <xsl:variable name="textId">
  <xsl:value-of select="concat('SPA9', substring-after($cligsId, 'ne'))"/>
 </xsl:variable>

 <xsl:template match="t:TEI">
  <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="sp" xml:id="{$textId}" n="{$cligsId}">
   <xsl:apply-templates/>
  </TEI>
 </xsl:template>
 <xsl:template match="t:titleStmt">
  <titleStmt>
   <title>
    <xsl:value-of select="concat(t:title[@type = 'main'], ' : edición ELTeC')"/>
   </title>
   <author>
    <xsl:attribute name="ref">
     <xsl:value-of select="concat('viaf:', t:author/t:idno[@type = 'viaf'])"/>
    </xsl:attribute>
    <xsl:value-of select="concat(t:fixName(t:author/t:name[@type = 'full']), ' ', t:getAuthDates())"
    />
   </author>
  </titleStmt>
 </xsl:template>

 <xsl:template match="t:principal">
  <respStmt>
   <resp>principal</resp>
   <name>
    <xsl:apply-templates/>
   </name>
  </respStmt>
 </xsl:template>

 <xsl:template match="t:extent">
  <extent>
   <measure unit="words">
    <xsl:value-of select="t:measure[@unit eq 'tokens']"/>
   </measure>
  </extent>
 </xsl:template>

 <xsl:template match="t:publicationStmt">
  <publicationStmt>
   <p>
    <xsl:text>Incorporated into the ELTeC </xsl:text>
    <date>
     <xsl:value-of select="$today"/>
    </date>
   </p>
  </publicationStmt>
 </xsl:template>

 <xsl:template match="t:encodingDesc">
  <encodingDesc n="eltec-1">
   <p>Downcoded from CLIGS</p>
  </encodingDesc>
 </xsl:template>


 <xsl:template match="t:bibl">
  <bibl>
   <xsl:attribute name="type">
    <xsl:choose>
     <xsl:when test="@type = 'print-source'">printSource</xsl:when>
     <xsl:when test="@type = 'digital-source'">digitalSource</xsl:when>
     <xsl:when test="@type = 'edition-first'">firstEdition</xsl:when>
     <xsl:otherwise>
      <xsl:message>Unrecognised bibl type <xsl:value-of select="@type"/></xsl:message>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:attribute>
   <xsl:apply-templates/>
  </bibl>
 </xsl:template>

 <xsl:template match="t:profileDesc">

  <xsl:variable name="date">
   <xsl:value-of select="../t:fileDesc/t:sourceDesc/t:bibl[@type = 'first-edition']/t:date/@when"/>
  </xsl:variable>
  <xsl:variable name="wordCount">
   <xsl:value-of select="../t:fileDesc/t:extent/t:measure[@unit = 'tokens']"/>
  </xsl:variable>
  <xsl:variable name="gender">
   <xsl:value-of select="t:textClass/t:keywords/t:term[@type = 'author.gender']"/>
  </xsl:variable>

  <xsl:variable name="timeSlot">
   <xsl:choose>
    <xsl:when test="$date le '1859'">T1</xsl:when>
    <xsl:when test="$date le '1879'">T2</xsl:when>
    <xsl:when test="$date le '1899'">T3</xsl:when>
    <xsl:when test="$date le '1920'">T4</xsl:when>
   </xsl:choose>
  </xsl:variable>
  <xsl:variable name="size">
   <xsl:choose>
    <xsl:when test="xs:integer($wordCount) le 50000">short</xsl:when>
    <xsl:when test="xs:integer($wordCount) le 100000">medium</xsl:when>
    <xsl:when test="xs:integer($wordCount) gt 100000">long</xsl:when>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="sex">
   <xsl:choose>
    <xsl:when test="$gender eq 'male'">M</xsl:when>
    <xsl:when test="$gender eq 'female'">F</xsl:when>
    <xsl:otherwise>U</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <profileDesc>
   <langUsage>
    <language ident="spa">Spanish</language>
   </langUsage>
   <textDesc>
    <authorGender xmlns="http://distantreading.net/eltec/ns" key="{$sex}"/>
    <size xmlns="http://distantreading.net/eltec/ns" key="{$size}"/>
    <reprintCount xmlns="http://distantreading.net/eltec/ns" key="unspecified"/>
    <timeSlot xmlns="http://distantreading.net/eltec/ns" key="{$timeSlot}"/>
   </textDesc>
  </profileDesc>
 </xsl:template>

 <xsl:template match="t:change">
  <change when="{@when}">
   <xsl:value-of select="@who"/>
   <xsl:text> : </xsl:text>
   <xsl:value-of select="."/>
  </change>
 </xsl:template>
 <xsl:template match="t:revisionDesc">
  <revisionDesc>
   <change when="{$today}">LB convert to ELTeC-1</change>
   <xsl:for-each select="t:change">
    <xsl:sort order="descending" select="@when"/>
    <xsl:apply-templates select="."/>
   </xsl:for-each>
  </revisionDesc>
 </xsl:template>

 <xsl:template match="t:text">
  <text>
   <xsl:apply-templates/>
  </text>
 </xsl:template>

 <xsl:template match="t:front[not(t:div)]"/>

 <xsl:template match="t:front/t:div[not(@type)]">
  <div type="liminal">
   <xsl:apply-templates/>
  </div>
 </xsl:template>
 
  <xsl:template match="t:div[@type='part']">
  <div type="group">
   <xsl:apply-templates/>
  </div>  
 </xsl:template>

<xsl:template match="t:div[@type='division']">
 <div type="group">
  <xsl:apply-templates/>
 </div>  
 </xsl:template>
 
 <xsl:template match="t:div[@type='section']">
  <milestone unit="section" />
  <label><xsl:value-of select="t:head"/></label>
   <xsl:apply-templates/>
</xsl:template>

 <xsl:template match="t:div[@type='section']/t:head"/>
 
 <xsl:template match="t:seg[@rend and not(@type)]">
  <hi>
   <xsl:apply-templates/>
  </hi>
 </xsl:template>

 <xsl:template match="t:seg[@type = 'foreign']">
  <foreign>
   <xsl:if test="@xml:lang">
    <xsl:attribute name="xml:lang">
     <xsl:value-of select="@xml:lang"/>
    </xsl:attribute>
   </xsl:if>
   <xsl:apply-templates/>
  </foreign>
 </xsl:template>
 
 
 <xsl:template match="t:ab[@type = 'abstract']">
  <head type="summary">
   <xsl:apply-templates/>
  </head>
 </xsl:template>

 <xsl:template match="t:ab">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

<xsl:template match="t:speaker">
 <label><xsl:apply-templates/></label>
</xsl:template>

 <xsl:template match="t:stage">
  <hi><xsl:apply-templates/></hi>
 </xsl:template>
 
 
 <xsl:template match="t:floatingText | t:lg/t:head">
  <xsl:comment>
            <xsl:apply-templates/>
        </xsl:comment>
 </xsl:template>
 <!-- throw away tags but keep content -->
 <xsl:template match="t:lg">
  <xsl:apply-templates/>
 </xsl:template>

<xsl:template match="t:sp">
 <xsl:apply-templates/>
</xsl:template>

 <xsl:template match="t:seg[not(@rend) and not(@type)]">
  <xsl:apply-templates/>
 </xsl:template>
 
 <xsl:template match="t:seg[@type = 'abbr']">
  <xsl:apply-templates/>
 </xsl:template> 
 
 <xsl:template match="t:seg[@type = 'quotation']">
  <xsl:apply-templates/>
 </xsl:template> 
 
 <!-- throw away -->
 <xsl:template match="@default | @part | @status"/>
 <xsl:template match="t:ref[@target = '#']"/>
 
 
 <!-- copy everything else -->
 <xsl:template match="* | @*">
  <xsl:copy>
   <xsl:apply-templates select="* | @* | comment() | text()"/>
  </xsl:copy>
 </xsl:template>
 <xsl:template match="text()">
  <xsl:value-of select="."/>
  <!-- could normalize() here -->
 </xsl:template>

 <xsl:function name="t:getAuthDates">
  <xsl:value-of
   select="
    concat('(', document('metadata.xml')//t:row[t:cell[@n = '2'][contains(., $cligsId)]]/t:cell[@n = '48'], '-',
    document('metadata.xml')//t:row[t:cell[@n = '2'][contains(., $cligsId)]]/t:cell[@n = '49'], ')')"
  />
 </xsl:function>

 <xsl:function name="t:getDatum">
  <xsl:param name="column"/>
  <xsl:value-of
   select="document('metadata.xml')//t:row[t:cell[@n = '2'][contains(., $cligsId)]]/t:cell[@n = $column]"
  />
 </xsl:function>

 <xsl:function name="t:fixName">
  <xsl:param name="name"/>
  <xsl:choose>
   <xsl:when test="contains($name, ',')">
    <xsl:value-of select="$name"/>
   </xsl:when>
   <xsl:when test="contains($name, ' de ')">
    <xsl:value-of
     select="concat(substring-after($name, ' de '), ', ', substring-before($name, ' de '), ' de')"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="concat(substring-after($name, ' '), ', ', substring-before($name, ' '))"/>
   </xsl:otherwise>
   <!-- works for "Benito Perez Galdos" but not for "Jacinto Octavio Picon" -->

  </xsl:choose>
 </xsl:function>
</xsl:stylesheet>
