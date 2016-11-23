#' Generate Netica Case File as a \code{data_frame}
#'
#' @param field_data_by_mu Field data that has been summarised by management unit. Must contain the column \code{management_unit}.
#'
#' @return casefile_df A dataframe of the same dimensions as \code{field_data_by_mu}, but with the \code{management_unit} column removed and a new \code{IDnum} column.
#' @export
#' @import dplyr, magrittr
#'
generate_case_file_df <- function(field_data_by_mu){

        casefile_df <- field_data_by_mu %>%
                tbl_df()

        # Ensure that only management actions considered in the model are present within casefile:
        candidate_actions <- c("No_Management",
                               "WC",
                               "Fire_WC",
                               "Grazing_WC",
                               "SowingForbs_WC")
        management_df <-
                casefile_df %>%
                dplyr::select(management_unit, starts_with("Management"))
        colnames(management_df) <- c("management_unit", "management")
        management_df %<>%
                dplyr::filter(management %in% candidate_actions)
        casefile_df %<>%
                dplyr::select(-starts_with("Management",ignore.case = FALSE)) %>%
                dplyr::right_join(.,management_df, by = "management_unit")
        # Remove management_unit col, add IDnum col:
        casefile_df <-  casefile_df %>%
                dplyr::select(-management_unit) %>%
                dplyr::mutate(IDnum = c(1:n()))
        return(casefile_df)
}