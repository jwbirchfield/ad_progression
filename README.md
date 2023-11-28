A multivariate longitudinal model with subject-varying effects for the
physical and mental progression of Alzheimer’s Disease
================
Jesse Birchfield, Robert Weiss, Andrew Holbrook

------------------------------------------------------------------------

This is the Github repo for the second chapter of my dissertation.

<div id="jbfzgiwywt" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#jbfzgiwywt table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#jbfzgiwywt thead, #jbfzgiwywt tbody, #jbfzgiwywt tfoot, #jbfzgiwywt tr, #jbfzgiwywt td, #jbfzgiwywt th {
  border-style: none;
}
&#10;#jbfzgiwywt p {
  margin: 0;
  padding: 0;
}
&#10;#jbfzgiwywt .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: solid;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 3px;
  border-top-color: #D3D3D3;
  border-right-style: solid;
  border-right-width: 3px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 3px;
  border-bottom-color: #D3D3D3;
  border-left-style: solid;
  border-left-width: 3px;
  border-left-color: #D3D3D3;
}
&#10;#jbfzgiwywt .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#jbfzgiwywt .gt_title {
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
&#10;#jbfzgiwywt .gt_subtitle {
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
&#10;#jbfzgiwywt .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: solid;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: solid;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#jbfzgiwywt .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
}
&#10;#jbfzgiwywt .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #5F5F5F;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
  border-left-style: solid;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: solid;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#jbfzgiwywt .gt_col_heading {
  color: #FFFFFF;
  background-color: #0076BA;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: solid;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: solid;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#jbfzgiwywt .gt_column_spanner_outer {
  color: #FFFFFF;
  background-color: #0076BA;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#jbfzgiwywt .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#jbfzgiwywt .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#jbfzgiwywt .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#jbfzgiwywt .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#jbfzgiwywt .gt_group_heading {
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
  border-top-color: #5F5F5F;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
  border-left-style: solid;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: solid;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#jbfzgiwywt .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #5F5F5F;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
  vertical-align: middle;
}
&#10;#jbfzgiwywt .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#jbfzgiwywt .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#jbfzgiwywt .gt_row {
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
&#10;#jbfzgiwywt .gt_stub {
  color: #333333;
  background-color: #89D3FE;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D5D5D5;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#jbfzgiwywt .gt_stub_row_group {
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
&#10;#jbfzgiwywt .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#jbfzgiwywt .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#jbfzgiwywt .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#jbfzgiwywt .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #5F5F5F;
}
&#10;#jbfzgiwywt .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#jbfzgiwywt .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
}
&#10;#jbfzgiwywt .gt_grand_summary_row {
  color: #333333;
  background-color: #D5D5D5;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#jbfzgiwywt .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 6px;
  border-top-color: #5F5F5F;
}
&#10;#jbfzgiwywt .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 6px;
  border-bottom-color: #5F5F5F;
}
&#10;#jbfzgiwywt .gt_striped {
  background-color: #EDF7FC;
}
&#10;#jbfzgiwywt .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #5F5F5F;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
}
&#10;#jbfzgiwywt .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: solid;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#jbfzgiwywt .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#jbfzgiwywt .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: solid;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#jbfzgiwywt .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#jbfzgiwywt .gt_left {
  text-align: left;
}
&#10;#jbfzgiwywt .gt_center {
  text-align: center;
}
&#10;#jbfzgiwywt .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#jbfzgiwywt .gt_font_normal {
  font-weight: normal;
}
&#10;#jbfzgiwywt .gt_font_bold {
  font-weight: bold;
}
&#10;#jbfzgiwywt .gt_font_italic {
  font-style: italic;
}
&#10;#jbfzgiwywt .gt_super {
  font-size: 65%;
}
&#10;#jbfzgiwywt .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#jbfzgiwywt .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#jbfzgiwywt .gt_indent_1 {
  text-indent: 5px;
}
&#10;#jbfzgiwywt .gt_indent_2 {
  text-indent: 10px;
}
&#10;#jbfzgiwywt .gt_indent_3 {
  text-indent: 15px;
}
&#10;#jbfzgiwywt .gt_indent_4 {
  text-indent: 20px;
}
&#10;#jbfzgiwywt .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_title gt_font_normal" style>Fit statistics across 8 models</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>by 5-fold cross-validation, applied to MMSE outcome only</td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="model">model</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="other outcomes">other outcomes</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="transformed MMSE">transformed MMSE</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="conditional LEPD">conditional LEPD</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="marginal conditional LEPD">marginal conditional LEPD</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="model" class="gt_row gt_left">1</td>
<td headers="other outcomes" class="gt_row gt_left">FSLong</td>
<td headers="transformed MMSE" class="gt_row gt_left">FALSE</td>
<td headers="conditional LEPD" class="gt_row gt_left">-5586.3</td>
<td headers="marginal conditional LEPD" class="gt_row gt_left">-5086.1</td></tr>
    <tr><td headers="model" class="gt_row gt_left gt_striped">2</td>
<td headers="other outcomes" class="gt_row gt_left gt_striped">ANTsSST</td>
<td headers="transformed MMSE" class="gt_row gt_left gt_striped">FALSE</td>
<td headers="conditional LEPD" class="gt_row gt_left gt_striped">-5529.9</td>
<td headers="marginal conditional LEPD" class="gt_row gt_left gt_striped">-5149.0</td></tr>
    <tr><td headers="model" class="gt_row gt_left">3</td>
<td headers="other outcomes" class="gt_row gt_left">ECTavg</td>
<td headers="transformed MMSE" class="gt_row gt_left">FALSE</td>
<td headers="conditional LEPD" class="gt_row gt_left">-5531.8</td>
<td headers="marginal conditional LEPD" class="gt_row gt_left">-5103.1</td></tr>
    <tr><td headers="model" class="gt_row gt_left gt_striped">4</td>
<td headers="other outcomes" class="gt_row gt_left gt_striped">FSLong, ANTsSST</td>
<td headers="transformed MMSE" class="gt_row gt_left gt_striped">FALSE</td>
<td headers="conditional LEPD" class="gt_row gt_left gt_striped">-5561.1</td>
<td headers="marginal conditional LEPD" class="gt_row gt_left gt_striped">-5091.8</td></tr>
    <tr><td headers="model" class="gt_row gt_left">5</td>
<td headers="other outcomes" class="gt_row gt_left">FSLong</td>
<td headers="transformed MMSE" class="gt_row gt_left">TRUE</td>
<td headers="conditional LEPD" class="gt_row gt_left">-4854.4</td>
<td headers="marginal conditional LEPD" class="gt_row gt_left">-4536.1</td></tr>
    <tr><td headers="model" class="gt_row gt_left gt_striped">6</td>
<td headers="other outcomes" class="gt_row gt_left gt_striped">ANTsSST</td>
<td headers="transformed MMSE" class="gt_row gt_left gt_striped">TRUE</td>
<td headers="conditional LEPD" class="gt_row gt_left gt_striped">-4829.2</td>
<td headers="marginal conditional LEPD" class="gt_row gt_left gt_striped">-4583.6</td></tr>
    <tr><td headers="model" class="gt_row gt_left">7</td>
<td headers="other outcomes" class="gt_row gt_left">ECTavg</td>
<td headers="transformed MMSE" class="gt_row gt_left">TRUE</td>
<td headers="conditional LEPD" class="gt_row gt_left">-5003.5</td>
<td headers="marginal conditional LEPD" class="gt_row gt_left">-4543.9</td></tr>
    <tr><td headers="model" class="gt_row gt_left gt_striped">8</td>
<td headers="other outcomes" class="gt_row gt_left gt_striped">FSLong, ANTsSST</td>
<td headers="transformed MMSE" class="gt_row gt_left gt_striped">TRUE</td>
<td headers="conditional LEPD" class="gt_row gt_left gt_striped">-4845.2</td>
<td headers="marginal conditional LEPD" class="gt_row gt_left gt_striped">-4539.3</td></tr>
  </tbody>
  &#10;  
</table>
</div>

![](README_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->
