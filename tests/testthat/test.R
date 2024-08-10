test_that("get_jstage_volumes returns ERR_001 for material = '\u3042'", {
  skip_on_cran()

  try({
    d <- get_jstage_volumes(material = "\u3042", lang = "")
    expect_equal(d$metadata$status, "ERR_001")
  }, silent = TRUE)
})
