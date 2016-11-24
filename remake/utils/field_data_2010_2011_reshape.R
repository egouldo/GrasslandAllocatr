reshape_pauls_data_by_sample_year <- function(model_year, file_path, data_year){
        field_data_by_transect <- data.table::fread(file_path) %>%
                tbl_df() %>%
                filter(year == data_year)
        field_data_by_management_unit <-
                field_data_by_transect %>%
                dplyr::rename(management_unit = transect_number) %>%
                dplyr::select(-year, -management, -NG_mean)
        field_data_by_management_unit <-
                left_join(field_data_by_management_unit %>%
                                  dplyr::mutate(Grassland_Condition = "*") %>%
                                  dplyr::select(-contains("mean"), -contains("sd")),
                          field_data_by_management_unit %>%
                                  dplyr::select(contains("mean"), management_unit)) %>%
                dplyr::rename(E_pc = E_mean, BG_pc = BG_mean)
        # Rename variable names to node names
        year_char <- ifelse(model_year == 0, "", as.character(model_year))
        field_data_by_management_unit %<>%
                tidyr::gather(variable, value, -management_unit) %>%
                dplyr::mutate(variable =
                                      ifelse(variable == "BG_pc",
                                             "BareGround",
                                             ifelse(variable == "E_pc",
                                                    "WeedCover",
                                                    ifelse(variable ==
                                                                   "E_diversity",
                                                           "WeedDiversity",
                                                           ifelse(variable == "years_since",
                                                                  "YearsSince", ifelse(
                                                                          variable == "NF_diversity", "IndigSpp_transect", "Grassland_Condition")))))) %>%
                dplyr::mutate(time = paste0("t", year_char)) %>%
                tidyr::unite(variable, variable, time) %>%
                tidyr::spread(variable, value)
        # Join original data back to field_data_by_management_unit,
        # excluding transect_number and measure variables
        # and collapsing management units with multiple entries (transects)
        # into single entries (1 summarised value per management unit)
        field_data_by_management_unit %<>%
                dplyr::rename(transect_number = management_unit) %>%
                dplyr::left_join(.,{
                        field_data_by_transect %>%
                                dplyr::select(transect_number,
                                              management,
                                              years_since) %>%
                                dplyr::rename(Management = management, YearsSince = years_since) %>%
                                tidyr::gather(variable, value, -transect_number) %>%
                                dplyr::mutate(year = ifelse(variable == "Management", model_year - 1, model_year), year = as.character(year),
                                              year = ifelse(year == 0, "", year),
                                              time = paste0("t", year)) %>% dplyr::select(-year) %>% tidyr::unite(variable, variable, time) %>% dplyr::filter(variable != "Management_t-1") %>%
                                tidyr::spread(variable, value)})

        field_data_by_management_unit %<>% rename(management_unit = transect_number)
        return(field_data_by_management_unit)
}

reshape_pauls_data_all_years <- function(file_path){

        # Process and join both year's worth of data into one data_frame
        casefile_df <-
                left_join(
                        reshape_pauls_data_by_sample_year(model_year = 0,
                                                          file_path = file_path,
                                                          data_year = 2010),

                        reshape_pauls_data_by_sample_year(model_year = 1,
                                                          file_path = file_path,
                                                          data_year = 2011))
        return(casefile_df)
}







