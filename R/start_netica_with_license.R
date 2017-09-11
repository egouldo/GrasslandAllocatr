#' Start Netica with License
#'
#' @param LicensePath Filepath to
#' @return NeticaLicenseKey Returns \code{NeticaLicenseKey} to the parent environment.
#' @export
#' @description The return of \code{NeticaLicenseKey} is not the main outcome of the function, but is simply a precaution to guard against potential calls of \code{library(RNetica)}, whereby RNetica will be started with new license details. Calling \code{library(RNetica)} in the same environment where \code{NeticaLicenseKey} exists will result in Netica using this license.
start_netica_with_license <- function(LicensePath){
        load(LicensePath)
        library(RNetica)
        RNetica::StopNetica()
        RNetica::StartNetica(license = LicenseKey)
        NeticaLicenseKey <- load(LicensePath)
        return(NeticaLicenseKey)
}