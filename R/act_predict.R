#' Apply management actions as Netica Findings
#' @description helper function for simulatin grassland condition under management
#' @param action_set A series of actions through time
#' @param nodes The nodes for which findings will be entered
#' @import RNetica
#'
#' @return The beliefs at the end of the specified /code{time_horizon}
#' @export
act_predict <- function(action_set, nodes, time_slice){
        position <- ifelse(action_set == 1, "FIRST", "NEXT")
        management_findings_casestream <<- ReadFindings(nodes,
                                                        stream = strategies_casestream,
                                                        pos = position,
                                                        add = FALSE)
        beliefs_time_horizon <- RNetica::NodeBeliefs(condition_nodes[[time_slice]])
        return(beliefs_time_horizon)
}