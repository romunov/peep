#' Prepare row names
#'
#' Convert rownames so that they are padded 0 to max rowname width
#' and append colon at the end. Rows 1:10 should now look like 01:
#' ... 10:.
#'
#' @param x Data.frame for which rownames will be modified
#' @return A data.frame with rows modified (1 becomes "01:" in
#' a data.frame with more than 9 rows).
prepareRownames <- function(x) {
  rownames(x) <- 1:nrow(x)

  max.w <- max(nchar(rownames(x)))

  tmp <- paste("%0", max.w, "d:", sep = "")

  sprintf(tmp, as.numeric(rownames(x)))
}
