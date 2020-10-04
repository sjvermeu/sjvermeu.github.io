<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xccdf="http://checklists.nist.gov/xccdf/1.2" xmlns:cpe="http://cpe.mitre.org/language/2.0" xmlns:h="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xccdf cpe h">

<!--
This is the XSL file that is able to transform an XCCDF document into a semi-interactive HTML document.
It can be used with Xalan or other XSL tools.
-->

  <xsl:output method="xml" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
  <xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml">
  <!-- <html> -->
    <head>
      <!-- <meta http-equiv="content-type" content="text/html;charset=utf-8" /> -->
      <style type="text/CSS">
/* Sample style sheet for boom!, the book microformat              */
/* written  by Hakon Wium Lie and Bert Bos, November 2005          */
/* You may reuse this style sheet for any purpose without any fees */


html { 
  margin: 0;
  font: 10pt/1.26 "Gill Sans", sans-serif;
}

a { text-decoration: none; color: black }

body { 
  margin: 0 0 0 28%;
}

dt {
  font-weight: bold;
}

h1, h2, h3, h4, h5, h6 { 
  font-family: "Gill Sans", sans-serif;
  margin: 2em 0 0.5em 0;
  page-break-after: avoid;
} 

h1 { 
  padding: 2em 0 2em 0;
  margin: 0;
  font-size: 2.4em;
  font-weight: 900;
}

h2 { 
  font-size: 1.2em;
  text-transform: uppercase;
  font-weight: bold;
}

h3 { 
  font-size: 1em;
  font-weight: bold;
}

p { margin: 0; margin-top: 1em; }

p.sidenote + p, p.caption, p.art { text-indent: 0 }

p.author {
  margin-top: 2em;
  text-indent: 0;
  text-align: right;
}

pre {  margin: 1em 1.3em; }

q::before {
  content: "\201C";
}

q::after {
  content: "\201D";
}

/* cross-references */

a.pageref::after { content: " on page " target-counter(attr(href), page); }
a.chapref::before { content: " Chapter " target-counter(attr(href), chapter) ", "; }
a.figref { content: " Figure " target-counter(attr(href), figure); }
a.tableref { content: " Table " target-counter(attr(href), figure); }

/* sidenotes */

.sidenote {
  float: left;
  clear: left;
  margin: 0 0 1em -41%;
  width: 37%;
  font-size: 0.9em;
  font-style: normal;
  text-indent: 0;
  text-align: right;
  page-break-inside: avoid;
}

/* sidebars */

div.sidebar {
  float: top-next;
  margin: 1.2em 0 1.2em 0;
  border: thin solid;
  background: #CCC;
  padding: 0.5em 1em;
  page-break-inside: avoid;

}

div.sidebar h2 {
  margin-top: 0;
}

/* figures and tables*/

div.figure {
  margin: 1em 0;
  counter-increment: figure;
}

div.figure .caption, div.table .caption {
  float: left;
  clear: left;
  width: 37%;
  text-align: right;
  font-size: 0.9em;
  margin: 0 0 1.2em -40%;
}

div.figure .caption::before {
  content: "Figure " counter(figure) ": ";
  font-weight: bold;
}

div.table .caption::before {
  content: "Table " counter(table) ": ";
  font-weight: bold;
}

div.table {
  margin: 1em 0;
  counter-increment: table;
}

div.table th {
  text-align: left;
}

table th, table td {
  text-align: left;
  padding-right: 1em;
  font-size: 0.9em;
}

table.lined td, table.lined th {
  border-top: none;
  border-bottom: thin dotted;
  padding-top: 0.2em;
  padding-bottom: 0.2em;
}


@page {
  margin: 27mm 16mm 27mm 16mm;
  size: 7in 9.25in;

  @footnotes {
    border-top: thin solid black;
    padding-top: 0.3em;
    margin-top: 0.6em;
    margin-left: 30%;
  }
}


/* define default page and names pages: cover, blank, frontmatter */

@page :left {
  @top-left {
    font: 11pt "Gill Sans", serif;
    content: "Cascading Style Sheets";
    vertical-align: bottom;
    padding-bottom: 2em;
  }

  @bottom-left {
    font: 11pt "Gill Sans", serif;
    content: counter(page);
    padding-top: 2em;
    vertical-align: top;
  }
}

@page :right {
  @top-right {
    font: 11pt "Gill Sans", serif;
    content: string(header, first); 
    vertical-align: bottom;
    padding-bottom: 2em; 
  }

  @bottom-right {
    font: 11pt "Gill Sans", serif;
    content: counter(page);
    text-align: right;
    vertical-align: top;
    padding-top: 2em;
  }
}

@page frontmatter :left {
  @top-left {
    font: 11pt "Gill Sans", serif;
    content: string(title);
    vertical-align: bottom;
    padding-bottom: 2em;
  }

  @bottom-left {
    font: 11pt "Gill Sans", serif;
    content: counter(page, lower-roman);
    padding-top: 2em;
    vertical-align: top;
  }
}

@page cover { margin: 0; }

@page frontmatter :right {
  @top-right {
    font: 11pt "Gill Sans", serif;
    content: string(header, first); 
    vertical-align: bottom;
    padding-bottom: 2em; 
  }

  @bottom-right {
    font: 11pt "Gill Sans", serif;
    content: counter(page, lower-roman);
    text-align: right;
    vertical-align: top;
    padding-top: 2em;
  }
}

@page blank :left {
  @top-left { content: normal }
  @bottom-left { content: normal }
}

@page blank :right {
  @top-right { content: normal }
  @bottom-right { content: normal }
}

tr.onlineonly { display: none; }

/* footnotes */

.footnote {
  display: none;                   /* default rule */

  display: prince-footnote;        /* prince-specific rules */
  position: footnote;
  footnote-style-position: inside;

  counter-increment: footnote;
  margin-left: 1.4em;
  font-size: 90%;
  line-height: 1.4;
}

.footnote::footnote-call {
  vertical-align: super;
  font-size: 80%;
}

.footnote::footnote-marker {
  vertical-align: super;
  color: green;
  padding-right: 0.4em;
}


/*
   A book consists of different types of sections. We propose to use
   DIV elements with these class names:

    frontcover
    halftitlepage: contains the title of the book
    titlepage: contains the title of the book, name of author(s) and publisher
    imprint: left page with copyright, publisher, library printing information
    dedication: right page with short dedication
    foreword: written by someone other than the author(s)
    toc: table of contents
    preface: preface, including acknowledgements
    chapter: each chapter is given its own DIV element
    references: contains list of references
    appendix: each appendix is given its own 
    bibliography
    glossary
    index
    colophon: describes how the book was produced
    backcover

   A book will use several of the types listed above, but few books
   will use all of them.
*/

/* which section uses which named page */

div.halftitlepage, div.titlepage, div.imprint, div.dedication { page: blank }
div.foreword, div.toc, div.preface { page: frontmatter }


/* page breaks */

div.frontcover, div.halftitlepage, div.titlepage { page-break-before: right }
div.imprint { page-break-before: always }
div.dedication, div.foreword, div.toc, div.preface, div.chapter, div.reference, 
div.appendix, div.bibliography, div.glossary, div.index, div.colophon { 
  page-break-before: always 
}
div.backcover { page-break-before: left }

/* the front cover; this code is probably not very reusable by other books */

div.frontcover { page: cover; }

div.frontcover img {
  position: absolute;
  width: 7in; height: 9.25in;
  left: 0; top: 0;
  z-index: -1;
}

div.frontcover h1 {
  position: absolute;
  left: 2cm; top: 1cm;
  color: white;
  font-size: 44pt;
  font-weight: normal;
}

div.frontcover h2 {
  position: absolute;
  right: 0; top: 5cm;
  color: black;
  background: white;
  font-size: 16pt;
  font-weight: normal;
  padding: 0.2em 5em 0.2em 1em;
  letter-spacing: 0.15em;
}

div.frontcover h3 {
  position: absolute;
  left: 2cm; top: 7cm;
  color: white;
  font-size: 24pt;
  font-weight: normal;
}

div.frontcover p {
  position: absolute;
  left: 2cm; bottom: 1.5cm;
  font-size: 24pt;
  color: black;
  font-weight: bold;
  text-transform: uppercase;
}


/* titlepage, halftitlepage */

div.titlepage h1, div.halftitlepage h1 { margin-bottom: 2em; }
div.titlepage h2, div.halftitlepage h2 { font-size: 1.2em; margin-bottom: 3em; }
div.titlepage h3, div.halftitlepage h3 { font-size: 1em; margin-bottom: 3em; }
div.titlepage p, div.halftitlepage p { 
  font-size: 1.4em;
  font-weight: bold;
  margin: 0; padding: 0;
}


/* TOC */

ul.toc, ul.toc ul { 
  list-style-type: none;
  margin: 0; padding: 0;
}
ul.toc ul {
  margin-left: 1em;
  font-weight: normal;
}
/* had greater than after ul.toc */
ul.toc li { 
  font-weight: bold;
  margin-bottom: 0.5em;
}
ul.toc li li {
  font-weight: normal;
  margin-bottom: 0em;
}
ul.toc a::after {
  content: leader('.') target-counter(attr(href), page);
  font-style: normal;
}
/* had greater than after ul.toc */
ul.toc li.frontmatter a::after {
  content: leader('.') target-counter(attr(href), page, lower-roman);
  font-style: normal;
}
/* had greater than after ul.toc */
ul.toc li.endmatter a::after {
  content: leader('.') target-counter(attr(href), page);
  font-style: normal;
}
/* had greater than after ul.toc */
ul.toc li.chapter::before {
  content: "Chapter " counter(toc-chapter, decimal);
  display: block;
  margin: 1em 0 0.1em -2.5cm;
  font-weight: normal;
  page-break-after: avoid;
}

ul.toc li.chapter {
  counter-increment: toc-chapter;
}

/* chapter numbers */

div.chapter { counter-increment: chapter; }

h1::before {
  white-space: pre;
  margin-left: -2.5cm;
  font-size: 50%;
  content: "\B0  \B0  \B0  \B0  \B0 \A";  /* ornaments */
}

div.chapter h1::before { content: "Chapter " counter(chapter) " \A"; }

div.frontcover h1::before, div.titlepage h1::before, div.halftitlepage h1::before {
  content: normal;                  /* that is, none */
}

h1 { string-set: header content();}
div.chapter h1 { string-set: header "Chapter " counter(chapter) ": " content(); }

/* index */

ul.index { 
  list-style-type: none;
  margin: 0; padding: 0;
  column-count: 2;
  column-gap: 1em;
}

ul.index a::after { content: ", " target-counter(attr(href), page); }


span.element, span.attribute {
  text-transform: uppercase;
  font-weight: bold;
  font-size: 80%;
}
span.property { font-weight: bold }
code, span.css, span.value, span.declaration {
  font: 90% "Lucida Console", "Lucida Sans Typewriter", monospace;
}

@media print {
  div.noprint { display: none }
}

@media screen, handheld {
  html { margin: 1em; font: 14px "Gill Sans", sans-serif; }
  h1 { margin-bottom: 0.5em }
  div.frontcover, div.halftitlepage, div.imprint, 
  div.dedication, div.foreword, div.index { display: none }
  /* also had div.toc, div.titlepage for the display none */
  tr.onlineonly { display: table-row }
}

      </style> 
      
      <title><xsl:value-of select="xccdf:Benchmark/xccdf:title" /></title>      

    
    </head>
    
    <body>
      <!-- <xsl:text disable-output-escaping="yes">&gt;</xsl:text> -->
      <script type="text/javascript">
        function toggle_all_visibility_open() 
        {
          var tables = document.getElementsByTagName("table");
          for (var i = tables.length - 1; i <xsl:text disable-output-escaping="yes">&gt;</xsl:text>= 0; i -= 1) {
            if (tables[i].id != null) {
              if (tables[i].id.indexOf('tbl-') == 0) {
                tables[i].style.display = "table";
              }
            }
          }
        }
        
        function toggle_all_visibility_close()
        {
          var tables = document.getElementsByTagName("table");
          for (var i = tables.length - 1; i <xsl:text disable-output-escaping="yes">&gt;</xsl:text>= 0; i -= 1) {
            if (tables[i].id != null) {
              if (tables[i].id.indexOf('tbl-') == 0) {
                tables[i].style.display = "none";
              }
            }
          }
        }
        
        function toggle_visibility(tbid)
        {
          if(document.all)
          {
            document.getElementById(tbid).style.display = document.getElementById(tbid).style.display == "block" ? "none" : "block";
          }
          else
          {
            document.getElementById(tbid).style.display = document.getElementById(tbid).style.display == "table" ? "none" : "table";
          }
        }
      </script>
      
      <div class="frontcover">
        <h2><xsl:value-of select="xccdf:Benchmark/xccdf:title" /></h2>
      </div>
      
      <div class="titlepage">
        <h1 class="no-toc"><xsl:value-of select="xccdf:Benchmark/xccdf:title" /></h1>
        <h2 class="no-toc">Configuration Baseline <xsl:value-of select="xccdf:Benchmark/xccdf:sequencenumber" /></h2>
        <h3 class="no-toc">v.<xsl:value-of select="xccdf:Benchmark/xccdf:version" /> (<xsl:value-of select="xccdf:Benchmark/xccdf:status" />)</h3>
        
        <p class="no-toc">example.com - internal document</p>
      </div>
      
      <xsl:call-template name="toc" />
      
      <xsl:if test="xccdf:Benchmark/xccdf:Group/xccdf:title='Introduction'">
        <xsl:call-template name="preface" />
      </xsl:if>
      
      
      <xsl:for-each select="xccdf:Benchmark/xccdf:Group[not(xccdf:title='Introduction')]">
        <xsl:call-template name="chapter">
          <xsl:with-param name="group" select="." />
        </xsl:call-template>
      </xsl:for-each>

      <xsl:call-template name="profileoverview" />
  
      <script type="text/javascript">
        toggle_all_visibility_close();
      </script>
  
    </body>
  </html>
  </xsl:template>

  <xsl:template name="profileoverview">
    <div class="noprint">
    <div class="chapter" id="chapter-overview">
      <h1>Overviews</h1>
      <h2 id="profiles-overview">Profiles</h2>
      <p>
        Within this document, the following profiles are defined:
      </p>
      <div class="table">
        <p class="caption">Profile overview</p>
        <table class="lined" summary="Profile overview">
          <tbody>
            <xsl:for-each select="xccdf:Benchmark/xccdf:Profile">
            <tr>
              <th>Profile</th>
              <th><a name="{@id}"><xsl:value-of select="xccdf:title" /></a></th>
            </tr>
            <tr>
              <th>Description</th>
              <td><xsl:apply-templates select="xccdf:description" /></td>
            </tr>
            <tr>
              <th>Rules</th>
              <td>
                <ul>
                  <xsl:for-each select="xccdf:select">
                    <xsl:variable name="idref" select="@idref" />
                    <xsl:choose>
                      <xsl:when test="count(//xccdf:Rule[@cluster-id=$idref]) &gt; 0">
                        <xsl:for-each select="//xccdf:Rule[@cluster-id=$idref]">
                          <li><a href="#{@id}"><xsl:value-of select="xccdf:title" /></a></li>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:when test="//xccdf:Rule[@id=$idref]">
                        <li><a href="#{$idref}"><xsl:value-of select="//xccdf:Rule[@id=$idref]/xccdf:title" /></a></li>
                      </xsl:when>
                      <xsl:otherwise />
                    </xsl:choose>          
                  </xsl:for-each>
                </ul>
              </td>
            </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </div>
      <h2 id="rules-overview">Rules</h2>
      <p>
        The following rules are identified.
      </p>
      <div class="table">
        <p class="caption">Rule overview</p>
        <table class="lined" summary="Rules overview">
          <thead>
            <tr>
              <th>Title</th>
              <th>Rule Id</th>
              <th>Scope</th>
              <th>Severity</th>
              <th>Weight</th>
              <th>OVAL Check?</th>
              <th>Rule accepted?</th>
              <th>Other tools</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="//xccdf:Rule">
              <xsl:sort select="xccdf:ident[@system='http://example.com/configbaseline']" />
              <xsl:variable name="idref" select="@id" />

                <tr>
                  <td><a href="#{$idref}"><xsl:value-of select="xccdf:title" /></a></td>
                  <td><xsl:value-of select="xccdf:ident[@system='http://example.com/configbaseline']" /></td>
                  <td><xsl:value-of select="@cluster-id" /></td>
                  <td><xsl:value-of select="@severity" /></td>
                  <td><xsl:value-of select="@weight" /></td>
                  <td><xsl:choose><xsl:when test="xccdf:check[@system='http://oval.mitre.org/XMLSchema/oval-definitions-5']/xccdf:check-content-ref">Yes</xsl:when><xsl:otherwise>No</xsl:otherwise></xsl:choose></td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="@selected = 1">Yes</xsl:when>
                      <xsl:when test="@selected = 0">No</xsl:when>
                      <xsl:when test="count(//Profile/select[@idref=$idref]) &gt; 0">Profile-specific</xsl:when>
                      <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                  </td>
                </tr>

            </xsl:for-each>
          </tbody>
        </table>
      </div>

      <p style="font-size: 0.6em;">
        <a id="close_all" href="#" onclick="toggle_all_visibility_close();">Close all</a> - 
        <a id="open_all"  href="#" onclick="toggle_all_visibility_open(); ">Open all</a>
      </p>
    </div>
    </div>
  </xsl:template>

  <xsl:template name="preface">
    <div class="preface" id="{generate-id(xccdf:Benchmark/xccdf:Group[xccdf:title='Introduction'])}">
      <h1><xsl:value-of select="xccdf:Benchmark/xccdf:title" /></h1>
      <h1>Introduction</h1>
      <xsl:for-each select="xccdf:Benchmark/xccdf:Group[xccdf:title='Introduction']/xccdf:description">
        <xsl:apply-templates />
      </xsl:for-each>
    
      <xsl:if test="xccdf:Benchmark/xccdf:Group[xccdf:title='Introduction']/xccdf:reference">
        <p>References:</p>
        <ul>
          <xsl:for-each select="xccdf:Benchmark/xccdf:Group[xccdf:title='Introduction']/xccdf:reference">
            <li><xsl:value-of select="." /><xsl:if test="@href"> [<a href="{@href}">link</a>]</xsl:if></li>
          </xsl:for-each>
        </ul>
      </xsl:if>
      
      <xsl:apply-templates select="xccdf:Benchmark/xccdf:Group[xccdf:title='Introduction']/xccdf:Group"/>

      
    </div>
  </xsl:template>

  <xsl:template match="h:p">
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>
  
  <xsl:template match="h:em"><em><xsl:apply-templates /></em></xsl:template>
  
  <xsl:template match="h:b"><b><xsl:apply-templates /></b></xsl:template>
  
  <xsl:template name="chapter">
    <div class="chapter" id="{generate-id()}">
      <h1><xsl:value-of select="xccdf:title" /></h1>
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="xccdf:Group/xccdf:description">
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="xccdf:title" />
  
  <xsl:template match="xccdf:Group">
    <xsl:variable name="hpos" select="count(ancestor::xccdf:Group)+1" />
    <div class="section" id="{generate-id()}">
      <xsl:element name="h{$hpos}"><xsl:value-of select="xccdf:title" /></xsl:element>
      <xsl:apply-templates select="xccdf:description" />
      <xsl:if test="xccdf:reference">
        <p>References:</p>
        <ul>
          <xsl:for-each select="xccdf:reference">
            <li><xsl:value-of select="." /><xsl:if test="@href"> [<a href="{@href}">link</a>]</xsl:if></li>
          </xsl:for-each>
        </ul>
      </xsl:if>
      <xsl:apply-templates select="*[not(local-name()='description') and not(local-name()='Group')]"/>
      <xsl:apply-templates select="xccdf:Group" />
    </div>
  </xsl:template>
  
  <xsl:template match="xccdf:Group/xccdf:reference" />
  
  <xsl:template match="xccdf:Group/xccdf:rationale">
    <p><em>Rationale</em></p>
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>
  
  <xsl:template match="h:tt"><tt><xsl:apply-templates /></tt></xsl:template>
  
  <xsl:template match="h:code"><code><xsl:apply-templates /></code></xsl:template>
  
  <xsl:template match="h:ul"><ul><xsl:apply-templates /></ul></xsl:template>
  
  <xsl:template match="h:ol"><ol><xsl:apply-templates /></ol></xsl:template>
  
  <xsl:template match="h:li"><li><xsl:apply-templates /></li></xsl:template>
  
  <xsl:template match="h:br"><br /></xsl:template>
  
  <xsl:template match="h:pre"><pre class="CSS"><xsl:apply-templates /></pre></xsl:template>
  
  <xsl:template match="h:dl"><dl><xsl:apply-templates /></dl></xsl:template>
  
  <xsl:template match="h:dt"><dt><xsl:apply-templates /></dt></xsl:template>
  
  <xsl:template match="h:dd"><dd><xsl:apply-templates /></dd></xsl:template>
  
  <xsl:template match="xccdf:Group/xccdf:warning">
    <div class="sidebar" id="{generate-id()}">
      <h2 class="no-toc">Warning <xsl:if test="@category">(<xsl:value-of select="@category" />)</xsl:if></h2>
      <xsl:apply-templates />
    </div>
  </xsl:template>
  
  <!--
		Rule specifics
	-->
  
  <xsl:template match="xccdf:Rule">
    <xsl:variable name="ruleid" select="@id" />
    <xsl:variable name="clusterid" select="@cluster-id" />
    <xsl:variable name="ruletitle" select="xccdf:title" />

      <div class="table" id="{$ruleid}">
        <p class="caption"><xsl:value-of select="xccdf:title" /></p>
        <table class="lined" summary="{$ruletitle}" style="width: 100%">
          <tbody>
            <tr>
              <th>Rule</th>
              <th style="width: 95%" onclick="toggle_visibility('tbl-{$ruleid}')"><xsl:value-of select="xccdf:title" /></th>
            </tr>
          </tbody>
        </table>
        <table class="lined" summary="{$ruletitle}" id="tbl-{$ruleid}">
          <tbody>
            <tr>
              <th>Severity</th>
              <td><xsl:value-of select="@severity" /></td>
            </tr>
            <tr>
              <th>Weight</th> 
              <td><xsl:value-of select="@weight" /></td>
            </tr>
            <xsl:apply-templates />
            
            <tr>
              <th>Profiles</th>
              <td>
                This rule is enabled in the following profiles:
                <ul>
                  <xsl:for-each select="/xccdf:Benchmark/xccdf:Profile[xccdf:select[@idref=$ruleid and @selected='true']]">
                    <li><a href="#{@id}"><xsl:value-of select="xccdf:title" /></a></li>
                  </xsl:for-each>
                  <xsl:for-each select="/xccdf:Benchmark/xccdf:Profile[xccdf:select[@idref=$clusterid and @selected='true']]">
                    <li><a href="#{@id}"><xsl:value-of select="xccdf:title" /></a></li>
                  </xsl:for-each>
                </ul>
              </td>
            </tr>
            <tr class="onlineonly">
              <th>XCCDF Id</th>
              <td><xsl:value-of select="$ruleid" /></td>
            </tr>
          </tbody>
        </table>
        
      </div>
  </xsl:template>
  
  <xsl:template match="xccdf:Rule/xccdf:description">
    <tr>
      <th>Description</th>
      <td><xsl:apply-templates /></td>
    </tr>
  </xsl:template>
  
  <xsl:template match="xccdf:Rule/xccdf:rationale">
    <tr>
      <th>Rationale</th>
      <td><xsl:apply-templates /></td>
    </tr>
  </xsl:template>
  
  <xsl:template match="xccdf:Rule/xccdf:reference">
    <tr>
      <th>Reference</th>
      <td><xsl:value-of select="." /><xsl:text> </xsl:text><xsl:if test="@href">[<a href="{@href}">link</a>]</xsl:if></td>
    </tr>
  </xsl:template>
  
  <xsl:template match="xccdf:Rule/xccdf:ident">
    <tr>
      <th>Identifier</th>
      <td>
        <xsl:choose>
          <xsl:when test="@system='http://example.com/configbaseline'">Rule Id</xsl:when>
          <xsl:otherwise><xsl:value-of select="@system" /> </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="." />
      </td>
    </tr>
  </xsl:template>
  
  <xsl:template match="xccdf:Rule/xccdf:fixtext">
    <tr>
      <th>Fix</th>
      <td><xsl:apply-templates /></td>
    </tr>
  </xsl:template>
  
  <xsl:template match="xccdf:Rule/xccdf:check">
    <tr>
      <th>Check</th>
      <td><xsl:apply-templates /></td>
    </tr>
  </xsl:template>
  
  <xsl:template match="xccdf:Rule/xccdf:warning">
    <tr>
      <td colspan="2">
        <div class="sidebar" id="{generate-id()}">
          <h2 class="no-toc">Warning <xsl:if test="@category">(<xsl:value-of select="@category" />)</xsl:if></h2>
          <p>
            <xsl:apply-templates />
          </p>
        </div>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="xccdf:check-content-ref">
    <xsl:value-of select="@name" /> from <xsl:value-of select="@href" />
  </xsl:template>
  
  <xsl:template name="toc">
    <div class="toc" id="toc-1">
      <h1>Table of Contents</h1>
      <ul class="toc">
        <xsl:if test="xccdf:Benchmark/xccdf:Group[xccdf:title='Introduction']">
          <li class="frontmatter"><a href="#{generate-id(xccdf:Benchmark/xccdf:Group[xccdf:title='Introduction'])}">Introduction</a></li>
        </xsl:if>
        <xsl:for-each select="xccdf:Benchmark/xccdf:Group[not(xccdf:title='Introduction')]">
          <li class="chapter"><a href="#{generate-id()}"><xsl:value-of select="xccdf:title" /></a>
          <xsl:if test="xccdf:Group">
            <ul>
            <xsl:for-each select="xccdf:Group">
              <li class="section"><a href="#{generate-id()}"><xsl:value-of select="xccdf:title" /></a>
              <xsl:if test="xccdf:Group">
                <ul>
                  <xsl:for-each select="xccdf:Group">
                    <li class="section"><a href="#{generate-id()}"><xsl:value-of select="xccdf:title" /></a>
                      <xsl:if test="xccdf:Group">
                        <ul>
                          <xsl:for-each select="xccdf:Group">
                            <li class="section"><a href="#{generate-id()}"><xsl:value-of select="xccdf:title" /></a></li>
                          </xsl:for-each>
                        </ul>
                      </xsl:if>
                    </li>
                  </xsl:for-each>
                </ul>
              </xsl:if>
              </li>
            </xsl:for-each>
            </ul>
          </xsl:if>
          </li>
        </xsl:for-each>
        
        <li class="chapter"><a href="#chapter-overview">Overviews</a>
          <ul>
            <li class="section"><a href="#profiles-overview">Profiles</a></li>
            <li class="section"><a href="#rules-overview">Rules</a></li>
          </ul>
        </li>
        
      </ul>
    </div>
  </xsl:template>
  
</xsl:stylesheet>
