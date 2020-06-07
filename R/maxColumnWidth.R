#' Return max column width
#'
#' Depending on the class of the column, max of column name or
#' column content width is returned. If numeric, number of
#' printing digits is taken into account.
#'
#' @param x A data.frame to be processed.
#' @return A vector of max column widths (either value or column
#' name).
maxColumnWidth <- function(x) {
  if (any(class(x) != "data.frame")) return(NULL)

  classes <- sapply(x, FUN = class)

  out <- rep(NA, times = ncol(x))
  names(out) <- colnames(x)

  for (i in names(classes)) {
    column <- x[, i, drop = FALSE]

    width.colname <- nchar(i)

    if (classes[i] == "numeric") {
      width.value <- max(sapply(column, FUN = nchar), getOption("digits"))
    }

    if (classes[i] == "character") {
      width.value <- max(sapply(column, FUN = nchar), nchar(colnames(column)))
    }

    if (classes[i] == "factor") {
      width.value <- max(sapply(column, FUN = function(tc) nchar(as.character(tc))))
    }

    if (classes[i] == "logical") {
      width.value <- max(sapply(column, FUN = nchar))
    }

    out[i] <- max(width.colname, width.value)
  }

  return(out)
}
