library(diffobj)

test_that("RDS", {
  f1 <- tempfile()
  f2 <- tempfile()
  on.exit(unlink(c(f1, f2)))

  mx1 <- mx2 <- matrix(1:9, 3)
  mx2[5] <- 99
  saveRDS(mx1, f1)
  saveRDS(mx2, f2)

  expect_is(diffobj:::get_rds(f1), "matrix")
  expect_is(diffobj:::get_rds(f2), "matrix")

  ref <- as.character(diffPrint(mx1, mx2))
  expect_identical(as.character(diffPrint(mx1, f2)), ref)
  expect_identical(as.character(diffPrint(f1, mx2)), ref)
  expect_identical(as.character(diffPrint(f1, f2)), ref)
  expect_true(!identical(as.character(diffPrint(mx1, f2, rds=FALSE)), ref))
})

test_that("file", {
  f1 <- tempfile()
  f2 <- tempfile()
  on.exit(unlink(c(f1, f2)))
  letters2 <- letters
  letters2[15] <- "HELLO"

  writeLines(letters, f1)
  writeLines(letters2, f2)

  expect_identical(
    as.character(diffChr(letters, letters2)),
    as.character(diffFile(f1, f2))
  )
})

test_that("CSV", {
  f1 <- tempfile()
  f2 <- tempfile()
  on.exit(unlink(c(f1, f2)))

  iris2 <- iris
  iris2$Sepal.Length[25] <- 9.9

  write.csv(iris, f1, row.names=FALSE)
  write.csv(iris2, f2, row.names=FALSE)

  expect_identical(
    as.character(diffPrint(iris, iris2)),
    as.character(diffCsv(f1, f2))
  )
})