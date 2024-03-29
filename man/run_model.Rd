% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_model.R
\name{run_model}
\alias{run_model}
\title{Run the EcoDiet model}
\usage{
run_model(
  model_file,
  data,
  inits = NULL,
  run_param = "test",
  variables_to_save = c("eta", "PI"),
  parallelize = FALSE,
  DIC.out = TRUE
)
}
\arguments{
\item{model_file}{The file containing the BUGS definition of the EcoDiet model 
output by the \code{write_model} function}

\item{data}{The preprocessed data list output by the preprocess_data() function}

\item{inits}{A list containing the initial values of the variables.
By default the initialisation values are NULL, which means that the chain initial values
are drawn from the prior distributions.}

\item{run_param}{A object that can be a list of the parameters to configure the JAGS model or a string acting as
a shortcut characterizing the overall length of the run requested (e.g. "short" or "long"). If run_param is 
provided as a list, the user should provide at least nb_iter, i.e. the number of iterations to run (the more
iterations, the better are the chances that the model will converge; very small by default to test if the model
compiles properly), and nb_burnin, i.e. the number of burn-in steps to run (so that the variable approximations
are not too influenced by the first initial random values). nb_thin, the thinning rate, is by default defined by
the function. The number of adaptation steps nb_adapt can be specified but is not required (see jasgUI documentation 
for more details). If set manually, it should be at least set at 1000.}

\item{variables_to_save}{A vector of variable names defining the variables to output. 
The number has a big number of variables but by default we only save the variables of interest
that are the trophic link probabilities \code{eta} and the diet proportions \code{PI}.
Only these saved variables are used to compute the Gelman-Rubin statistics that indicate whether
the model has converged or not.}

\item{parallelize}{Indicates whether chains should be parallelized using several cores. Recommended in case of complex models.}

\item{DIC.out}{Indicates whether the DIC (Deviance Information Criterion) should be reported.}
}
\value{
A MCMC output formatted as a jagsUI object.
}
\description{
This function runs the EcoDiet model using a Markov chain Monte Carlo approximation 
through the 'jagsUI' package to provide an approximated distribution for the variables of interest.

Depending on the \code{nb_iter} entered, this function may take hours, or even days 
to run. We advise you to first test whether your model is compiling properly with the by-default parameters,
as this should take 1-2 min to run depending on your data size.

To save time, this function can solicit several cores (if available) to parallelize chains. Note that progress bars
won't be displayed if chains are parallelized. 

A warning message is printed if the model has not converged in the end (if the Gelman-Rubin diagnostic
of at least one variable is > 1.1). For each run, the default 'jagsUI' package messages summarize
the '.txt' file used for the definition of the BUGS model, the configuration of the model (iteration, adaptation, 
burnin, thin rate), the time required to run the model, and main statistics for the variables.

You need to have run the \code{preprocess_data} and the \code{write_model} functions 
before using this function, as their outputs are used as the inputs for \code{run_model}.
}
\examples{

\donttest{
realistic_biotracer_data <- read.csv(system.file("extdata", "realistic_biotracer_data.csv",
                                               package = "EcoDiet"))
realistic_stomach_data <- read.csv(system.file("extdata", "realistic_stomach_data.csv",
                                             package = "EcoDiet"))

data <- preprocess_data(biotracer_data = realistic_biotracer_data,
                        trophic_discrimination_factor = c(0.8, 3.4),
                        literature_configuration = FALSE,
                        stomach_data = realistic_stomach_data)
                        
write_model(literature_configuration = FALSE)

mcmc_output <- run_model("EcoDiet_model.txt", data, run_param="test")
}

}
\seealso{
\code{\link{preprocess_data}} to preprocess the data, and 
\code{\link{write_model}} to define the model.
}
