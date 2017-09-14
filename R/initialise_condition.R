#' Initialise condition nodes at t0
#' @description helper function for simulating grassland condition under management
#'
#' @param attribute_nodes
#' @param unit
#'
#' @return
#' @export
#'
#' @examples
initialise_condition <- function(attribute_nodes, unit) {
        position <- ifelse(unit == 1, "FIRST", "NEXT")
        sites_findings_casestream <<- ReadFindings(nodes = attribute_nodes,
                                                   stream = sites_casestream ,
                                                   pos = position,
                                                   add = FALSE)
        beliefs_t0 <- RNetica::NodeBeliefs(condition_nodes[[1]])
        return(beliefs_t0)
}