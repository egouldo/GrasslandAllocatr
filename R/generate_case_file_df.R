#' Generate Netica Case File as a \code{data_frame}
#'
#' @param field_data_by_mu Field data that has been summarised by management unit. Must contain the column \code{management_unit}.
#'
#' @return casefile_df A dataframe of the same dimensions as \code{field_data_by_mu}, but with the \code{management_unit} column removed and a new \code{IDnum} column.
#' @export
#' @import dplyr
#' @import magrittr
#' @import purrr
#'
generate_case_file_df <- function(field_data_by_mu){

        casefile_df <- field_data_by_mu %>%
                tbl_df()
        # Define legal candidate actions, and function to ID illegal ones
        candidate_actions <- c("No_Management",
                               "WC",
                               "Fire_WC",
                               "Grazing_WC",
                               "SowingForbs_WC")
        filter_candidate_action <- function(x) ifelse(x %in% candidate_actions,yes = x,no = NA)
        # Replace any illegal action in Management cols with NA, otherwise, keep.
        casefile_df %<>% mutate_at(.cols = vars(contains("Management", ignore.case = FALSE)) , .funs = filter_candidate_action) %>% drop_na()
        # Remove management_unit col, add IDnum col:
        casefile_df %<>%
                dplyr::select(-management_unit) %>%
                dplyr::mutate(IDnum = c(1:n()))
        return(casefile_df)
}