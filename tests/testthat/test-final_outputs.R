context("Check final outputs")

options(width = 80)

xy <- mtcars
xy$brand <- rownames(xy)
xy$mpg <- as.factor(xy$mpg)
xy$gear <- as.character(xy$gear)

xy <- xy[, c("brand", "mpg", "cyl", "disp", "hp",
             "drat", "wt", "qsec", "vs", "am", "gear",
             "carb", "mpg", "cyl", "disp", "hp", "drat", "drat", "drat")]

valid.full <- dget("valid_full")
valid.extra.n <- dget("valid_extran")
valid.3cols <- dget("valid_3cols")
valid.3rows <- dget("valid_3rows")
valid.r2c <- dget("valid_r2c")

test.full <- peep(xy)
test.extra.n <- peep(xy, n = 8)
test.3cols <- peep(xy[, 1:3])
test.3rows <- peep(xy[1:3, ])
test.r2c <- peep(xy, r2c = TRUE)

test_that("Test high level peep functionality", {
  expect_equal(test.full, valid.full)
  expect_equal(test.extra.n, valid.extra.n)
  expect_equal(test.3cols, valid.3cols)
  expect_equal(test.3rows, valid.3rows)
  expect_equal(test.r2c, valid.r2c)
})

context("Check internals")

smolx <- data.frame(a = 1:10)
test.smolx <- peep:::prepareRownames(smolx)

clw <- data.frame(longname = 1, srt = "long value")
test.clw <- peep:::maxColumnWidth(clw)

test_that("Test internal workings", {
  expect_length(test.smolx, 10)
  expect_equal(test.smolx, c("01:", "02:", "03:", "04:", "05:", "06:", "07:", "08:", "09:", "10:"))
  expect_equal(test.clw, c(longname = 8L, srt = 10L))
})
