# Required packages for the analysis.
# Install any missing package manually with install.packages("package_name").

required_packages <- c("dplyr", "readr", "slider")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    "Install these packages before continuing: ",
    paste(missing_packages, collapse = ", "),
    call. = FALSE
  )
}

library(dplyr)
library(readr)
library(slider)
