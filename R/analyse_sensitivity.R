#' Run sensitivity analysis for a set of target nodes in a given timeslice
#'
#' @param network an active /code{NeticaBN} object
#' @param year The relevant time slice for which the sensitivity analysis will be run
#'
#' @return df_mutual_info A /code{tibble} containing the variables: node_name /code{<chr>}, mutual_info /code{<dbl>}, nodelist_node_name /code{<chr>}
#' @export
#'
analyse_sensitivity <- function(network, year = c(1:5)) {
        # generate target nodes for a given model (as df)
        nodeset <- paste0("tn", year)
        df_target_nodes <-
                NetworkNodesInSet(network, nodeset) %>%
                data_frame(node_name = names(.),
                           target_nodes = .) %>%
                dplyr::filter(node_name != paste0("Year", year) & node_name != paste0("YearsSince_t", year)) %>%
                dplyr::mutate(model = list(network))
        df_mutual_info <- df_target_nodes %>%
                dplyr::mutate(mutual_info = purrr::map2(.x = target_nodes, .y = model, .f = compute_mutual_info, year = year)) %>%
                unnest(mutual_info) %>%
                dplyr::filter(node_name != nodelist_node_name)
        return(df_mutual_info)
}