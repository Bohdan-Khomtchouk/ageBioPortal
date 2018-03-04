<div align="center">

<img src="https://github.com/Bohdan-Khomtchouk/ageBioPortal/blob/master/ageBioPortal/www/ageBioPortal_logo_oval.png">

##### Web server for aging-related diseases

</div>

## Introduction
Currently, there is no open-access resource for interactive exploration of multidimensional aging genomics datasets that can rival the utility, simplicity, and power of the Cancer Bio Portal ([Cerami et al. 2012](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3956037/)). Developing an equivalent aging genomics portal could significantly lower the barriers between complex aging genomic data and researchers who want rapid, intuitive, and high-quality access to molecular profiles and clinical attributes from large-scale aging genomics projects. Due to the computational limitations (relative to [cBioPortal](https://github.com/cBioPortal/)) of existing online platforms such as the [Human Ageing Genomic Resources](http://genomics.senescence.info), we propose to create `ageBioPortal` - an open platform for integrating multidimensional aging data to explore patterns in gene expression, somatic mutations, DNA copy number, and other attributes important for translating aging data into large-scale biologic insights and clinical applications more effectively.  Two aims are proposed:

   * Build a web platform that can search information for a gene of interest from aggregated aging-related datasets (RNA-seq, GWAS, microarray, etc.) of aged tissue and aging-related diseases (e.g., COPD, Alzheimer's, type II diabetes, etc.).  The goal is to type in the name of a gene (e.g., RAS, PTEN, HDAC1, EZH2 etc.) and the website will provide an output showing levels of expression of this gene and any genomic data from different datasets stratified by age, tissue and disease.
  * Test the web platform by comparing search results in the platform obtained for a set of histone lysine methyltransferase studied in the [Gozani lab](https://web.stanford.edu/group/gozani/cgi-bin/gozanilab/) (e.g. NSD2, SETD2 & Suv420H1) to targeted manual searches for the same genes.
  
## Purpose
As stated above, the goal of this project is for `ageBioPortal` to function as a user-friendly web platform for researchers to simply enter the name of a gene and receive an output that is similar in utility to that of cBioPortal. Towards this end, we will use an iterative process comparing `ageBioPortal` output for epigenetic genes studied in the Gozani lab with manual searches. We will also leverage work of these targets done in the Gozani lab to guide the search engine. Overall, success of this project should provide a powerful new tool for aging biology researchers and lower the barrier for researchers in other areas to study aging at a molecular/gene level.

## Impact

`ageBioPortal` is transforming aging from a diverse set of wet-lab pursuits across a variety of disease domains into a unified data science.  Also, `ageBioPortal` is bringing computing to aging in a time when research in this field is clearly an underdeveloped area (at least relative to cancer research -- at the time of writing, there are [126 Github repositories with the 'cancer' tag](https://github.com/topics/cancer) vs. [9 repos with the 'aging' tag](https://github.com/topics/aging)).  Perhaps most importantly, `ageBioPortal` is bringing together people from diverse areas of aging-related disease research that normally would not crosstalk much with each other (e.g., Alzheimer's and diabetes research communities) to one common web platform, thereby establishing aging as an interdisciplinary and integrative data science.

## Usage (for general public)

##### http://agebioportal.com 

## Installation (for developers only)

### Requirements for developers

* [R programming language](https://www.r-project.org)
  * [RStudio IDE](https://www.rstudio.com/products/rstudio/download/#download)

## How to run (for developers only)

##### Git clone this repo to your computer, and in RStudio type:
* `setwd("~/path/to/my_directory_that_contains_agebioportal_folder")` (or in the RStudio IDE menu bar, go to `Session`, then `Set Working Directory`, and then `Choose Directory`)
* `install.packages("shiny")`
* `library(shiny)`
* `install.packages("shinyWidgets")`
* `library(shinyWidgets)`
* `runApp("agebioportal")`

Repeat the `install.packages()` and `library()` sequence for any other R packages that `ageBioPortal` relies on. 

## I think this is fun, how can I help?
There are many simple things that can help this project greatly:

  * Send a tweet supporting this project.
  * You are probably sitting next to another developer right now, tell them about `ageBioPortal`.
  * If you want to contribute to the project, that's amazing! Open an issue on GitHub and let's talk about it.

## Contact
You are welcome to:

* submit suggestions and bug-reports at: <https://github.com/Bohdan-Khomtchouk/ageBioPortal/issues>
* send a pull request on: <https://github.com/Bohdan-Khomtchouk/ageBioPortal>
* compose an e-mail to: <bohdan@stanford.edu>

## Code of conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

## Funding
`ageBioPortal` is supported by the National Institute on Aging of the National Institutes of Health under Award Number T32 AG0047126 awarded to Bohdan Khomtchouk. The content is solely the responsibility of the author(s) and does not necessarily represent the official views of the National Institutes of Health.

## Citation
Coming soon! 
