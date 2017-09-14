#' Predict Grassland Condition for one or more sites under one or more /code{management_strategies}
#' @description Enters Findings from monitoring data for 1 or more sites, and records Grassland Condition at /code{t0}. The function then applies a selection of management strategies and predicts response in grassland condition into at the final time_horizon for each scenario. This function works on a single model.
#'
#' @param network_path a character string containing the file path to the Netica model to be used for simulation
#' @param strategies_casefile a character string containing the file path to the casefile containing the /code{management_strategies}. Column names must include: /code{IDnum} and at least one of /code{Management_t} through to /code{Management_t4}.
#' @param sites_casefile a character string containing the file path to the casefile containing monitoring data for one or more grassland /code{sites}. Column names should include: /code{IDnum}, /code{IndigSpp_transect_t}, /code{WeedCover_t}, /code{BareGround_t}, /code{WeedDiversity_t}, /code{YearsSince_t}.
#'
#' @return A nested /code{data_frame} with the variables /code{management_unit}, /code{attr_nodes}, /code{condition_nodes},  /code{condition_horizon}, /code{GrasslandCondition_t0}, where /code{condition_horizon} is equivalent to the final time_horizon to be predicted to, as given by the number of management actions in the /code{management_strategies} casefile.
#' @export
#' @import RNetica
#' @import dplyr
#' @import purrr
#'
#' @details Note that a /code{management_strategy} consists of one or more management actions defined as node states for each management node in the model. These actions are applied sequentially through time.
predict_grassland_condition <- function(network_path = character, strategies_casefile = character,sites_casefile = character) {
        # Filepath checks
        if(!file.exists(network_path)){
                stop(sprintf("Filepath %s does not exist",network_path))
        }
        if(!file.exists(strategies_casefile)){
                stop(sprintf("Filepath %s does not exist",strategies_casefile))
        }
        if(!file.exists(sites_casefile)){
                stop(sprintf("Filepath %s does not exist",sites_casefile))
        }

        ## Initialise Simulation
        time_horizon <- ncol(read.CaseFile(strategies_casefile)) - 1 #remove IDnum col
        time_slice <- time_horizon + 1 # to align intended time_horizon with the time_slices as indexed by R

        # Initialise network and input, and output nodes
        process_model <- ReadNetworks(paths = network_path)
        CompileNetwork(process_model)
        ClearAllErrors()

        management_nodes <- get_node(string_to_match = "Management_t", network = process_model)
        management_nodes <- management_nodes %>% .[1:time_slice]
        lapply(management_nodes, `NodeSets<-`, value = "management" )

        condition_nodes <- get_node(string_to_match = "Condition_t", network = process_model)
        condition_nodes <- condition_nodes %>% .[1:time_slice]
        lapply(condition_nodes, `NodeSets<-`, value = "condition" )

        starting_condition_nodes <- c("IndigSpp_transect_t", "WeedCover_t", "BareGround_t", "WeedDiversity_t")
        starting_condition_nodes <- starting_condition_nodes %>%
                sapply(., function(x) get_node(string_to_match = x, network = process_model)[1])

        ## load casefiles and open memory streams
        strategies_casestream <- CaseFileStream(strategies_casefile)
        stopifnot(isCaseStreamOpen(strategies_casestream))
        stopifnot(getCaseStreamPath(strategies_casestream) == strategies_casefile)

        sites_casestream <- CaseFileStream(sites_casefile)
        stopifnot(isCaseStreamOpen(sites_casestream))
        stopifnot(getCaseStreamPath(sites_casestream) == sites_casefile)

        ## Define functions for:
        # initialising condition at t0 and recording condition at t0
        initialise_condition <- function(attribute_nodes, unit) {
                position <- ifelse(unit == 1, "FIRST", "NEXT")
                sites_findings_casestream <<- ReadFindings(nodes = attribute_nodes,
                                                           stream = sites_casestream ,
                                                           pos = position,
                                                           add = FALSE)
                beliefs_t0 <- RNetica::NodeBeliefs(condition_nodes[[1]])
                return(beliefs_t0)
        }
        # Applying management actions (as findings), recording condition at t0
        act_predict <- function(action_set, nodes){
                position <- ifelse(action_set == 1, "FIRST", "NEXT")
                management_findings_casestream <<- ReadFindings(nodes,
                                                                stream = strategies_casestream,
                                                                pos = position,
                                                                add = FALSE)
                beliefs_time_horizon <- RNetica::NodeBeliefs(condition_nodes[[time_slice]])
                return(beliefs_time_horizon)
        }
        # Applying the above functions and recording outputs in a dataframe
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

        ## Run the simulation
        # Create data_frame for capturing output
        simulations_df <- data_frame(management_unit = c(1:nrow(read.CaseFile(sites_casefile))),
                                     attr_nodes = list(starting_condition_nodes),
                                     condition_nodes = list(condition_nodes),
                                     condition_horizon = list(action_set_number = c(1:nrow(read.CaseFile(strategies_casefile)))))
        ## apply all functions to the output data_frame
        simulations_df <- simulations_df %>%
                dplyr::mutate(GrasslandCondition_t0 =
                                      purrr::map2(.x = attr_nodes, .y = management_unit, .f = initialise_condition),
                              condition_horizon = purrr::map(.x = condition_horizon, .f = dplyr::as_tibble),
                              condition_horizon = purrr::map(.x = condition_horizon,
                                                             .f = apply_act_predict)) %>%
                dplyr::mutate(condition_horizon =
                                      purrr::map(.x = condition_horizon,
                                                 .f = ~ dplyr::rename_(.data = .x, .dots = setNames("condition_horizon", paste0("GrasslandCondition_t", time_horizon))))) %>%
                dplyr::rename_(.dots = setNames("condition_horizon", paste0("GrasslandCondition_t", time_horizon)))

        return(simulations_df)
}











