## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
realistic_stomach_data_path <- system.file("extdata", "realistic_stomach_data.csv",
                                           package = "EcoDiet")
realistic_stomach_data <- read.csv(realistic_stomach_data_path)
knitr::kable(realistic_stomach_data)

## -----------------------------------------------------------------------------
realistic_biotracer_data_path <- system.file("extdata", "realistic_biotracer_data.csv",
                                           package = "EcoDiet")
realistic_biotracer_data <- read.csv(realistic_biotracer_data_path)
knitr::kable(realistic_biotracer_data[c(1:3, 31:33, 61:63), ])

## ---- fig.height = 5, fig.width = 8-------------------------------------------
library(EcoDiet)

plot_data(biotracer_data = realistic_biotracer_data,
          stomach_data = realistic_stomach_data)

## -----------------------------------------------------------------------------
literature_configuration <- FALSE

data <- preprocess_data(biotracer_data = realistic_biotracer_data,
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = literature_configuration,
                        stomach_data = realistic_stomach_data)

## ---- fig.height = 5, fig.width = 8-------------------------------------------
plot_prior(data, literature_configuration)

## ---- fig.height = 5, fig.width = 8-------------------------------------------
plot_prior(data, literature_configuration, pred = "Pout")

## -----------------------------------------------------------------------------
model_string <- write_model(literature_configuration = literature_configuration)

mcmc_output <- run_model(textConnection(model_string), data, nb_adapt = 1e1, nb_iter = 1e2)

## ---- eval = FALSE------------------------------------------------------------
#  mcmc_output <- run_model(textConnection(model_string), data, nb_adapt = 1e3, nb_iter = 1e5)

## ---- eval = FALSE------------------------------------------------------------
#  plot_results(mcmc_output, data)

## ---- eval = FALSE------------------------------------------------------------
#  plot_results(mcmc_output, data, pred = "Pout")

## ---- eval = FALSE------------------------------------------------------------
#  plot_results(mcmc_output, data, pred = "Pout",
#               variable = "PI", prey = c("Bivalves", "Worms"))

## -----------------------------------------------------------------------------
literature_configuration <- TRUE

## -----------------------------------------------------------------------------
realistic_literature_diets_path <- system.file("extdata", "realistic_literature_diets.csv",
                                               package = "EcoDiet")
realistic_literature_diets <- read.csv(realistic_literature_diets_path)
knitr::kable(realistic_literature_diets)

## -----------------------------------------------------------------------------
data <- preprocess_data(biotracer_data = realistic_biotracer_data,
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = literature_configuration,
                        stomach_data = realistic_stomach_data,
                        literature_diets = realistic_literature_diets,
                        nb_literature = 12,
                        literature_slope = 0.5)

## ---- fig.height = 5, fig.width = 8-------------------------------------------
plot_prior(data, literature_configuration)

## ---- fig.height = 5, fig.width = 8-------------------------------------------
plot_prior(data, literature_configuration, pred = "Pout")

## -----------------------------------------------------------------------------
model_string <- write_model(literature_configuration = literature_configuration)

mcmc_output <- run_model(textConnection(model_string), data, nb_adapt = 1e1, nb_iter = 1e2)

## ---- eval = FALSE------------------------------------------------------------
#  mcmc_output <- run_model(textConnection(model_string), data, nb_adapt = 1e3, nb_iter = 1e5)

## ---- eval = FALSE------------------------------------------------------------
#  plot_results(mcmc_output, data)

## ---- eval = FALSE------------------------------------------------------------
#  plot_results(mcmc_output, data, pred = "Pout")

## ---- eval = FALSE------------------------------------------------------------
#  plot_results(mcmc_output, data, pred = "Pout", save = TRUE, save_path = ".")

