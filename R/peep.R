#' Fit data.frame print into console width
#' @param x Data.frame to be printed.
#' @param n Integer. Max number of first and last rows to print.
#' @param digits Integer, to what number of digits numeric columns
#' are being rounded.
#' @return Invisibly returns a data.frame in case you would need it
#' for some reason. The main side effect is printing of the abridged
#' version to the console.
#' @author Roman Lustrik (roman.lustrik@@biolitika.si)
#' @importFrom utils head tail
#' @export
peep <- function(x, n = 6, digits = 4) {
  console.width <- options()$width
  dot <- "\u00b7"

  cols.numeric <- sapply(x, FUN = class)
  x[, cols.numeric == "numeric"] <- signif(x[, cols.numeric == "numeric", drop = FALSE], digits = digits)

  # make rownames into digits and pad them with leading zeros
  rownames(x) <- prepareRownames(x)

  if (nrow(x) > (2 * n)) {
    topcols <- rbind(head(x, n = n), tail(x, n = n))
  } else {
    topcols <- x
  }

  # find max widths (colname, values) for all columns (depends on class)
  max.col.valu.widths <- apply(X = topcols,
                          MARGIN = 2,
                          FUN = function(m) max(nchar(m)))
  max.col.name.widths <- nchar(colnames(topcols))
  max.col.widths <- rbind(max.col.valu.widths, max.col.name.widths)
  max.col.widths <- apply(X = max.col.widths, MARGIN = 2, FUN = max)
  max.col.widths <- max.col.widths + 1 # due to space between columns
  # print(max.col.widths)

  # see how many columns from left and right can be safely printed without breaking a line
  working.width <- max(nchar(rownames(x))) + 2 # start with width of the rownames + additional space to first column
  columns <- list(left = c(), right = c())

  inward.slider <- data.frame(left = 1:ncol(x), right = rev(1:ncol(x)))

  for (i in 1:ncol(x)) {
    is <- inward.slider[i, ]

    if (working.width + max.col.widths[is$left]>= console.width) {
      next
    }

    working.width <- working.width + max.col.widths[is$left]
    columns$left <- c(columns$left, is$left)

    if (working.width + max.col.widths[is$right] >= console.width) {
      next
    }

    working.width <- working.width + max.col.widths[is$right]
    columns$right <- c(columns$right, is$right)
  }

  # This is the column that will be converted to dots.
  dots <- which.max(lengths(columns))
  if (names(dots) == "left") {
    dots <- max(columns$left)
  } else {
    dots <- min(columns$right)
  }

  columns <- c(columns$left, columns$right)
  columns <- unique(sort(columns))

  if (length(columns) >= ncol(x)) {
    out <- clipAndAddHorizontalDivider(x = x, dot = dot, n = n)

    return(out)
  }

  # Add vertical divider by converting a column to dots.
  x[, dots] <- dot
  colnames(x)[dots] <- paste(rep(" ", times = min(max.col.widths[dots], 2)), collapse = "")

  x <- x[, columns]

  # Add horizontal divider.
  out <- clipAndAddHorizontalDivider(x = x, dot = dot, n = n)

  print(out)

  return(invisible(out))
}
