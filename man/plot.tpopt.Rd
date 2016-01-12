\name{plot.tpopt}
\alias{plot.tpopt}
\title{Plot of \eqn{\Psi}{Psi} function for resulting design}
\description{Plots the \eqn{\Psi(x,\xi)}{Psi(x,xi)} function for resulting approximation \eqn{\xi^{**}}{xi^{**}} of the \eqn{T_{\mathrm{P}}}{T_P}-optimal design achieved with the help of \code{\link{tpopt}}. The definition of \eqn{\Psi(x,\xi)}{Psi(x,xi)} can be found in the ``details'' section of function's \code{\link{tpopt}} specifications.
}
\usage{
\method{plot}{tpopt}(x, ...)
}
\arguments{
  \item{x}{an object of type "tpopt".}
  \item{\dots}{additional graphical parameters.}
}
\details{We are interested in the shape of function \eqn{\Psi(x,\xi^{**})}{Psi(x,xi^{**})} when we want to ensure the convergence of the algorithm. If algorithm had converged, then support points of \eqn{\xi^{**}}{xi^{**}} (which are represented by dots) will be near local maximums of the mentioned function. Furthermore, at all local maximums \eqn{\Psi(x,\xi^{**})}{Psi(x,xi^{**})} should have the same value. Otherwise something went wrong and the algorithm should be restarted with another parameters.}

\examples{
#List of models
eta.1 = function(x, theta.1) 
    theta.1[1] + theta.1[2] * x + theta.1[3] * (x ^ 2) + 
    theta.1[4] * (x ^ 3) + theta.1[5] * (x ^ 4)

eta.2 = function(x, theta.2) 
    theta.2[1] + theta.2[2] * x + theta.2[3] * (x ^ 2)

eta <- list(eta.1, eta.2)

#List of fixed parameters
theta.1 <- c(1,1,1,1,1)
theta.2 <- c(1,1,1)
theta.fix <- list(theta.1, theta.2)

#Comparison table
p <- matrix(
    c(
        0, 1,
        0, 0
    ), c(length(eta), length(eta)), byrow = TRUE)

x <- seq(-1, 1, 0.1)
opt.1 <- list(method = 1, max.iter = 1)
opt.2 <- list(method = 1, max.iter = 2)
opt.3 <- list(method = 1)

res.1 <- tpopt(x = x, eta = eta, theta.fix = theta.fix, p = p, opt = opt.1)
res.2 <- tpopt(x = x, eta = eta, theta.fix = theta.fix, p = p, opt = opt.2)
res.3 <- tpopt(x = x, eta = eta, theta.fix = theta.fix, p = p, opt = opt.3)

plot(res.1)
plot(res.2)
plot(res.3)
}
\seealso{\code{\link{tpopt}}, \code{\link{summary.tpopt}}, \code{\link{print.tpopt}}}
\keyword{auxiliary}
