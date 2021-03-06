#' Compute the Gelman-Rubin diagnostic for each variable, and
#' print a convergence problem message if at least one is > 1.1
#' 
#' @param mcmc_output the mcmc.list outpur by the coda.samples function
#' 
#' @keywords internal
#' @noRd

print_convergence_diagnostic <- function(mcmc_output){
  
  gelman <- coda::gelman.diag(mcmc_output, multivariate = FALSE)$psrf

  # We keep only the point estimates of the psrf
  gelman <- gelman[, 1] 
  variable_number <- length(gelman)
  
  # The NAs are for the variables that were always equal to 0 or 1,
  # and we consider that these variables have converged by default.
  gelman <- gelman[which(!is.nan(gelman))] 
  variable_number_over_1.1 <- length(gelman[which(gelman > 1.1)])
  
  if (variable_number_over_1.1 > 0){
    message("\n  /!\\ CONVERGENCE PROBLEM /!\\")
    message("Out of the ", variable_number,  " variables, ",
            variable_number_over_1.1, " variables have a Gelman-Rubin statistic > 1.1.")
    message("You should increase the number of iterations of your model with the `nb_iter` argument.\n")
  }
  
}


#' Run the EcoDiet model
#' 
#' @description
#' 
#' This function runs the EcoDiet model using a Markov chain Monte Carlo approximation 
#' through the 'rjags' package to provide an approximated distribution for the variables of interest.
#' 
#' Depending on the \code{nb_iter} and \code{nb_adapt} entered, this function may take hours, or even days 
#' to run. We advise you to first test whether your model is compiling properly with the by-default parameters,
#' as this should take 1-2 min to run depending on your data size.
#' 
#' A message is printed if the model has not converged in the end (if the Gelman-Rubin diagnostic
#' of at least one variable is > 1.1). Other messages or notes may also be printed by the 'rjags' package.
#' 
#' You need to have run the \code{preprocess_data} and the \code{write_model} functions 
#' before using this function, as their outputs are used as the inputs for \code{run_model}.
#' 
#'
#' @param model_file The file containing the BUGS definition of the EcoDiet model 
#'   output by the \code{write_model} function
#' @param data The preprocessed data list output by the preprocess_data() function
#' @param inits A list containing the initial values of the variables.
#'   By default the initialisation values are NULL, which means that the chain initial values
#'   are drawns from the prior distributions.
#' @param nb_iter The number of iterations to run. The more iteration, the better are the chances that
#'   the model will converge. By default a very small number is used to test if the model is compiling
#'   properly.
#' @param nb_adapt The number of adaptation steps to run. The more adaptation steps, the better are the 
#'   chances that the model will run with good hyperparameters, and thus be faster to converge.
#'   By default a very small number is used to test if the model is compiling properly.
#' @param nb_burnin The number of burn in steps to run. Because the chains start at a random initial value,
#'   it is good practice to "burn in" the first iterations of the chains so that the variable approximations
#'   are not too influenced by the first initial random values. 
#'   By default we use the same strategy as the 'rjags' package and define the number of iterations to be
#'   burnt to be as high as the number of iterations to be kept.
#' @param variables_to_save A vector of variable names defining the variables to output. 
#'   The number has a big number of variables but by default we only save the variables of interest
#'   that are the trophic link probabilities \code{eta} and the diet proportions \code{PI}.
#'   Only these saved variables are used to compute the Gelman-Rubin statistics that indicate whether
#'   the model has converged or not.
#'
#' @return A matrix containing the variables to store for each predator-prey combination in the columns, 
#'   and with one MCMC iteration per line.
#' 
#' @examples
#' 
#' \donttest{
#' realistic_biotracer_data <- read.csv(system.file("extdata", "realistic_biotracer_data.csv",
#'                                                package = "EcoDiet"))
#' realistic_stomach_data <- read.csv(system.file("extdata", "realistic_stomach_data.csv",
#'                                              package = "EcoDiet"))
#'
#' data <- preprocess_data(biotracer_data = realistic_biotracer_data,
#'                         trophic_discrimination_factor = c(0.8, 3.4),
#'                         literature_configuration = FALSE,
#'                         stomach_data = realistic_stomach_data)
#'                         
#' model_string <- write_model(literature_configuration = FALSE)
#' 
#' mcmc_output <- run_model(textConnection(model_string), data, nb_adapt = 1e1, nb_iter = 1e2)
#' }
#' 
#' @seealso \code{\link{preprocess_data}} to preprocess the data, and 
#' \code{\link{write_model}} to define the model. 
#'
#' @export

run_model <- function(model_file, data, inits = NULL, 
                      nb_iter = 1e2, nb_adapt = 1e1, nb_burnin = floor(nb_iter/2),
                      variables_to_save = c("eta", "PI")){
  
  if (nb_burnin >= nb_iter){
    stop("The number of burnin (\"nb_burnin\") needs to be inferior ",
         "to the number of iterations (\"nb_iter\").\n", "Please decrease it.")
  }
  
  nb_thin <- max(1, floor((nb_iter - nb_burnin)/1000))
  
  start_init <- Sys.time()
  
  jags_model <- rjags::jags.model(
    file = model_file,
    data = data, 
    inits = inits,
    n.chains = 3,
    n.adapt = nb_adapt)
  
  duration_init <- Sys.time() - start_init
  message("The model took ", 
          round(unclass(duration_init), 2), " ", attr(duration_init, "units"), 
          " to be initialized.\n")
  
  start_run <- Sys.time()
  
  stats::update(jags_model, n.iter = nb_burnin)

  mcmc_output <- rjags::coda.samples(
    model = jags_model,
    variable.name = variables_to_save,
    n.iter = (nb_iter - nb_burnin),
    thin = nb_thin)
  
  duration_run <- Sys.time() - start_run
  message("The model took ", 
          round(unclass(duration_run), 2), " ", attr(duration_run, "units"), 
          " to run.\n")
  
  print_convergence_diagnostic(mcmc_output)
  
  return(as.matrix(mcmc_output))
}