#' Runs various test to evaluate batch correction
#'
#' @param srtObjPre Seurat object of the uncorrected data
#' @param srtObjPost Seurat object of the corrected data
#' @return
#' @export
scoreIntegration <- function(srtObjPre, srtObjPost) {
        pre_kBET = kBET::kBET()
        post_kBET = kBET::kBET()
}
