#' Fit data.frame print into console width
#' @param x Data.frame  or matrix to be printed. Object is coerced to
#' data.frame.
#' @param n Integer. Max number of first and last rows to print.
#' Default is 6.
#' @param digits Integer, to what number of digits numeric columns
#' are being rounded. Default is 4.
#' @param r2c Logical. If \code{TRUE}, rownames are coerced to a
#' column which is placed at the beginning of the data.frame.
#' Default is FALSE.
#' @return Invisibly returns a data.frame in case you would need it
#' for some reason. The main side effect is printing of the abridged
#' version to the console.
#' @author Roman Lustrik (roman.lustrik@@biolitika.si)
#' @importFrom utils head tail
#' @export
peep <- function(x, n = 6, digits = 4, r2c = FALSE) {
  console.width <- options()$width
  dot <- "\u00b7"

  x <- data.frame(x, check.names = FALSE)

  # Round numeric classes to optimize printing the number of columns.
  cols.numeric <- sapply(x, FUN = class)
  x[, cols.numeric == "numeric"] <- signif(x[, cols.numeric == "numeric", drop = FALSE], digits = digits)

  # Coerce rownames to column and place it at the first position in
  # the data.frame.
  if (r2c == TRUE) {
    # We need to overwrite column names because subsettings messes them up.
    cn <- colnames(x)
    x$rn <- rownames(x)
    nc <- ncol(x)

    x <- x[, c(nc, 1:(nc - 1))]
    colnames(x) <- c("rn", cn)
  }

  # Make rownames into digits and pad them with leading zeros.
  rownames(x) <- prepareRownames(x)

  if (nrow(x) > (2 * n)) {
    topcols <- rbind(head(x, n = n), tail(x, n = n))
  } else {
    topcols <- x
  }

  # Find max widths (either colname or values) for all columns (depends on class).
  max.col.valu.widths <- apply(X = topcols,
                               MARGIN = 2,
                               FUN = function(m) max(nchar(m)))
  max.col.name.widths <- nchar(colnames(topcols))
  max.col.widths <- rbind(max.col.valu.widths, max.col.name.widths)
  max.col.widths <- apply(X = max.col.widths, MARGIN = 2, FUN = max)
  max.col.widths <- max.col.widths + 1 # due to space between columns

  # See how many columns from left and right can be safely printed
  # without breaking a line
  working.width <- max(nchar(rownames(x)))  # adds rowname width
  columns <- list(left = c(), right = c())

  inward.slider <- data.frame(left = 1:ncol(x), right = rev(1:ncol(x)))

  for (i in 1:ncol(x)) {
    is <- inward.slider[i, ]

    if ((working.width + max.col.widths[is$left]) >= console.width) {
      columns$left <- c(columns$left, NA)
    } else {
      working.width <- working.width + max.col.widths[is$left]
      columns$left <- c(columns$left, is$left)
    }

    if (working.width + max.col.widths[is$right] >= console.width) {
      columns$right <- c(columns$right, NA)
    } else {
      working.width <- working.width + max.col.widths[is$right]
      columns$right <- c(columns$right, is$right)
    }

    if (any(is.na(columns$left)) & any(is.na(columns$right))) {
      break
    }
  }

  columns$left <- na.omit(columns$left)
  columns$right <- na.omit(columns$right)

  # This is the column that will be converted to dots.
  dots <- which.max(lengths(columns))
  if (names(dots) == "left") {
    dots <- max(columns$left)
  } else {
    dots <- min(columns$right)
  }

  columns <- c(na.omit(columns$left), na.omit(columns$right))
  columns <- unique(sort(columns))

  if (length(columns) >= ncol(x)) {
    out <- clipAndAddHorizontalDivider(x = x, dot = dot, n = n)

    return(out)
  }

  # This is a hackish way of constructing the data.frame. If you use
  # regular subsetting, i.e. x[, columns], it appends `.1` to column
  # names and messes everything up. The workaround here is to use
  # cbind(), grow the final object and go to hell. I'll take one for
  # the team.
  save.rownames <- rownames(x)

  const.out <- x[, 1, drop = FALSE]
  for (i in columns[-1]) {
    const.out <- cbind(const.out, x[, i, drop = FALSE])
  }
  x <- do.call(cbind, const.out)

  x <- as.data.frame(x, stringsAsFactors = FALSE)
  rownames(x) <- save.rownames

  # Add vertical divider by converting a column to dots.
  x[, dots] <- dot
  colnames(x)[dots] <- paste(rep(" ", times = min(max.col.widths[dots], 2)), collapse = "")

  # Add horizontal divider.
  out <- clipAndAddHorizontalDivider(x = x, dot = dot, n = n)

  print(out)

  return(invisible(out))
}
