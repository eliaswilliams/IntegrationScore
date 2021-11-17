
data("deg_df")

test_that("returns dataframe of correct shape", {
        data("deg_df")

        expect_s3_class(corrDEG(deg_df), "data.frame")
        expect_equal(dim(corrDEG(deg_df))[2], 6)
})
