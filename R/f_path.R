#' Get package root path
#' @description  Define relative file path for overcoming working directory madness
#' @param ... character string for the filepath to be concatenated to the project directory root path.
#' @details Please see \url{https://github.com/krlmlr/rprojroot.git} on github for details. Note that this definition of the function checks for R package scaffolding in order to find the root path (as opposed to Rstudio files, etc).
#' @export
#' @import rprojroot
f_path <- function(...) {
        fn <- rprojroot::is_r_package$make_fix_file()
        fn(...)
}