#' Extract active nodes using partial matches:
#' @param match_string The character string to search.
#' @param network Character string of the active target network's name
#' @param node_names Defaults to \code{FALSE} and returns the matched active Netica node. If \code{TRUE}, returns the names of the matched nodes. Note that matching is currently case sensitive.
#' @return Returns a character vector of the node names that match the searched string if \code{node_names = TRUE}, else returns a list of active netica
#'  nodes that match the searched string if \code{node_names = FALSE}.
#' @details Note that because this function returns a list when \code{node_names = FALSE}, this function can handle \code{match_string} vectors of length greater than 1, such that if you supply a multi-element vector, a list will be returned.
#' @export
#' @import stringr
get_node <- function(match_string = character, node_names = FALSE, network = grassland_bbn) {
        out <- vector(mode = "list", length = length(match_string))
        names(out) <- match_string
        if(length(match_string)>1){

                for(i in 1:length(match_string)){
                        pos <- which(stringr::str_detect(NetworkAllNodes(network),
                                                         match_string[[i]]))
                        out[i] <- if(node_names == FALSE){
                                RNetica::NetworkAllNodes(network)[pos]
                                } else(
                                names(RNetica::NetworkAllNodes(network)[pos])
                                )
                }

                return(out)

        } else{
                pos <- which(stringr::str_detect(NetworkAllNodes(network), match_string))
                if(node_names == FALSE){
                        return(RNetica::NetworkAllNodes(network)[pos])
                } else(
                        return(names(RNetica::NetworkAllNodes(network)[pos]))
                )
        }

}
