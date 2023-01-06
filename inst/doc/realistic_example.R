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
filename <- "mymodel.txt"
write_model(file.name = filename, literature_configuration = literature_configuration, print.model = F)
mcmc_output <- run_model(filename, data, run_param="test")

## ---- eval = FALSE------------------------------------------------------------
#  mcmc_output <- run_model(filename, data, run_param="normal", parallelize = T)

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
filename <- "mymodel_literature.txt"
write_model(file.name = filename, literature_configuration = literature_configuration, print.model = F)
mcmc_output <- run_model(filename, data, run_param="test")

## ---- eval = FALSE------------------------------------------------------------
#  mcmc_output <- run_model(filename, data, run_param=list(nb_iter=100000, nb_burnin=50000, nb_thin=50, nb_adapt=50000), parallelize = T)

## ---- eval = FALSE------------------------------------------------------------
#  plot_results(mcmc_output, data)

## ---- eval = FALSE------------------------------------------------------------
#  plot_results(mcmc_output, data, pred = "Pout")

## ---- eval = FALSE------------------------------------------------------------
#  plot_results(mcmc_output, data, pred = "Pout", save = TRUE, save_path = ".")

