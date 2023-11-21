**My R Markdown Guide**
================
Jesse Birchfield
2023-11-20

------------------------------------------------------------------------

Welcome! Here is example code to do everything you might want to do in R
Markdown. Compare the raw `.Rmd` file with this output to see exactly
how it works.

# The YAML header

Let’s start with the document header:

- It’s between two sets of dashes `---`, and written in its own language
  called YAML (Yet Another Markup Language).
- The title, author, and date sections are optional; the document will
  still compile without them.
- You can put basic Markdown formatting inside the title or author.
- Note the R code inside backticks to display the current date.

Some options for output:

- output: html_document
- output: html_notebook
- output: md_document
- output: pdf_document
- output: word_document
- output: github_document

For html documents, and in some cases pdf or github documents, you can
add options as shown in this document, including:

- toc: true \# include table of contents
- toc_float: true \# make the TOC float on the left pane
- anchor_sections: true \# allow readers to click on anchors
- number_sections: false
- code_folding: show \# (‘hide’) collapse code chunks by clicking on
  them
- df_print: paged \# (‘default’ ‘kable’ ‘tibble’) method for printing
  dataframes
- dev: png \# (‘pdf’) graphics device for figure output
- citation_package: biblatex (‘default’ ‘natbib’)
- latex_engine: pdflatex \# (‘xelatex’ ‘lualatex’)

------------------------------------------------------------------------

# Section headings

Below the document header and between each section, I like to put a
blank line, followed by `---`, followed by another blank line, to create
a horizontal rule.

To separate paragraphs, put a blank line between them. Headers need a
blank line above, but not necessarily below. A single `#` precedes a
header the size of the title. For main section headings use `#`, for
subsections use `##`, and so on. You can go down to `######`. RMD can
use these to create a table of contents, discussed later.

------------------------------------------------------------------------

# Text formatting

To separate lines that are not new paragraphs, add two spaces to the end
of each line, like this:  
line1  
line2  
line3

Some basic formats:  
*italic*  
**bold**  
***italic and bold***  
~~strikethrough~~  
`console font for verbatim code`  
<https://www.google.com>

[This a link to Google.](https://www.google.com)

A couple special characters:  
en dash: –  
em dash: —

To display a literal character that would otherwise be used to format
text, add a backslash in front of the character:  
\* Without a backslash, this asterisk would be a bullet.

Ordered and unordered lists (must have blank line above):

1.  First item
2.  Second item
3.  Third item
    1.  Indented item
    2.  Indented item
4.  Fourth item

- First item
- Second item
- Third item
  - Indented item
  - Indented item
- Fourth item

Block quote (include `>` before each new line):

> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
> eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
> minim veniam, quis nostrud exercitation ullamco laboris nisi ut
> aliquip ex ea commodo consequat. Duis aute irure dolor in
> reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
> pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
> culpa qui officia deserunt mollit anim id est laborum.

For a pagebreak, `\newpage`. Only shows up when you knit to PDF or print
the HTML.

------------------------------------------------------------------------

# Code chunks

If you write r, a space, and an R command, surrounded by backticks, the
command will be evaluated on the text line, in the regular text format.
Example: a three-decimal approximation of pi is 3.142.

Start an R code chunk with \`\`\`{r}. End it with \`\`\`. (It is
possible to write chunks in other languages too.) The options for the
chunk go inside the curly braces.

The first code chunk in your document should have `{r, setup, ...}`, as
in the below example. Inside `knitr::opts_chunk$set()` you can set
global options for all chunks. They can be overridden by individual
chunk headers.

``` r
# Also load packages, etc. in this chunk
# Usually set include=FALSE and message=FALSE
knitr::opts_chunk$set()
```

Some chunk options:

- label = ‘mychunk’ \# to refer to chunks by label
- include = FALSE \# run code, don’t display code or output
- eval = FALSE \# display code, don’t run it
- echo = FALSE \# run code, display output, don’t display code
- comment = ’’ \# remove `##` in front of the output
- collapse = TRUE \# combine all outputs
- message = FALSE \# show no messages of any kind

An invisible chunk:

A visible chunk that does nothing:

``` r
# You can see this code, but it won't run.
# This is useful for discussing code.
d <- dnorm(0, 0, 1)
```

Invisible code with visible output:

    ## [1] 0.3989423

Visible code with visible output:

``` r
dnorm(0, 0, 1)
```

    ## [1] 0.3989423

Remove the `##` in front of the output:

``` r
dnorm(0, 0, 1)
```

    [1] 0.3989423

If you don’t like the `[1]` in front of the output, try the `cat()` or
`glue()` functions.

------------------------------------------------------------------------

# Tables

Basic tibble print leaves much to be desired:

    # A tibble: 6 × 11
        mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
      <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    1  21       6   160   110  3.9   2.62  16.5     0     1     4     4
    2  21       6   160   110  3.9   2.88  17.0     0     1     4     4
    3  22.8     4   108    93  3.85  2.32  18.6     1     1     4     1
    4  21.4     6   258   110  3.08  3.22  19.4     1     0     3     1
    5  18.7     8   360   175  3.15  3.44  17.0     0     0     3     2
    6  18.1     6   225   105  2.76  3.46  20.2     1     0     3     1

Use the gt package (and you can do a lot more customization than this):

<div id="yarpocuoit" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#yarpocuoit table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#yarpocuoit thead, #yarpocuoit tbody, #yarpocuoit tfoot, #yarpocuoit tr, #yarpocuoit td, #yarpocuoit th {
  border-style: none;
}
&#10;#yarpocuoit p {
  margin: 0;
  padding: 0;
}
&#10;#yarpocuoit .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: 0;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 3px;
  border-top-color: #D5D5D5;
  border-right-style: solid;
  border-right-width: 3px;
  border-right-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 3px;
  border-bottom-color: #D5D5D5;
  border-left-style: solid;
  border-left-width: 3px;
  border-left-color: #D5D5D5;
}
&#10;#yarpocuoit .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#yarpocuoit .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#yarpocuoit .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#yarpocuoit .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#yarpocuoit .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}
&#10;#yarpocuoit .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#yarpocuoit .gt_col_heading {
  color: #FFFFFF;
  background-color: #004D80;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#yarpocuoit .gt_column_spanner_outer {
  color: #FFFFFF;
  background-color: #004D80;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#yarpocuoit .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#yarpocuoit .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#yarpocuoit .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#yarpocuoit .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#yarpocuoit .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#yarpocuoit .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  vertical-align: middle;
}
&#10;#yarpocuoit .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#yarpocuoit .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#yarpocuoit .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D5D5D5;
  border-left-style: solid;
  border-left-width: 1px;
  border-left-color: #D5D5D5;
  border-right-style: solid;
  border-right-width: 1px;
  border-right-color: #D5D5D5;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#yarpocuoit .gt_stub {
  color: #FFFFFF;
  background-color: #929292;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D5D5D5;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#yarpocuoit .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#yarpocuoit .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#yarpocuoit .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#yarpocuoit .gt_summary_row {
  color: #FFFFFF;
  background-color: #5F5F5F;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#yarpocuoit .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D5D5D5;
}
&#10;#yarpocuoit .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#yarpocuoit .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}
&#10;#yarpocuoit .gt_grand_summary_row {
  color: #FFFFFF;
  background-color: #929292;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#yarpocuoit .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D5D5D5;
}
&#10;#yarpocuoit .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D5D5D5;
}
&#10;#yarpocuoit .gt_striped {
  background-color: #F4F4F4;
}
&#10;#yarpocuoit .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}
&#10;#yarpocuoit .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#yarpocuoit .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#yarpocuoit .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#yarpocuoit .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#yarpocuoit .gt_left {
  text-align: left;
}
&#10;#yarpocuoit .gt_center {
  text-align: center;
}
&#10;#yarpocuoit .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#yarpocuoit .gt_font_normal {
  font-weight: normal;
}
&#10;#yarpocuoit .gt_font_bold {
  font-weight: bold;
}
&#10;#yarpocuoit .gt_font_italic {
  font-style: italic;
}
&#10;#yarpocuoit .gt_super {
  font-size: 65%;
}
&#10;#yarpocuoit .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#yarpocuoit .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#yarpocuoit .gt_indent_1 {
  text-indent: 5px;
}
&#10;#yarpocuoit .gt_indent_2 {
  text-indent: 10px;
}
&#10;#yarpocuoit .gt_indent_3 {
  text-indent: 15px;
}
&#10;#yarpocuoit .gt_indent_4 {
  text-indent: 20px;
}
&#10;#yarpocuoit .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="11" class="gt_heading gt_title gt_font_normal" style>Some car stuff</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="11" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Like weight and MPG</td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mpg">mpg</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="cyl">cyl</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="disp">disp</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="hp">hp</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="drat">drat</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="wt">wt</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="qsec">qsec</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="vs">vs</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="am">am</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="gear">gear</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="carb">carb</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="mpg" class="gt_row gt_right">21.0</td>
<td headers="cyl" class="gt_row gt_right">6</td>
<td headers="disp" class="gt_row gt_right">160</td>
<td headers="hp" class="gt_row gt_right">110</td>
<td headers="drat" class="gt_row gt_right">3.90</td>
<td headers="wt" class="gt_row gt_right">2.620</td>
<td headers="qsec" class="gt_row gt_right">16.46</td>
<td headers="vs" class="gt_row gt_right">0</td>
<td headers="am" class="gt_row gt_right">1</td>
<td headers="gear" class="gt_row gt_right">4</td>
<td headers="carb" class="gt_row gt_right">4</td></tr>
    <tr><td headers="mpg" class="gt_row gt_right gt_striped">21.0</td>
<td headers="cyl" class="gt_row gt_right gt_striped">6</td>
<td headers="disp" class="gt_row gt_right gt_striped">160</td>
<td headers="hp" class="gt_row gt_right gt_striped">110</td>
<td headers="drat" class="gt_row gt_right gt_striped">3.90</td>
<td headers="wt" class="gt_row gt_right gt_striped">2.875</td>
<td headers="qsec" class="gt_row gt_right gt_striped">17.02</td>
<td headers="vs" class="gt_row gt_right gt_striped">0</td>
<td headers="am" class="gt_row gt_right gt_striped">1</td>
<td headers="gear" class="gt_row gt_right gt_striped">4</td>
<td headers="carb" class="gt_row gt_right gt_striped">4</td></tr>
    <tr><td headers="mpg" class="gt_row gt_right">22.8</td>
<td headers="cyl" class="gt_row gt_right">4</td>
<td headers="disp" class="gt_row gt_right">108</td>
<td headers="hp" class="gt_row gt_right">93</td>
<td headers="drat" class="gt_row gt_right">3.85</td>
<td headers="wt" class="gt_row gt_right">2.320</td>
<td headers="qsec" class="gt_row gt_right">18.61</td>
<td headers="vs" class="gt_row gt_right">1</td>
<td headers="am" class="gt_row gt_right">1</td>
<td headers="gear" class="gt_row gt_right">4</td>
<td headers="carb" class="gt_row gt_right">1</td></tr>
    <tr><td headers="mpg" class="gt_row gt_right gt_striped">21.4</td>
<td headers="cyl" class="gt_row gt_right gt_striped">6</td>
<td headers="disp" class="gt_row gt_right gt_striped">258</td>
<td headers="hp" class="gt_row gt_right gt_striped">110</td>
<td headers="drat" class="gt_row gt_right gt_striped">3.08</td>
<td headers="wt" class="gt_row gt_right gt_striped">3.215</td>
<td headers="qsec" class="gt_row gt_right gt_striped">19.44</td>
<td headers="vs" class="gt_row gt_right gt_striped">1</td>
<td headers="am" class="gt_row gt_right gt_striped">0</td>
<td headers="gear" class="gt_row gt_right gt_striped">3</td>
<td headers="carb" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><td headers="mpg" class="gt_row gt_right">18.7</td>
<td headers="cyl" class="gt_row gt_right">8</td>
<td headers="disp" class="gt_row gt_right">360</td>
<td headers="hp" class="gt_row gt_right">175</td>
<td headers="drat" class="gt_row gt_right">3.15</td>
<td headers="wt" class="gt_row gt_right">3.440</td>
<td headers="qsec" class="gt_row gt_right">17.02</td>
<td headers="vs" class="gt_row gt_right">0</td>
<td headers="am" class="gt_row gt_right">0</td>
<td headers="gear" class="gt_row gt_right">3</td>
<td headers="carb" class="gt_row gt_right">2</td></tr>
    <tr><td headers="mpg" class="gt_row gt_right gt_striped">18.1</td>
<td headers="cyl" class="gt_row gt_right gt_striped">6</td>
<td headers="disp" class="gt_row gt_right gt_striped">225</td>
<td headers="hp" class="gt_row gt_right gt_striped">105</td>
<td headers="drat" class="gt_row gt_right gt_striped">2.76</td>
<td headers="wt" class="gt_row gt_right gt_striped">3.460</td>
<td headers="qsec" class="gt_row gt_right gt_striped">20.22</td>
<td headers="vs" class="gt_row gt_right gt_striped">1</td>
<td headers="am" class="gt_row gt_right gt_striped">0</td>
<td headers="gear" class="gt_row gt_right gt_striped">3</td>
<td headers="carb" class="gt_row gt_right gt_striped">1</td></tr>
  </tbody>
  &#10;  
</table>
</div>

------------------------------------------------------------------------

# Generated figures

It’s good practice to use a separate chunk to display a figure. Some
chunk options:

- fig.width \# in inches
- fig.height \# in inches
- out.width \# syntax ‘50%’, sets width relative to document
- out.height \# ditto
- fig.align \# ‘left’ ‘right’ ‘center’
- fig.cap \# caption

A fairly basic ggplot:

![](README_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

A smaller figure (50% linewidth), centered:

<img src="README_files/figure-gfm/unnamed-chunk-9-1.png" width="50%" style="display: block; margin: auto;" />

------------------------------------------------------------------------

# Imported images

To import an image, include it in your directory. The basic Markdown
method is this: `![penguin](tux.png){width=25% height=25%}`.

If you want more control, however, use a code chunk with
`knitr::include_graphics()`, so you can exploit the chunk options:

<div class="figure" style="text-align: center">

<img src="tux.png" alt="penguin" width="25%" />
<p class="caption">
penguin
</p>

</div>

------------------------------------------------------------------------

Happy downmarking!

—Jesse
