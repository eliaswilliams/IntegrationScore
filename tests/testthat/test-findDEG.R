
test_that("returns dataframe with correct columns ", {

        library(Seurat)
        data("ifnb_split")
        data("ifnb_split_corrected")
        expect_type(findDEG(ifnb_split, ifnb_split_corrected, batchVar="stim"), "data.frame")
        expect
})
