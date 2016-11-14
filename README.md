# GrasslandAllocatr: *An R package for allocating a schedule of management actions among a suite of grasslands.*

This package is based on the work of Paul Rees and Elise Gould, in partial fulfilment of their Master of Science degreees at the School of Botany (now School of BioSciences), University of Melbourne. Please note that this package is still in active development.

The package is built around two models:

1. `GrasslandBBN`: A Bayesian Belief Network model predicting condition for a single grassland in response to management at annual time-steps over a period of 5 years. The original model was built by Paul Rees, and has been parameterised with data collectd by both Paul Rees and Elise Gould.
2. `GrasslandAllocatr`: A decision model for allocating actions through time among a suite of grasslands. This model uses the predictions of the `GrasslandBBN` and a choice of algorithm and performance metrics for optimally allocating effort under a limited budget. This model is the work of Elise Gould.

# About the data:

Field data for learning the GrasslandBBN parameters is derived from two separate field campaigns, each with two sampling seasons occurring in spring of two consecutive years.

1. 2011 and 2012
2. 2014 and 2015

Field sampling was undertaken on grasslands of the Victorian Volcanic Plains in the west of Greater Melbourne.

### A note on data de-identification

Note that field data has been de-identified from both the managing agency and its location in order to protect the location of field sites. Please contact the creator of this repository for further information, should you require site location details.

- Field data is stored in a main file of the filename format: `field_data_raw_<YEAR>.csv`

Metadata pertaining to information about field site locations and management is stored in the following files:

- Masterfile: `./data/field_site_locations_managers_<YEAR>.csv` - *Not present* in this repository, but split into the following files, which *are* present in this repository:

1. Contains the latitude and longitude of all transects at the 0m mark on the quadrat. `./data/field_site_locations_<YEAR>.csv`
2. A table of management actions, and burn histories at each transect: `./data/field_site_management_<YEAR>.csv` Links to `field_data_raw_<YEAR>.csv` by `transect_number`, links to `field_species_lookup_table_<YEAR>.csv` by `species`.
3. A table of all species encountered during each year's field sampling period and their origin and growth form type: `./data/field_species_lookup_table_<YEAR>.csv` Links to `field_data_raw_<YEAR>.csv` by `species`.



<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.


[![Build Status](https://travis-ci.org/egouldo/GrasslandAllocatr.png)](https://travis-ci.org/egouldo/GrasslandAllocatr)
