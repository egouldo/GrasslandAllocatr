#' Build raw field data set complete with species type and management history data
#'
#' @details This is an internal function for building the paper vignette with the Remake package
#' @param raw_field_data_path Path to the CSV file containing the raw field data, see \code{\link{lookup_species}} and \code{\link{lookup_management}}.
#' @param species_lookup_data_path Path to the CSV file containing the species lookup data see \code{\link{lookup_species}}.
#' @param management_lookup_data_path Path to the CSV file containing the management lookup data, see \code{\link{lookup_management}}.
#'
#' @return field_data_by_quadrat This is the complete field dataset in raw form containing both management history for each transect, as well as the type code for each species (i.e. row in the dataset).
#' @import readr
#' @export
#'
build_raw_dataset <- function(raw_field_data_path,species_lookup_data_path,management_lookup_data_path) {
        # Get required datasets
        raw_field_data <-
                readr::read_csv(raw_field_data_path)
        management_lookup_data <-
                readr::read_csv(management_lookup_data_path)
        species_lookup_data <-
                readr::read_csv(species_lookup_data_path)
        # lookup species
        field_data_by_quadrat <-
                GrasslandAllocatr::lookup_species(raw_field_data = raw_field_data,
                                                  species_lookup_data = species_lookup_data)
        # lookup management
       field_data_by_quadrat <-
                GrasslandAllocatr::lookup_management(raw_field_data = field_data_by_quadrat,
                                                     management_lookup_data = management_lookup_data)
        return(field_data_by_quadrat)
}



