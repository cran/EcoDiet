## ---- results = 'hide', message = FALSE, warning = FALSE----------------------
library(EcoDiet)

example_stomach_data_path <- system.file("extdata", "example_stomach_data.csv",
                                    package = "EcoDiet")
example_biotracer_data_path <- system.file("extdata", "example_biotracer_data.csv",
                                    package = "EcoDiet")

data <- preprocess_data(biotracer_data = read.csv(example_biotracer_data_path),
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = FALSE,
                        stomach_data = read.csv(example_stomach_data_path))

model_string <- write_model(literature_configuration = FALSE)

mcmc_output <- run_model(textConnection(model_string), data)

## ---- eval = FALSE------------------------------------------------------------
#  mcmc_output <- run_model(textConnection(model_string), data, nb_adapt = 1e4, nb_iter = 1e7)

