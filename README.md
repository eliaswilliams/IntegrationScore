
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Integration Score

<!-- badges: start -->
<!-- badges: end -->

## Description

\[DESCRIBE WHAT A BATCH EFFECT IS, STATE ASSUMPTIONS\]

The objective of IntegrationScore is to allow researchers working with
scRNA-seq data to compare the effectiveness of batch correction
methods.Several R packages exist that score batch effects in a given
data set (kBET: <https://github.com/theislab/kBET>, BatchBench:
<https://academic.oup.com/nar/article/49/7/e42/6125660>). These scores
are useful metrics of comparison, but only if a given method passes a
basic sanity check first. That check being: in a given batch, are the
differentiated expressed genes (DEGs) between clusters somewhat
invariant under the batch correction method? (i.e. the list of top DEGs
should not be significantly altered by batch correction)My proposed R
package will enable scientists to quickly perform this sanity check as
well as implement these additional metrics and interpret the results
using clear visualizations.

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

## Acknowledgements

This package was developed as part of an assessment for 2021 BCB410H:
Applied Bioinfor-matics, University of Toronto, Toronto, CANADA.
