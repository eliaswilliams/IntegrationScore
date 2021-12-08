


test_that("returns ggplot", {
        library(Seurat)
        data("ifnb_split")
        data("ifnb_corrected")
        expect_equal(class(plotUMAP(ifnb_split, ifnb_split_corrected, colorBy="stim"))[3], "ggplot")
})
