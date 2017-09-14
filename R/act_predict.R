#' Apply management actions as Netica Findings
#' @description helper function for simulatin grassland condition under management
#' @param action_set
#' @param nodes
#'
#' @return
#' @export
act_predict <- function(action_set, nodes){
        position <- ifelse(action_set == 1, "FIRST", "NEXT")
        management_findings_casestream <<- ReadFindings(nodes,
                                                        stream = strategies_casestream,
                                                        pos = position,
                                                        add = FALSE)
        beliefs_time_horizon <- RNetica::NodeBeliefs(condition_nodes[[time_slice]])
        return(beliefs_time_horizon)
}