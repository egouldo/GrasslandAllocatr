#' Reports Grassland Condition at t0 for a casefile of sites.
#'
#' @param network_path a character string containing the file path to the Netica model to be used for simulation
#' @param sites_casefile a character string containing the file path to the casefile containing monitoring data for one or more grassland /code{sites}. Column names should include: /code{IDnum}, /code{IndigSpp_transect_t}, /code{WeedCover_t}, /code{BareGround_t}, /code{WeedDiversity_t}, /code{YearsSince_t}.
#'
#' @return A data frame with the columns management unit and Grassland Condition_t0
#' @export
#' @import RNetica
#' @import dplyr
#' @import purrr
#'
report_condition <- function(network_path = character, sites_casefile = character) {
        process_model <- ReadNetworks(paths = network_path)
        CompileNetwork(process_model)
        ClearAllErrors()

        condition_nodes <<- get_node(string_to_match = "Condition_t", network = process_model)
        condition_nodes <- condition_nodes %>% .[1]

        starting_condition_nodes <<- c("IndigSpp_transect_t", "WeedCover_t", "BareGround_t", "WeedDiversity_t")
        starting_condition_nodes <- starting_condition_nodes %>%
                sapply(., function(x) get_node(string_to_match = x, network = process_model)[1])

        sites_casestream <<- RNetica::CaseFileStream(sites_casefile)
        stopifnot(isCaseStreamOpen(sites_casestream))
        stopifnot(getCaseStreamPath(sites_casestream) == sites_casefile)

        # Create data_frame for capturing output
        simulations_df <- data_frame(management_unit = c(1:nrow(read.CaseFile(sites_casefile))),
                                     attr_nodes = list(starting_condition_nodes),
                                     condition_nodes = list(condition_nodes))

        simulations_df <- simulations_df %>%
                dplyr::mutate(GrasslandCondition_t0 =
                                      purrr::map2(.x = attr_nodes, .y = management_unit, .f = initialise_condition)) %>%
                dplyr::select(management_unit, GrasslandCondition_t0) %>%
                unnest(GrasslandCondition_t0) %>%
                group_by(management_unit) %>%
                dplyr::summarise(GrasslandCondition_t0 = last(GrasslandCondition_t0))
        return(simulations_df)
}