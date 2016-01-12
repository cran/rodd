\name{KLopt.lnorm}
\alias{KLopt.lnorm}
\title{Calculation of \eqn{KL}{KL}-optimal discriminating design for lognormal errors}
\description{Calculates an approximation \eqn{\xi^{**}}{xi^{**}} of the \eqn{KL}{KL}-optimal design (in case of lognormal errors) \eqn{\xi^*}{xi^*} for discrimination between a given list of error densities \eqn{\{f_i(x,\theta_i),\; i = 1,\dots,\nu\}}{{f_i(x,theta_i), i = 1,\dots,nu}}. This procedure is based on the work [8]. This function mimics \code{\link{tpopt}} almost entirely. It is planed to combine \code{\link{tpopt}} and \code{\link{KLopt.lnorm}} in the future. See \code{\link{tpopt}} for the detailed description of the arguments marked with ``-//-''.
}
\usage{
KLopt.lnorm(    x, 
                w = rep(1, length(x)) / length(x), 
                eta, 
                sq.var,
                theta.fix, 
                theta.var = NULL, 
                p, 
                x.lb = min(x), 
                x.rb = max(x), 
                opt = list())
}
\arguments{
  \item{x}{-//-}
  \item{w}{-//-}
  \item{eta}{a list of means for the error densities \eqn{\{f_i(x,\theta_i),\; i = 1,\dots,\nu\}}{{f_i(x,theta_i), i = 1,\dots,nu}} between which proposed optimization should be performed. Every function from this list should be defined in the form of \eqn{\eta_i(x,\theta_i)}{eta_i(x,theta_i)}, where \eqn{x}{x} is one dimensional variable from \eqn{\mathcal{X}}{X} and \eqn{\theta_i} is a vector of corresponding model parameters. We will refer to length of this list as \eqn{\nu}{nu}.}
  \item{sq.var}{a list of variances for the error densities \eqn{\{f_i(x,\theta_i),\; i = 1,\dots,\nu\}}{{f_i(x,theta_i), i = 1,\dots,nu}} between which proposed optimization should be performed. Every function from this list should be defined in the form of \eqn{v^2_i(x,\theta_i)}{v^2_i(x,theta_i)}. This list also has the length equal to \eqn{\nu}{nu}.}
  \item{theta.fix}{-//-}
  \item{theta.var}{-//-}
  \item{p}{-//-}
  \item{x.lb}{-//-}
  \item{x.rb}{-//-}
  \item{opt}{-//-}
}
\value{Object of class ``KLopt.lnorm'' which contains the following fields:
    \describe{
        \item{x, w, efficiency, functional}{-//-}
        \item{eta}{a list of means from the input.}
        \item{sq.var}{a list of variances from the input.}
        \item{theta.fix, theta.var, p, x.lb, x.rb, max.iter, done.iter, des.eff, time}{-//-}
    }
}
\seealso{\code{\link{plot.KLopt.lnorm}}, \code{\link{summary.KLopt.lnorm}}, \code{\link{print.KLopt.lnorm}}}

\keyword{discriminative designs}
\examples{
\dontrun{
### Examples from [8]
### Cases 1 and 3 are presented here; case 2 can be computed using the
### function tpopt (see the description of this function for exact example)
 
library(mvtnorm)

### Example 1 from [8]; EMAX vs MM

#List of models
eta.1 <- function(x, theta.1) 
    theta.1[1] * x + theta.1[2] * x / (x + theta.1[3])

eta.2 <- function(x, theta.2) 
    theta.2[1] * x / (x + theta.2[2])

eta <- list(eta.1, eta.2)

#List of fixed parameters
theta.1 <- c(1, 1, 1)
theta.2 <- c(1, 1)
theta.fix <- list(theta.1, theta.2)

#Comparison table
p <- matrix(
    c(
        0,1,
        0,0
    ), c(length(eta), length(eta)), byrow = TRUE)

### Case 1 

#List of variances
sq.var.1 <- function(x, theta.1)
    1
    
sq.var.2 <- function(x, theta.2)
    1

sq.var <- list(sq.var.1, sq.var.2)
    
#Case 1, method 1
res <- KLopt.lnorm(
    x = seq(0.1, 5, length.out = 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p,  
    opt = list(method = 1)
)
plot(res)
summary(res)

#Case 1, method 2
res <- KLopt.lnorm(
    x = seq(0.1, 5, length.out = 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p,  
    opt = list(method = 2)
)
plot(res)
summary(res)

### case 3
#List of variances
sq.var.1 <- function(x, theta.1)
    exp(eta.1(x, theta.1))
    
sq.var.2 <- function(x, theta.2)
    exp(eta.2(x, theta.2))

sq.var <- list(sq.var.1, sq.var.2)

#Case 3, method 1
res <- KLopt.lnorm(
    x = seq(0.1, 5, length.out = 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p,  
    opt = list(method = 1)
)
plot(res)
summary(res)

#Case 3, method 2
res <- KLopt.lnorm(
    x = seq(0.1, 5, length.out = 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p,  
    opt = list(method = 2)
)
plot(res)
summary(res)

### Example 2 from [8]; sigmoidal

#List of models
eta.1 = function(x, theta.1)
    theta.1[1] - theta.1[2] * exp(-theta.1[3] * x ^ theta.1[4])

eta.2 <- function(x, theta.2)
    theta.2[1] - theta.2[2] * exp(-theta.2[3] * x)

#List of fixed parameters
theta.1.mean <- c(2, 1, 0.8, 1.5)
sigma <- 0.3
theta.1.sigma <- matrix(
    c(
        sigma,0,
        0,sigma
    ), c(2, 2), byrow = TRUE)
grid <- expand.grid(
    theta.1.mean[1],
    theta.1.mean[2],
    seq(theta.1.mean[3] - sqrt(sigma), theta.1.mean[3] + sqrt(sigma), length.out = 5),
    seq(theta.1.mean[4] - sqrt(sigma), theta.1.mean[4] + sqrt(sigma), length.out = 5)
)

theta.2 <- c(2,1,1)

theta.fix <- list()
for(i in 1:length(grid[,1]))
    theta.fix[[length(theta.fix)+1]] <- as.numeric(grid[i,])
theta.fix[[length(theta.fix)+1]] <- theta.2

density.on.grid <- dmvnorm(grid[,3:4], mean = theta.1.mean[3:4], sigma = theta.1.sigma)
density.on.grid <- density.on.grid / sum(density.on.grid)
    
eta <- list()
for(i in 1:length(grid[,1]))
    eta <- c(eta, eta.1)
eta <- c(eta, eta.2)

#Comparison table
p <- rep(0,length(eta))
for(i in 1:length(grid[,1]))
    p <- rbind(p, c(rep(0,length(eta)-1), density.on.grid[i]))
p <- rbind(p, rep(0,length(eta)))
p <- p[-1,]

### Case 1

sq.var.1 <- function(x, theta.1)
    1

sq.var.2 <- function(x, theta.2)
    1

sq.var <- list()
for(i in 1:length(grid[,1]))
    sq.var <- c(sq.var, sq.var.1)
sq.var <- c(sq.var, sq.var.2)

#Case 1, method 1
res <- KLopt.lnorm(
    x = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p, 
    opt = list(method = 1)
)
plot(res)
summary(res)

#Case 1, method 2 
res <- KLopt.lnorm(
    x = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p, 
    opt = list(method = 2)
)
plot(res)
summary(res)

### Case 3

sq.var.1 <- function(x, theta.1)
    exp(eta.1(x, theta.1))

sq.var.2 <- function(x, theta.2)
    exp(eta.2(x, theta.2))

sq.var <- list()
for(i in 1:length(grid[,1]))
    sq.var <- c(sq.var, sq.var.1)
sq.var <- c(sq.var, sq.var.2)

#Case 3, method 1 
res <- KLopt.lnorm(
    x = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p, 
    opt = list(method = 1)
)
plot(res)
summary(res)

#Case 3, method 2 
res <- KLopt.lnorm(
    x = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p, 
    opt = list(method = 2)
)
plot(res)
summary(res)

### Example 3 from [8]; dose response

#List of models
eta.1 <- function(x, theta.1)
    theta.1[1] + theta.1[2] * x

eta.2 <- function(x, theta.2)
    theta.2[1] + theta.2[2] * x * (theta.2[3] - x)

eta.3 <- function(x, theta.3)
    theta.3[1] + theta.3[2] * x / (theta.3[3] + x)

eta.4 <- function(x, theta.4)
    theta.4[1] + theta.4[2] / (1 + exp((theta.4[3] - x) / theta.4[4]))

#List of fixed parameters
theta.1 <- c(60, 0.56)
theta.2 <- c(60, 7 / 2250, 600)
theta.3 <- c(60, 294, 25)
theta.4.mean <- c(49.62, 290.51, 150, 45.51)
a <- 45
b <- 20
grid <- expand.grid(
        c(theta.4.mean[1] - b, theta.4.mean[1], theta.4.mean[1] + a), 
        c(theta.4.mean[2] - b, theta.4.mean[2], theta.4.mean[2] + a), 
        c(theta.4.mean[3] - b, theta.4.mean[3], theta.4.mean[3] + a), 
        c(theta.4.mean[4] - b, theta.4.mean[4], theta.4.mean[4] + a)  
        )

eta <- list()
eta <- c(eta, eta.1, eta.2, eta.3)
for(i in 1:length(grid[,1]))
    eta <- c(eta, eta.4)

theta.fix <- list(theta.1, theta.2, theta.3)
for(i in 1:length(grid[,1]))
    theta.fix[[length(theta.fix) + 1]] <- as.numeric(grid[i,])

density.on.grid <- rep(1,length(grid[,1]))
density.on.grid <- density.on.grid / sum(density.on.grid)

#Comparison table
p <- rep(0, length(eta))
p <- rbind(p, c(1, rep(0, length(eta) - 1)))
p <- rbind(p, c(1, 1, rep(0,length(eta) - 2)))
for(i in 1:length(grid[,1]))
    p <- rbind(p, c(rep(density.on.grid[i], 3), rep(0, length(eta) - 3)))

### Case 1

#List of variances
sq.var.1 <- function(x, theta.1)
    1
    
sq.var.2 <- function(x, theta.2)
    1

sq.var.3 <- function(x, theta.3)
    1

sq.var.4 <- function(x, theta.4)
    1

sq.var <- list()
sq.var <- c(sq.var, sq.var.1, sq.var.2, sq.var.3)
for(i in 1:length(grid[,1]))
    sq.var <- c(sq.var, sq.var.4)

#Case 1, method 1

#Design estimation
res <- KLopt.lnorm(
    x = seq(0, 500, length.out = 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p, 
    opt = list(max.iter = 10)
)
plot(res)
summary(res)

#Case 1, method 2

#Design estimation
res <- KLopt.lnorm(
    x = seq(0, 500, length.out = 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p, 
    opt = list(
        method = 2, 
        max.iter = 10, 
        weights.evaluation.max.iter = 50, 
        support.epsilon = 1e-4
    )
)
plot(res)
summary(res)

### Case 3

#List of variances
sq.var.1 <- function(x, theta.1)
    exp(1e-2 * eta.1(x,theta.1))
    
sq.var.2 <- function(x, theta.2)
    exp(1e-2 * eta.2(x,theta.2))

sq.var.3 <- function(x, theta.3)
    exp(1e-2 * eta.3(x,theta.3))

sq.var.4 <- function(x, theta.4)
    exp(1e-2 * eta.4(x,theta.4))
    
sq.var <- list()
sq.var <- c(sq.var, sq.var.1, sq.var.2, sq.var.3)
for(i in 1:length(grid[,1]))
    sq.var <- c(sq.var, sq.var.4)

#Case 3, method 1
    
#Design estimation
res <- KLopt.lnorm(
    x = seq(0, 500, length.out = 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p, 
    opt = list(max.iter = 10)
)
plot(res)
summary(res)

#Case 3, method 2

eta.2 <- function(x, theta.2)
    theta.2[1] + theta.2[2] * x - theta.2[3] * x * x

theta.2 <- c(60, 7 * 600 / 2250, 7 / 2250)

eta <- list()
eta <- c(eta, eta.1, eta.2, eta.3)
for(i in 1:length(grid[,1]))
    eta <- c(eta, eta.4)

theta.fix <- list(theta.1, theta.2, theta.3)
for(i in 1:length(grid[,1]))
    theta.fix[[length(theta.fix) + 1]] <- as.numeric(grid[i,])

#Design estimation
res <- KLopt.lnorm(
    x = seq(0, 500, length.out = 10), 
    eta = eta, sq.var = sq.var, theta.fix = theta.fix, p = p, 
    opt = list(max.iter = 6, method = 2)
)
plot(res)
summary(res)
}
}

