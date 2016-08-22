#' Summarise by quadrat data into per transect data with key variables for updating the GrasslandBBN
#'
#' @param field_data_by_quadrat
#'
#' @return field_data_by_transect
#' @export
#' @import dplyr
#' @import tidyr
#'
summarise_by_transect <- function(field_data_by_quadrat) {
        # Get percent_cover variables
        percent_cover_dat <-
                field_data_by_quadrat %>%
                dplyr::group_by(transect_number, quadrat, type) %>%
                dplyr::summarise(pc_type = sum(percent_cover)) %>%
                dplyr::filter(type == "BG" | type == "E") %>%
                tidyr::spread(type, pc_type) %>%
                dplyr::group_by(transect_number) %>%
                dplyr::select(-quadrat) %>%
                dplyr::summarise_each(funs = "mean") %>%
                dplyr::mutate(BG = ifelse(is.na(BG), 0, BG),
                              E = ifelse(is.na(E), 0, E)) %>%
                dplyr::rename(E_pc = E, BG_pc = BG)
        # Get diversity variables
        diversity_dat <-
                field_data_by_quadrat %>%
                dplyr::group_by(transect_number, type) %>%
                tally %>%
                dplyr::filter(type == "E" | type == "NF") %>%
                tidyr::spread(type, n) %>%
                dplyr::rename(NF_diversity = NF, E_diversity = E)
        # Get Management History variables
        management_history_dat <-
                field_data_by_quadrat %>%
                dplyr::select(transect_number, management, years_since) %>%
                dplyr::distinct()
        # Merge all data and return:
        field_data_by_transect <- dplyr::left_join(percent_cover_dat, diversity_dat) %>%
                dplyr::left_join(management_history_dat)
        return(field_data_by_transect)
}
