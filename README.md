# BULK-RNA-SEQ-SHINY-HEATMAP-TOOL

---

## Overview

**Bulk-RNA-Seq-Shiny-Heatmap-Tool**

This Shiny application streamlines bulk RNA-seq data exploration and visualization with heatmaps for researchers. The core benefits include:

- Custom heatmap generation: Visualize selected genes from uploaded DESeq2 RDS objects with clustering and group filters.  
- Interactive Shiny interface: Upload files, customize heatmap dimensions, and download plots directly from the UI.  
- DGE spreadsheet parser: Quickly explore differential expression results with dynamic gene subsetting.  
- Flexible UI controls: Dynamically render checkboxes and dropdowns based on input data for intuitive customization.  
- Seamless export options: Save high-quality heatmaps as PNG or PDF with user-defined dimensions and filenames.

## Project Structure

```sh
└── Bulk-RNA-Seq-Shiny-Heatmap-Tool/
    ├── app.R
    └── custom-heatmap-function.R
```

### Project Index

<details open>
	<summary><b><code>BULK-RNA-SEQ-SHINY-HEATMAP-TOOL/</code></b></summary>
	<!-- __root__ Submodule -->
	<details>
		<summary><b>__root__</b></summary>
		<blockquote>
			<div class='directory-path' style='padding: 8px 0; color: #666;'>
				<code><b>⦿ __root__</b></code>
			<table style='width: 100%; border-collapse: collapse;'>
			<thead>
				<tr style='background-color: #f8f9fa;'>
					<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
					<th style='text-align: left; padding: 8px;'>Summary</th>
				</tr>
			</thead>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/Users/aleksandrprystupa/Projects/Alex-BINF-Pipelines/Bulk-RNA-Seq-Shiny-Heatmap-Tool/blob/master/custom-heatmap-function.R'>custom-heatmap-function.R</a></b></td>
					<td style='padding: 8px;'>- Create custom heatmap visualizations and extract sample groups from DESeq2 objects<br>- The function plots gene expression data with customizable color schemes and clustering options<br>- It ensures data integrity by matching sample groups with gene counts<br>- Use it to generate insightful heatmaps for your RNA-seq analyses.</td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/Users/aleksandrprystupa/Projects/Alex-BINF-Pipelines/Bulk-RNA-Seq-Shiny-Heatmap-Tool/blob/master/app.R'>app.R</a></b></td>
					<td style='padding: 8px;'>- Generate custom bulk RNA-Seq heatmaps and parse DGE spreadsheets with this Shiny app<br>- Upload RDS files, input gene lists, and customize heatmap dimensions<br>- Cluster rows and columns, download plots as PDF or PNG, and explore DGE data with interactive tables.</td>
				</tr>
			</table>
		</blockquote>
	</details>
</details>

---
