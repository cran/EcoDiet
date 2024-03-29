% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R
\name{plot_data}
\alias{plot_data}
\title{Plot the input data}
\usage{
plot_data(
  biotracer_data = NULL,
  stomach_data = NULL,
  save = FALSE,
  save_path = "."
)
}
\arguments{
\item{biotracer_data}{A dataframe containing the biotracer data in the specific format: the first column
corresponds to the trophic group or latin species and the remaining columns contains the biotracer
measures}

\item{stomach_data}{A dataframe containing the stomach content data in a specific format: the first row
contains the names of the prey trophic groups, the headers contains the names of the consumer / 
predator trophic groups, and the rest are the number of the predator's stomachs in which this prey
was found. The last row contains the total number of non-empty stomach for the corresponding
predator.}

\item{save}{A boolean describing whether the figure should be saved as PNG. 
By default the figures are not saved.}

\item{save_path}{A string describing the path to which the figures should be saved.
By default the figures are saved in a temporary directory.}
}
\description{
This function is used to plot the input biotracer and/or the stomach content data.
You can use the function with only one parameter to plot only one kind of data.

The figure(s) can be saved as PNG using: \code{save = TRUE}, and the directory path to which
the figures are saved can be precised with: \code{save_path = "."}.

If only the stomach content data is entered, there will be a single raster plot containing the proportions
of occurences in the stomachs. 

For the biotracer data, there will be as many plots as the number of
combinations of elements. For example if only two isotopes are entered, there will be a single biplot
plotted. If three elements are entered (element A, B and C), three biplots will be shown : A vs. B, 
B vs. C and A vs. C.
}
\examples{

example_biotracer_data <- read.csv(system.file("extdata", "example_biotracer_data.csv",
                                               package = "EcoDiet"))
plot_data(biotracer_data = example_biotracer_data)

example_stomach_data <- read.csv(system.file("extdata", "example_stomach_data.csv",
                                             package = "EcoDiet"))

plot_data(biotracer_data = example_biotracer_data,
          stomach_data = example_stomach_data)
          
     
}
\seealso{
\code{\link{plot_prior}} to plot the prior means or probability distribution(s), 
  \code{\link{plot_results}} to plot the posterior means or probability distribution(s)
}
