#' Prepare row names
#'
#' Convert rownames so that they are padded 0 to max rowname width
#' and append colon at the end. Rows 1:10 should now look like 01:
#' ... 10:.
#'
#' @param x Data.frame used to read number of rows
#' @param n Integer, number of head and tail rows returned
#' @param nr Integer, number of rows in the original object
#'
#' @return A data.frame with rows modified (1 becomes "01:" in
#' a data.frame with more than 9 rows).
prepareRownames <- function(x, n, nr) {
  if (nr >= 2 * n) {
    rn <- c(1:n, (nr - n):nr)
  } else {
    rn <- 1:nrow(x)
  }

  max.w <- max(nchar(rn))
  tmp <- paste("%0", max.w, "d:", sep = "")

  sprintf(tmp, rn)
}
