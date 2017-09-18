#' Generate Netica Case File as a \code{data_frame}
#'
#' @param field_data_by_mu Field data that has been summarised by management unit. Must contain the column \code{management_unit}.
#'
#' @return casefile_df A dataframe of the same dimensions as \code{field_data_by_mu}, but with the \code{management_unit} column removed and a new \code{IDnum} column.
#' @export
#' @import dplyr
#' @import purrr
#'
generate_case_file_df <- function(...){
time_slices <- list(...)
        transform_casefile_protocol <- function(df) {
          casefile_df <- df %>%
                  tbl_df()
          # Define legal candidate actions, and function to ID illegal ones
          candidate_actions <- c("No_Management",
                                 "WC",
                                 "Fire_WC",
                                 "Grazing_WC",
                                 "SowingForbs_WC")
          filter_candidate_action <- function(x) ifelse(x %in% candidate_actions,yes = x,no = NA)
          replace_missing_code <- function(x) ifelse(is.na(x), "*", x)
          # Replace any illegal action in Management cols with NA, otherwise, keep.
          casefile_df <- casefile_df %>% mutate_at(.vars = vars(dplyr::contains("Management", ignore.case = FALSE)) , .funs = filter_candidate_action) %>% drop_na()
          # Replace missing code with *
          casefile_df <- casefile_df %>%
                  mutate_at(.vars = vars(dplyr::contains("Grassland", ignore.case = FALSE)) , .funs = replace_missing_code)
          # Remove management_unit col, add IDnum col:
          casefile_df <- casefile_df %>%
                  dplyr::select(-management_unit) %>%
                  dplyr::mutate(IDnum = c(1:n()))
          return(casefile_df)
        }

        if(length(time_slices) > 1){
                casefile_df <-
                        time_slices %>%
                        purrr::reduce(dplyr::left_join, by = "management_unit")
        } else{
                casefile_df <-
                        time_slices %>%
                        purrr::flatten_df(.)
        }

        casefile_df <- transform_casefile_protocol(casefile_df)

        return(casefile_df)
}