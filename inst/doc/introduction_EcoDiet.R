## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(EcoDiet)

## ---- eval = FALSE------------------------------------------------------------
#  example_stomach_data <- read.csv("./data/my_stomach_data.csv", sep = ";")
#  example_biotracer_data <- read.csv("./data/my_biotracer_data.csv", sep = ";")

## -----------------------------------------------------------------------------
example_stomach_data_path <- system.file("extdata", "example_stomach_data.csv",
                                    package = "EcoDiet")
example_stomach_data <- read.csv(example_stomach_data_path)
knitr::kable(example_stomach_data)

## -----------------------------------------------------------------------------
example_biotracer_data_path <- system.file("extdata", "example_biotracer_data.csv",
                                    package = "EcoDiet")
example_biotracer_data <- read.csv(example_biotracer_data_path)
knitr::kable(example_biotracer_data)

## ---- eval = FALSE------------------------------------------------------------
#  trophic_discrimination_factor = c(0.8, 3.4)

## -----------------------------------------------------------------------------
literature_configuration <- FALSE

## -----------------------------------------------------------------------------
data <- preprocess_data(biotracer_data = example_biotracer_data,
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = literature_configuration,
                        stomach_data = example_stomach_data)

## -----------------------------------------------------------------------------
data <- preprocess_data(biotracer_data = example_biotracer_data,
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = literature_configuration,
                        stomach_data = example_stomach_data,
                        rescale_stomach = TRUE)

## -----------------------------------------------------------------------------
topology <- 1 * (data$o > 0)
print(topology)

## -----------------------------------------------------------------------------
topology["small", "huge"] <- 1
print(topology)

## -----------------------------------------------------------------------------
data <- preprocess_data(biotracer_data = example_biotracer_data,
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = literature_configuration,
                        topology = topology,
                        stomach_data = example_stomach_data)

## -----------------------------------------------------------------------------
literature_configuration <- TRUE

## -----------------------------------------------------------------------------
example_literature_diets_path <- system.file("extdata", "example_literature_diets.csv",
                                    package = "EcoDiet")
example_literature_diets <- read.csv(example_literature_diets_path)
knitr::kable(example_literature_diets)

## -----------------------------------------------------------------------------
nb_literature = 10

## -----------------------------------------------------------------------------
literature_slope = 0.5

## -----------------------------------------------------------------------------
data <- preprocess_data(biotracer_data = example_biotracer_data,
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = literature_configuration,
                        stomach_data = example_stomach_data,
                        literature_diets = example_literature_diets,
                        nb_literature = 10,
                        literature_slope = 0.5)

## -----------------------------------------------------------------------------
data <- preprocess_data(biotracer_data = example_biotracer_data,
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = literature_configuration,
                        stomach_data = example_stomach_data,
                        rescale_stomach = TRUE,
                        literature_diets = example_literature_diets,
                        nb_literature = 10,
                        literature_slope = 0.5)

## -----------------------------------------------------------------------------
topology <- 1 * ((data$o > 0) | (data$alpha_lit > 0))
print(topology)

## -----------------------------------------------------------------------------
topology["small", "huge"] <- 1
print(topology)

## -----------------------------------------------------------------------------
data <- preprocess_data(biotracer_data = example_biotracer_data,
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = literature_configuration,
                        topology = topology,
                        stomach_data = example_stomach_data,
                        literature_diets = example_literature_diets,
                        nb_literature = 10,
                        literature_slope = 0.5)

## ---- fig1, fig.height = 4, fig.width = 6, fig.align = "center"---------------
plot_data(biotracer_data = example_biotracer_data,
          stomach_data = example_stomach_data)

## ---- eval = FALSE------------------------------------------------------------
#  plot_data(biotracer_data = example_biotracer_data,
#            stomach_data = example_stomach_data,
#            save = TRUE, save_path = ".")

## ---- fig.height = 4, fig.width = 6, fig.align = "center"---------------------
plot_prior(data, literature_configuration)

## ---- fig.height = 4, fig.width = 6, fig.align = "center"---------------------
plot_prior(data, literature_configuration, pred = "huge")

## ---- fig.height = 4, fig.width = 6, fig.align = "center"---------------------
data <- preprocess_data(biotracer_data = example_biotracer_data,
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = literature_configuration,
                        topology = topology,
                        stomach_data = example_stomach_data,
                        literature_diets = example_literature_diets,
                        nb_literature = 2,
                        literature_slope = 0.5)

plot_prior(data, literature_configuration, pred = "huge", variable = "eta")

## -----------------------------------------------------------------------------
model_string <- write_model(literature_configuration = literature_configuration)

## ---- eval = FALSE------------------------------------------------------------
#  cat(model_string)

## -----------------------------------------------------------------------------
mcmc_output <- run_model(textConnection(model_string), data, nb_adapt = 1e1, nb_iter = 1e2)

## ---- eval = FALSE------------------------------------------------------------
#  mcmc_output <- run_model(textConnection(model_string), data, nb_adapt = 1e2, nb_iter = 1e3)
#  mcmc_output <- run_model(textConnection(model_string), data, nb_adapt = 1e3, nb_iter = 1e4)
#  mcmc_output <- run_model(textConnection(model_string), data, nb_adapt = 1e3, nb_iter = 1e5)
#  mcmc_output_example <- run_model(textConnection(model_string), data,
#                                   nb_adapt = 1e3, nb_iter = 1e6)
#  
#  save(mcmc_output_example, file = "./data/mcmc_output_example.rda")

## ---- fig.height = 4, fig.width = 6, fig.align = "center"---------------------
plot_results(mcmc_output_example, data)

## -----------------------------------------------------------------------------
print(colMeans(mcmc_output_example))

## ---- fig.height = 4, fig.width = 6, fig.align = "center"---------------------
plot_results(mcmc_output_example, data, pred = "huge")

## ---- fig.height = 4, fig.width = 6, fig.align = "center"---------------------
plot_results(mcmc_output_example, data, pred = "large")

## ---- fig.height = 4, fig.width = 6, fig.align = "center"---------------------
len <- dim(mcmc_output_example)[2]
mcmc_output2 <- mcmc_output_example
mcmc_output2[, 1:(len/2)] <- ifelse(mcmc_output_example[, 1:(len/2)] < 0.03 |
                                      mcmc_output_example[, 1:(len/2)] > 0.97,
                                    NA, mcmc_output_example[, 1:(len/2)])

plot_results(mcmc_output2, data, variable = "PI", pred = "large", prey = c("medium", "small"))

## -----------------------------------------------------------------------------
quantiles <- apply(mcmc_output_example, 2, function(X) quantile(X, probs = c(0.05, 0.5, 0.95)))
quantiles <- signif(quantiles, digits = 2)
knitr::kable(quantiles)

## -----------------------------------------------------------------------------
mcmc_output <- run_model(textConnection(model_string), data, 
                         variables_to_save = c("delta"),
                         nb_adapt = 1e1, nb_iter = 1e2)

## -----------------------------------------------------------------------------
print(colMeans(mcmc_output))

