# GrasslandAllocatr

An R package for allocating a schedule of management actions among a suite of grasslands.

### A note on data de-identification

Note that field data has been de-identified from both the managing agency and its location in order to protect the location of field sites. Please contact the creator of this repository for further information, should you require identification of each site's location.

- Field data is stored in a main file of the filename format: `field_data_raw_<YEAR>.csv`

Metadata pertaining to information about field site locations and management is stored in the following files:

- Masterfile: `./data/field_site_locations_managers_<YEAR>.csv` - *Not present* in this repository, but split into the following files, which *are* present in this repository:

1. Contains the latitude and longitude of all transects at the 0m mark on the quadrat. `./data/field_site_locations_<YEAR>.csv`
2. A table of management actions, and burn histories at each transect: `./data/field_site_management_<YEAR>.csv` Links to `field_data_raw_<YEAR>.csv` by `transect_number`, links to `field_species_lookup_table_<YEAR>.csv` by `species`.
3. A table of all species encountered during each year's field sampling period and their origin and growth form type: `./data/field_species_lookup_table_<YEAR>.csv` Links to `field_data_raw_<YEAR>.csv` by `species`.

