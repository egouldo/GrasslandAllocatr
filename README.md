# GrasslandAllocatr: *An R package for allocating a schedule of management actions among a suite of grasslands.*

This package is based on the work of Paul Rees and Elise Gould, in partial fulfilment of their Master of Science degreees at the School of Botany (now School of BioSciences), University of Melbourne. Please note that this package is still in active development.

The package is built around two models:

1. `GrasslandBBN`: A Bayesian Belief Network model predicting condition for a single grassland in response to management at annual time-steps over a period of 5 years. The original model was built by Paul Rees, and has been parameterised with data collectd by both Paul Rees and Elise Gould.
2. `GrasslandAllocatr`: A decision model for allocating actions through time among a suite of grasslands. This model uses the predictions of the `GrasslandBBN` and a choice of algorithm and performance metrics for optimally allocating effort under a limited budget. This model is the work of Elise Gould.

# To install this package (for using on your own data):

Install the package using `devtools`: `devtools::install_github("egouldo/GrasslandAllocatr")`

If you don't have devtools installed, install it like so: `install.packages("devtools")`

# To reproduce the analysis using Paul Rees' and Elise Gould's data:

Download and build the package:

1. Clone or download this github repository.
2. Open the `GrasslandAllocatr.Rproj` file in Rstudi
3. From the menu: Build > Build and Reload

Install reproduce using the `remake` package [remake on Github](https://github.com/richfitz/remake):

1. Install remake: `devtools::install_github("richfitz/remake")`
2. Install remake dependencies: `install.packages(c("R6", "yaml", "digest", "crayon", "optparse"))`
3. One more dependency: `devtools::install_github("richfitz/storr")`

### Licensing and Build Status:

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.


[![Build Status](https://travis-ci.org/egouldo/GrasslandAllocatr.png)](https://travis-ci.org/egouldo/GrasslandAllocatr)

For more detailed information about the data contained in this repository, and about the data analysis / model building pipelines in this software, please see the wiki.
