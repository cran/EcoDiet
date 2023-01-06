## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
options(rmarkdown.html_vignette.check_title = FALSE)

## ---- eval=FALSE--------------------------------------------------------------
#  library(EcoDiet)
#  
#  example_stomach_data_path <- system.file("extdata", "example_stomach_data.csv",
#                                      package = "EcoDiet")
#  example_biotracer_data_path <- system.file("extdata", "example_biotracer_data.csv",
#                                      package = "EcoDiet")
#  
#  data <- preprocess_data(biotracer_data = read.csv(example_biotracer_data_path),
#                          trophic_discrimination_factor = c(0.8, 3.4),
#                          literature_configuration = FALSE,
#                          stomach_data = read.csv(example_stomach_data_path))
#  
#  filename <- "mymodel.txt"
#  write_model(file.name = filename, literature_configuration = literature_configuration, print.model = F)
#  mcmc_output <- run_model(filename, data, run_param="test")

## ---- eval=FALSE--------------------------------------------------------------
#  
#  mcmc_output <- run_model(filename, data, run_param=list(nb_iter=100000, nb_burnin=50000, nb_thin=50, nb_adapt=50000), parallelize = T)
#  

## ---- eval=FALSE--------------------------------------------------------------
#  
#  # Option 1: use the jagsUI object
#  mcmc_output_example$summary[,c("Rhat", "n.eff")]
#  
#  # Option 2: diagnose function
#  Gelman_diag <- diagnose_model(mcmc_output_example) # just display the Gelman-Rubin diagnostic
#  Gelman_diag
#  
#  # Option 3: diagnose function
#  Gelman_diag <- diagnose_model(mcmc_output_example, var.to.diag = "all", save = TRUE) # Display the Gelman-Rubin diagnostic and produce the plots
#  Gelman_diag
#  

## ---- eval = FALSE------------------------------------------------------------
#  mcmc_output <- run_model(filename, data, run_param="normal")
#  mcmc_output <- run_model(filename, data, run_param="long")
#  mcmc_output <- run_model(filename, data, run_param="very long")

