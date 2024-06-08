test_that("get_jstage_volumes returns ERR_001 for material = '\u3042'", {
  d <- get_jstage_volumes(material = "\u3042", language = "")
  expect_equal(d$metadata$status, "ERR_001")
})
