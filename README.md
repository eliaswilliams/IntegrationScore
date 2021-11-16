
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Integration Score

<!-- badges: start -->
<!-- badges: end -->

## TODO

-   pivot to outlier detection
-   explain why DEGs should be somewhat correlated

## Description

When biological data are obtained using different instruments, by
different researchers, or under other different conditions,
non-biological variation is introduced into the data set. This
non-biologically relevant variance is called a batch effect.

When analyzing a data set with potential batch effects, one must be
careful to first remove as much of this effect as possible. The process
of removing batch effects is referred to as batch correction. If proper
batch correction is not applied then the results of any downstream
analyses performed may be useless, since there is now way for these
downstream tasks to distinguish between real biological signal and
batch-effect-related noise.

On the other hand, it is also possible to over batch correct and
inadvertently remove important biologically-relevant variation from the
data. The process of merging data sets produced or measured under
different conditions is called integration. Striking an appropriate
balance with your batch correction algorithm and parameters is a vital
step of integration.

Several R packages exist that score batch effects in a given data set.
These scores are useful measures of how much batch effect may exist in a
given data set. An example of such a score is kBET. kBET measures the
mixing of batches by comparing the local distribution of batch labels in
a sample of neighborhoods to the global distribution of batch labels.

The objective of IntegrationScore is to allow researchers working with
scRNA-seq data to compare the effectiveness of batch correction methods
using a different measure. That measure being: in a given batch, are the
differentiated expressed genes (DEGs) between clusters somewhat
invariant under the batch correction method? (i.e. the list of top DEGs
should not be significantly altered by batch correction) This R package
enables scientists to quickly perform this sanity check as well as
implement other additional metrics and interpret the results using clear
visualizations.

IntegrationScore was developed on a Mac using R 4.1.1.

## Installation

You can install the development version of IntegrationScore from
[GitHub](https://github.com/) with:

``` r
require("devtools")
devtools::install_github("eliaswilliams/IntegrationScore")
library("IntegrationScore")
```

To run the shinyApp: Under construction

## Overview

## Contributions

## References

<https://satijalab.org/seurat/articles/integration_introduction.html>
<https://github.com/satijalab/seurat-data>

## Acknowledgements

This package was developed as part of an assessment for 2021 BCB410H:
Applied Bioinfor-matics, University of Toronto, Toronto, CANADA.
