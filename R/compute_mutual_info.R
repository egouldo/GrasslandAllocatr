#' Compute Mutual Information
#'
#' @param target_node An active /code{NeticaNode} object that is the target of inference (i.e., we want to find the influence of other nodes on this node).
#' @param network an active /code{NeticaBN} object
#' @param year The relevant time slice for which the sensitivity analysis will be run
#' @details Mutual Information is computed for the target node, and calculates the mutual information of vegetation measure and management nodes in the same time slice as the target node, as well nodes in preceding time slices.
#' @return mutual_info_df A /code{tibble} with the variables /code{mutual_info} and /code{nodelist_node_name}
#' @export
#'
compute_mutual_info <- function(target_node, network, year) {
        # generate nodelist (of parent nodes)
        nodesets <- paste0("tn") %>% paste0(c("", paste(seq(year) %>% .[-length(.)])))
        veg_attribute_nodelist <- nodesets %>%
                map(., .f = ~NetworkNodesInSet(net = network,setname = .x) %>% .[-1]) %>%
                reduce(.f = append)
        mngmnt_nodelist <-
                NetworkNodesInSet(net = network, "mngmnt") %>% rev(.) %>% .[seq(year)]
        nodelist <- append(veg_attribute_nodelist, mngmnt_nodelist)
        # calculate mutual info
        mutual_info_df <- MutualInfo(target = target_node, nodelist = nodelist) %>%
                data_frame(mutual_info = ., nodelist_node_name = names(.))
        return(mutual_info_df)
}