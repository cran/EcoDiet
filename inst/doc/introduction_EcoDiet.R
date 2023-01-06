## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(EcoDiet)

## ---- eval = FALSE------------------------------------------------------------
#  example_stomach_data <- read.csv("./data/my_stomach_data.csv")
#  example_biotracer_data <- read.csv("./data/my_biotracer_data.csv")

## -----------------------------------------------------------------------------
example_stomach_data <- read.csv(system.file("extdata", "example_stomach_data.csv",
                                    package = "EcoDiet"))
knitr::kable(example_stomach_data)

## -----------------------------------------------------------------------------
example_biotracer_data <- read.csv(system.file("extdata", "example_biotracer_data.csv",
                                    package = "EcoDiet"))
knitr::kable(example_biotracer_data)

## ---- eval = FALSE------------------------------------------------------------
#  trophic_discrimination_factor = c(0.8, 3.4)

## -----------------------------------------------------------------------------
literature_configuration <- FALSE

## -----------------------------------------------------------------------------
data <- preprocess_data(stomach_data = example_stomach_data,
                        biotracer_data = example_biotracer_data,
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = literature_configuration
                        )

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

## ---- fig1, fig.height = 4, fig.width = 6-------------------------------------
plot_data(biotracer_data = example_biotracer_data,
          stomach_data = example_stomach_data)

## ---- eval = FALSE------------------------------------------------------------
#  plot_data(biotracer_data = example_biotracer_data,
#            stomach_data = example_stomach_data,
#            save = TRUE, save_path = ".")

## ---- fig.height = 4, fig.width = 6-------------------------------------------
plot_prior(data, literature_configuration)

## ---- fig.height = 4, fig.width = 6-------------------------------------------
plot_prior(data, literature_configuration, pred = "huge")

## ---- fig.height = 4, fig.width = 6-------------------------------------------
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
filename <- "mymodel.txt"
write_model(file.name = filename, literature_configuration = literature_configuration, print.model = F)

## ---- eval = TRUE-------------------------------------------------------------
mcmc_output <- run_model(filename, data, run_param = "test")

## ---- eval = FALSE------------------------------------------------------------
#  mcmc_output <- run_model(filename, data, run_param=list(nb_iter=10000, nb_burnin=5000, nb_thin=5))
#  mcmc_output <- run_model(filename, data, run_param=list(nb_iter=50000, nb_burnin=25000, nb_thin=25))
#  mcmc_output <- run_model(filename, data, run_param=list(nb_iter=100000, nb_burnin=50000, nb_thin=50))
#  
#  mcmc_output_example <- run_model(filename, data, run_param=list(nb_iter=50000, nb_burnin=25000, nb_thin=25))

## ---- eval = FALSE------------------------------------------------------------
#  save(mcmc_output_example, file = "./data/mcmc_output_example.rda")

## -----------------------------------------------------------------------------
Gelman_model <- diagnose_model(mcmc_output_example)
print(Gelman_model)

## ---- eval = FALSE------------------------------------------------------------
#  diagnose_model(mcmc_output_example, var.to.diag = "all", save = TRUE)

## -----------------------------------------------------------------------------
str(mcmc_output_example)

## ---- fig.height = 4, fig.width = 6-------------------------------------------
plot_results(mcmc_output_example, data)

## -----------------------------------------------------------------------------
print(mcmc_output_example$summary[,"mean"])

## ---- fig.height = 4, fig.width = 6-------------------------------------------
plot_results(mcmc_output_example, data, pred = "huge")

## ---- fig.height = 4, fig.width = 6-------------------------------------------
plot_results(mcmc_output_example, data, pred = "large")

## ---- eval=FALSE--------------------------------------------------------------
#  mcmc_output_delta <- run_model(filename, data,
#            variables_to_save = c("delta"),
#            run_param = "test")

## ---- eval=FALSE--------------------------------------------------------------
#  print(mcmc_output_delta$summary[,"mean"])

