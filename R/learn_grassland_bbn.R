#' Learn \code{grassland_bbn} with EM Learning algorithm
#' @param network An active \code{Netica BN} object, defaults to \code{grassland_bbn}
#' @param casefile_path A character string containing the path to the Netica casefile
#' @param first_iteration Logical, is this the first iteration of learning by casefile? defaults to \code{TRUE}.
#' @export
#' @import magrittr, RNetica, beepr
#' @details Note if \code{first_iteration} is set to \code{TRUE}, node experience for target nodes will be set to 1 for every state. Please see Netica or RNetica documentation for information on the EM Learning algorithm.
#'
learn_grassland_bbn <- function(network, casefile_path, first_iteration = TRUE) {
        # Get the network object (assume already loaded and compiled)
        grassland_bbn %>% RNetica::is.active() # return error to user if not
        grassland_bbn %>% RNetica::is.NetworkCompiled() # compile it if not

        # Select nodes for learning (get them from the casefile)
        cases <- RNetica::read.CaseFile(casefile_path)
        target_nodes <- colnames(cases)
        # Remove IDnum and any 'Management' nodes:
        target_nodes <- target_nodes[-1] %>% get_node() %>%
                base::Filter(function(x) !any(grepl("Management", x)), .)

        # Set Node Experience to 1 for each state of each node, before learning:
        if(first_iteration == TRUE){
                sapply(target_nodes, function(x) RNetica::NodeExperience(x)<-1)
        }
        RNetica::LearnCPTs(nodelist = target_nodes,caseStream = casefile_path,method = "EM")
        RNetica::ClearAllErrors()
        beepr::beep(2)
}