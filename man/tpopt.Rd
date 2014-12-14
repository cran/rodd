\name{tpopt}
\alias{tpopt}
\title{Calculation of optimal discriminating design}
\description{Calculates an approximation \eqn{\xi^{**}}{xi^{**}} of the \eqn{T_{\mathrm{P}}}{T_P}-optimal design \eqn{\xi^*}{xi^*} for discrimination between a given list of models \eqn{\{\eta_i(x,\theta_i),\; i = 1,\dots,\nu\}}{{eta_i(x,theta_i), i = 1,\dots,nu}}. This procedure is based on the algorithms developed by Holger Dette, Viatcheslav B. Melas and Roman Guchenko in [7]. \eqn{T_{\mathrm{P}}}{T_P}-optimal design is a probability measure, which maximizes the functional 
\deqn{T_{\mathrm{P}}(\xi) = \sum_{i,j=1}^{\nu} p_{i,j} \inf_{\theta_{i,j} \in \Theta_j} \int_{\mathcal{X}} \Big[ \eta_i(x,\overline{\theta}_{i}) - \eta_j(x,\theta_{i,j}) \Big]^2 \xi(dx),}{T_P(xi) = sum_ij p_ij inf_{theta_ij \in Theta_j} int_X [ eta_i(x,theta_i^) - \eta_j(x,theta_ij) ]^2 xi(dx),}
where \eqn{\xi}{xi} is an arbitrary design on \eqn{\mathcal{X}}{X} (it is presumed here, that \eqn{\mathcal{X}}{X} is an interval from \eqn{\mathbf{R}}{R}), \eqn{\mathrm{P} = \{ p_{i,j} \}_{i,j = 1}^{\nu}}{P = {p_ij}} is a table of non-negative weights with zeros on the diagonal (comparison table) and \eqn{\overline{\theta}_{i}}{theta_i^} are predefined fixed parameters.

It was also shown in [7] that calculation of Bayesian \eqn{T_{\mathrm{P}}}{T_P}-optimal design, which maximizes more complicated criterion
\deqn{T_{\mathrm{P}}^{\mathrm{B}}(\xi) = \sum_{i,j=1}^{\nu} p_{i,j} \int_{\Theta_i} \inf_{\theta_{i,j} \in \Theta_j} \int_{\mathcal{X}} \Big[ \eta_i(x,\lambda_i) - \eta_j(x,\theta_{i,j}) \Big]^2 \xi(dx) \mathcal{P}_i(d \lambda_i),}{T_P(xi) = sum_ij p_ij int_{Lambda_i} inf_{theta_ij \in Theta_j} int_X [ eta_i(x,lambda_i^) - \eta_j(x,theta_ij) ]^2 xi(dx) P_i(d lambda_i),}
can be reduced to calculation of ordinary \eqn{T_{\mathrm{P}}}{T_P}-optimal design, when distributions \eqn{\mathcal{P}_i}{P_i} are discrete. That is why in this case the current function is also suitable for calculation of Bayesian designs.
}
\usage{
tpopt(  x, 
        w = rep(1, length(x)) / length(x), 
        eta, 
        theta.fix, 
        theta.var = NULL, 
        p, 
        x.lb = min(x), 
        x.rb = max(x), 
        opt = list())
}
\arguments{
  \item{x}{a numeric vector specifying support points from \eqn{\mathcal{X}}{X} for initial design. Current algorithm operates under the assumption, that \eqn{\mathcal{X}}{X} is an interval from \eqn{\mathbf{R}}{R}}.
  \item{w}{a numeric vector specifying weights for initial design. This vector should have the same length as vector of support points. Furthermore, the weights of the design should sum to 1. If this vector is not specified, then the weights are presumed to be equal.}
  \item{eta}{a list of models between which proposed optimization should be performed. Every function from this list should be defined in the form of \eqn{\eta_i(x,\theta_i)}{eta_i(x,theta_i)}, where \eqn{x}{x} is one dimensional variable from \eqn{\mathcal{X}}{X} and \eqn{\theta_i} is a vector of corresponding model parameters. We will refer to length of this list as \eqn{\nu}{nu}.}
  \item{theta.fix}{a list of fixed model parameters \eqn{\overline{\theta}_{i}}{\theta_i^'} from the functional \eqn{T_{\mathrm{P}}}{T_P}. This list should have the same length as the list of models.}
  \item{theta.var}{an array with two dimensions specifying initial values for parameter vectors \eqn{\theta_{i,j}}{theta_ij}. The default value here is NULL, which means that initial guess is calculated automatically.}
  \item{p}{a \eqn{\nu\times\nu}{nu x nu} square table (R-matrix) containing non-negative weights for comparison. The diagonal values of this table should all be zeros. If one want to include comparison of the \eqn{i}{i}'th model with fixed parameters against \eqn{j}{j}'th model with variable parameters into optimization, then he/she should place non-negative weight \eqn{p_{i,j}}{p_ij} into the table; otherwise this weight should be zero.}
  \item{x.lb}{a left bound for support points. If it is not specified, then minimal value from input vector \eqn{x}{x} is taken.}
  \item{x.rb}{a right bound for support points. If it is not specified, then maximal value from input vector \eqn{x}{x} is taken.}
  \item{opt}{a list of options containing such named fields:
    \describe{
        \item{method}{a variable specifying the method to be used in inner weight optimization step. See details section for more info. The value ``1'' stands for quadratic programming based procedure and ``2'' stands for specific gradient method. See [7] for more details on that methods.}
        \item{max.iter}{maximum number of iterations for the main loop. Reaching this number of iterations is one of the possible stopping conditions.}
        \item{des.eff}{desired efficiency for resulted approximation of optimal design. Reaching efficiency of more than des.eff is another stopping condition (to be exact, efficiency lower bound is calculated on each iteration of the algorithm instead of efficiency). See details section for exact definition of efficiency.}
        \item{derivative.epsilon}{a value that is used for numerical computation of first and second order derivatives.}
        \item{support.epsilon}{a value that is used for support points exclusion, if corresponding weight's value is less then support.epsilon.}
        \item{weights.evaluation.epsilon}{a value that is used in the inner loop for weights evaluation.}
    }
  }
}
\details{Firstly, lets define
\deqn{\Psi(x,\xi) = \sum_{i,j=1}^{\nu} p_{i,j} \Big[ \eta_i(x,\overline{\theta}_{i}) - \eta_j(x,\widehat{\theta}_{i,j}) \Big]^2, \widehat{\theta}_{i,j} = \arg\inf_{\theta_{i,j} \in \Theta_j} \int_{\mathcal{X}} \Big[ \eta_i(x,\overline{\theta}_i) - \eta_j(x, \theta_{i,j}) \Big]^2 \xi(dx).}{T_P(xi) = sum_ij p_ij [ eta_i(x,theta_i^) - \eta_j(x,theta_ij) ]^2, \theta_{i,j} = arginf_{theta_{i,j} \in Theta_j} int_{X} [ eta_i(x,\theta_i) - eta_j(x, theta_{i,j}) ]^2 xi(dx).}

The simplified algorithm schema is as follows:

Let \eqn{\xi_s}{xi_s} denotes the design obtained on the s'th iteration of the algorithm. Then
\describe{
    \item{Step 1.}{Support of the new design \eqn{\xi_{s+1}}{xi_{s+1}} consists of all local maximums of function \eqn{\Psi(x,\xi_s)}{Psi(x,xi_s)} on \eqn{\mathcal{X}}{X} united with the support of current design \eqn{\xi_s}{xi_s}.} 
    \item{Step 2.}{Weights of the new design \eqn{\xi_{s+1}}{xi_{s+1}} are calculated so that the functional \eqn{T_{\mathrm{P}}(\xi)}{T_P(xi)} achieves its maximum in the class of all designs with support from previous step.}
}
}
\value{Object of class ``tpopt'' which contains the following fields:
    \describe{
        \item{x}{the numeric vector of support points from \eqn{\mathcal{X}}{X} for resulting approximation of \eqn{T_{\mathrm{P}}}{T_P}-optimal design.}
        \item{w}{the numeric vector of weights for resulting approximation of \eqn{T_{\mathrm{P}}}{T_P}-optimal design. The values of this vector sum to 1.}
        \item{efficiency}{the numeric vector containing efficiency lower bound values by iteration. See details section for definition.}
        \item{functional}{the numeric vector containing values of functional \eqn{T_{\mathrm{P}}}{T_P} by iteration.}
        \item{eta}{the list of models, which is exactly the same as one from the arguments list.}
        \item{theta.fix}{the list of fixed model parameters. It goes to the result without any changes too.}
        \item{theta.var}{the array with two dimensions specifying calculated values for parameter vectors \eqn{\theta_{i,j}}{theta_ij} according to resulting design.}
        \item{p, x.lb, x.rb}{same as in input.}
        \item{max.iter}{max.iter from options list.}
        \item{done.iter}{number of iterations done.}
        \item{des.eff}{desired efficiency from options list.}
        \item{time}{overall execution time.}
    }
}
\references{
    [1] Atkinson A.C., Fedorov V.V. (1975) \emph{The design of experiments for discriminating between two rival models}. Biometrika, vol. 62(1), pp. 57--70.

    [2] Atkinson A.C., Fedorov V.V. (1975) \emph{Optimal design: Experiments for discriminating between several models}. Biometrika, vol. 62(2), pp. 289--303.

    [3] Dette H., Pepelyshev A. (2008) \emph{Efficient experimental designs for sigmoidal growth models}. Journal of statistical planning and inference, vol. 138, pp. 2--17.

    [4] Dette H., Melas V.B., Shpilev P. (2013) \emph{Robust T-optimal discriminating designs}. Annals of Statistics, vol. 41(4), pp. 1693--1715.

    [5] Braess D., Dette H. (2013) \emph{Optimal discriminating designs for several competing regression models}. Annals of Statistics, vol. 41(2), pp. 897--922.

    [6] Braess D., Dette H. (2013) \emph{Supplement to ``Optimal discriminating designs for several competing regression models''}. Annals of Statistics, online supplementary material.
    
    [7] Dette H., Melas V.B., Guchenko R. (2014) \emph{Bayesian T-optimal discriminating designs}. \href{http://arxiv.org/abs/1412.2548}{ArXiv link}.
}
\seealso{\code{\link{plot.tpopt}}, \code{\link{summary.tpopt}}, \code{\link{print.tpopt}}}
\examples{
### Auxiliary libraries for examples
library(mvtnorm)
### EMAX vs MM
#List of models
eta.1 <- function(x, theta.1) 
    theta.1[1] + theta.1[2] * x / (x + theta.1[3])

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
        0, 1,
        0, 0
    ), c(2, 2), byrow = TRUE)

#Design estimation
res <- tpopt(x = c(1.2, 1.5, 1.7), eta = eta, theta.fix = theta.fix, p = p, 
    x.lb = 1, x.rb = 2)

plot(res)
summary(res)

### Sigmoidal second
#List of models
eta.1 <- function(x, theta.1)
    theta.1[1] / (1 + theta.1[2] * exp(-theta.1[3] * x)) ^ theta.1[4]
    
eta.2 <- function(x, theta.2)
    theta.2[1] / (1 + theta.2[2] * exp(-theta.2[3] * x))

eta <- list(eta.1, eta.2)

#List of fixed parameters
theta.1 <- c(2, 5, 1, 2)
theta.2 <- c(3, 5, 0.7)
theta.fix <- list(theta.1, theta.2)

#Comparison table
p <- matrix(
    c(  
        0, 1,
        0, 0 
    ), c(2, 2), byrow = TRUE)

#Design estimation
res <- tpopt(x = seq(0, 10), eta = eta, theta.fix = theta.fix, p = p)

plot(res)
summary(res)

### Sigmoidal first
#List of models
eta.1 <- function(x, theta.1)
    theta.1[1] - theta.1[2] * exp(-theta.1[3] * x ^ theta.1[4])

eta.2 <- function(x, theta.2)
    theta.2[1] - theta.2[2] * exp(-theta.2[3] * x)

eta <- list(eta.1, eta.2)

#List of fixed parameters
theta.1 <- c(2, 1, 0.8, 1.5)
theta.2 <- c(2, 1, 1)
theta.fix <- list(theta.1, theta.2)

#Comparision table
p <- matrix(
    c(
        0, 1,
        0, 0
    ), c(2, 2), byrow = TRUE)

#Design estimation
res <- tpopt(x = seq(0, 10), eta = eta, theta.fix = theta.fix, p = p)

plot(res)
summary(res)

### Sigmoidal first --- Bayes

#List of fixed parameters
sigma <- sqrt(0.3)
theta.1.sigma <- matrix(
    c(
        sigma^2, 0,
        0, sigma^2
    ), c(2, 2), byrow = TRUE)
grid <- expand.grid(
    theta.1[1],
    theta.1[2],
    seq(theta.1[3] - sigma, theta.1[3] + sigma, length.out = 5),
    seq(theta.1[4] - sigma, theta.1[4] + sigma, length.out = 5)
    )

eta <- c(replicate(length(grid[,1]), eta.1, simplify = FALSE), eta.2)

theta.fix <- list()
for(i in 1:length(grid[,1]))
    theta.fix[[length(theta.fix) + 1]] <- as.numeric(grid[i,])
theta.fix[[length(theta.fix) + 1]] <- theta.2

density.on.grid <- dmvnorm(grid[,3:4], mean = theta.1[3:4], sigma = theta.1.sigma)
density.on.grid <- density.on.grid / sum(density.on.grid)

#Comparison table
p <- rep(0,length(eta))
for(i in 1:length(grid[,1]))
    p <- rbind(p, c(rep(0,length(eta) - 1), density.on.grid[i]))
p <- rbind(p, rep(0,length(eta)))
p <- p[-1,]

res <- tpopt(x = seq(0, 10), eta = eta, theta.fix = theta.fix, p = p)

plot(res)
summary(res)

### Dose response study 
#List of models
eta.1 <- function(x, theta.1)
    theta.1[1] + theta.1[2] * x

eta.2 <- function(x, theta.2)
    theta.2[1] + theta.2[2] * x * (theta.2[3] - x)

eta.3 <- function(x, theta.3)
    theta.3[1] + theta.3[2] * x / (theta.3[3] + x)

eta.4 <- function(x, theta.4)
    theta.4[1] + theta.4[2] / (1 + exp((theta.4[3] - x) / theta.4[4]))

eta <- list(eta.1, eta.2, eta.3, eta.4)

#List of fixed parameters
theta.1 <- c(60, 0.56)
theta.2 <- c(60, 7/2250, 600)
theta.3 <- c(60, 294, 25)
theta.4 <- c(49.62, 290.51, 150, 45.51)

theta.fix <- list(theta.1, theta.2, theta.3, theta.4)

#Comparison table
p <- matrix(
    c(
        0, 0, 0, 0,
        1, 0, 0, 0,
        1, 1, 0, 0,
        1, 1, 1 ,0
    ), c(4, 4), byrow = TRUE)

#Design estimation
res <- tpopt(x = seq(0, 500, 100), eta = eta, theta.fix = theta.fix, p = p)

plot(res)
summary(res)

### Dose response study --- Bayes

#List of fixed parameters
sigma <- 37
theta.4.sigma <- matrix(
    c(
        sigma^2, 0, 0, 0,
        0, sigma^2, 0, 0,
        0, 0, sigma^2, 0,
        0, 0, 0, sigma^2
    ), c(4, 4), byrow = TRUE)
grid <- expand.grid(
    seq(theta.4[1] - sigma, theta.4[1] + sigma, length.out = 3),
    seq(theta.4[2] - sigma, theta.4[2] + sigma, length.out = 3),
    seq(theta.4[3] - sigma, theta.4[3] + sigma, length.out = 3),
    seq(theta.4[4] - sigma, theta.4[4] + sigma, length.out = 3)
    )

eta <- c(eta.1, eta.2, eta.3, replicate(length(grid[,1]), eta.4, simplify = FALSE))

theta.fix <- list(theta.1, theta.2, theta.3)
for(i in 1:length(grid[,1]))
    theta.fix[[length(theta.fix) + 1]] <- as.numeric(grid[i,])

density.on.grid <- dmvnorm(grid, mean = theta.4, sigma = theta.4.sigma)
density.on.grid <- density.on.grid / sum(density.on.grid)

#Comparison table
p <- rbind(
    rep(0, length(eta)), 
    c(1, rep(0, length(eta) - 1)), 
    c(1, 1, rep(0,length(eta) - 2))
    )
for(i in 1:length(grid[,1]))
    p <- rbind(p, c(rep(density.on.grid[i], 3), rep(0, length(eta) - 3)))

#Design estimation
\dontrun{
res <- tpopt(x = seq(0, 500, 100), eta = eta, theta.fix = theta.fix, p = p)}

plot(res)
summary(res)
}
\keyword{discriminative designs}

