#' Initialise condition nodes at t0
#'
#' @description helper function for simulating grassland condition under management
#' @param attribute_nodes The grassland condition attribute nodes to be initialised with values from monitoring data
#' @param unit the management unit to be simulated. This controls the iterative reading and predicting of findings in the netica function ReadFindings
#' @import RNetica
#' @return /code{beliefs_t0} the beliefs for Grassland Condition at t0
#' @export
#'
initialise_condition <- function(attribute_nodes, unit) {
        position <- ifelse(unit == 1, "FIRST", "NEXT")
        sites_findings_casestream <<- ReadFindings(nodes = attribute_nodes,
                                                   stream = sites_casestream,
                                                   pos = position,
                                                   add = FALSE)
        beliefs_t0 <- RNetica::NodeBeliefs(condition_nodes[[1]])
        return(beliefs_t0)
}