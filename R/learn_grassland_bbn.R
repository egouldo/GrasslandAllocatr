#' Learn \code{grassland_bbn} with EM Learning algorithm
#' @param path Filepath to a grassland_bbn Netica network
#' @param casefile_path A character string containing the path to the Netica casefile
#' @param first_iteration Logical, is this the first iteration of learning by casefile? defaults to \code{TRUE}.
#' @return grassland_bbn The R object pointer to the NeticaAPI network
#' @export
#' @details Note if \code{first_iteration} is set to \code{TRUE}, node experience for target nodes will be set to 1 for every state. Please see Netica or RNetica documentation for information on the EM Learning algorithm.
#'
learn_grassland_bbn <- function(path, casefile_path, first_iteration = TRUE, save_path) {
        #RNetica::StopNetica()
        #load_Netica_LicenseKey()

        grassland_bbn <<- load_compile_grassland_bbn(path)
        ClearAllErrors()

        # Select nodes for learning (get them from the casefile)
        cases <- RNetica::read.CaseFile(casefile_path)
        cat("Casefile from path ", casefile_path, ":", sep = "")
        print(cases)
        target_nodes <- colnames(cases)
        cat("Nodes to be updated:")
        target_nodes[-1] %>%
                base::Filter(function(x) !any(grepl("Management", x)), .) %>%
                base::Filter(function(x) !any(grepl("IDnum", x)), .) %>%
                print()
        # Remove IDnum and any 'Management' nodes:
        target_nodes <- target_nodes[-1] %>%
                get_node(string_to_match = .,
                         node_names = FALSE,
                         network = grassland_bbn) %>%
                base::Filter(function(x) !any(grepl("Management", x)), .) %>%
                base::Filter(function(x) !any(grepl("IDnum", x)), .)

        # Set Node Experience to 1 for each state of each node, before learning:
        if(first_iteration == TRUE) sapply(target_nodes, function(x) RNetica::NodeExperience(x)<-1)

        casefile_stream <- CaseFileStream(casefile_path)
        RNetica::LearnCPTs(nodelist = target_nodes,
                           caseStream = casefile_stream,
                           method = "EM")
        CloseCaseStream(casefile_stream)
        RNetica::ClearAllErrors()
        RNetica::WriteNetworks(nets = grassland_bbn,paths = save_path)
}