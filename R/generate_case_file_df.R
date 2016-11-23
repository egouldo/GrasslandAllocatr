#' Generate Netica Case File as a \code{data_frame}
#'
#' @param field_data_by_mu Field data that has been summarised by management unit. Must contain the column \code{management_unit}.
#'
#' @return casefile_df A dataframe of the same dimensions as \code{field_data_by_mu}, but with the \code{management_unit} column removed and a new \code{IDnum} column.
#' @export
#' @import dplyr
#'
generate_case_file_df <- function(field_data_by_mu){
        casefile_df <- field_data_by_mu %>%
                tbl_df() %>%
                dplyr::select(-management_unit) %>%
                dplyr::mutate(IDnum = c(1:n()))
        return(casefile_df)
}