#' Extract active nodes using partial matches:
#' @param string_to_match The character string to search.
#' @param network Character string of the active target network's name
#' @param node_names Defaults to \code{FALSE} and returns the matched active Netica node. If \code{TRUE}, returns the names of the matched nodes. Note that matching is currently case sensitive.
#' @return Returns a character vector of the node names that match the searched string if \code{node_names = TRUE}, else returns a list of active netica
#'  nodes that match the searched string if \code{node_names = FALSE}.
#' @details Note that because this function returns a list when \code{node_names = FALSE}, this function can handle \code{string_to_match} vectors of length greater than 1, such that if you supply a multi-element vector, a list will be returned. Note that this function no longer supports partial matches at the moment due to an error with the function returning multiple concatenated matches when a partial match is found for more than one node.
#' @export
#' @import stringr
get_node <- function(string_to_match = character, node_names = FALSE, network = grassland_bbn) {
        out <- vector(mode = "list", length = length(string_to_match))
        names(out) <- string_to_match
        if(length(string_to_match)>1){

                for(i in 1:length(string_to_match)){
                        pos <- match(x = string_to_match[[i]], table = names(NetworkAllNodes(network)))
                        out[i] <- if(node_names == FALSE){
                                RNetica::NetworkAllNodes(network)[pos]
                                } else(
                                names(RNetica::NetworkAllNodes(network)[pos])
                                )
                }

                return(out)

        } else{
                pos <- which(stringr::str_detect(NetworkAllNodes(network), string_to_match))
                if(node_names == FALSE){
                        return(RNetica::NetworkAllNodes(network)[pos])
                } else(
                        return(names(RNetica::NetworkAllNodes(network)[pos]))
                )
        }

}
