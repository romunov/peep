#' Add a horizontal divider
#'
#' For data.frames that have more rows than limited by n, adds
#' a horizontal divider by replacing the middle row with dots.
#'
#' @param x Data.frame to be modified.
#' @param dot Character, used in the divider.
#' @param n Integer, how many rows to print with \code{head} and
#' \code{tail}.
#' @return A data.frame with added horizontal divider, provided the
#' data.frame has more than \code{n} rows.
#' @importFrom utils head tail
clipAndAddHorizontalDivider <- function(x, dot, n) {
  if (nrow(x) <= (2 * n)) {
    return(x)
  }

  hor.line <- x[1, ]
  rownames(hor.line) <- ""

  for (i in 1:ncol(hor.line)) {
    hor.line[, i] <- dot
  }

  out <- rbind.data.frame(
    head(x, n = n),
    hor.line,
    tail(x, n = n),
    stringsAsFactors = FALSE
  )

  out
}



