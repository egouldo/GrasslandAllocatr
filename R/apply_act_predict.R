#' Apply act_prediction function
#' @description helper function for simulating grassland condition under management
#' @details Applies act_predict and initialise_condition functions and records the outputs in a dataframe
#' @param strategies_df
#'
#' @return
#' @export
#' @import purrr
#' @import dplyr
apply_act_predict <- function(strategies_df){
        strategies_df <- strategies_df %>%
                dplyr::as_tibble() %>%
                dplyr::rename(action_set_number = value)
        strategies_df <- strategies_df %>%
                dplyr::mutate(condition_horizon = purrr::map(.x = action_set_number,
                                                             .f = act_predict,
                                                             nodes = management_nodes))
        return(strategies_df)
}