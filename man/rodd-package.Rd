\name{rodd-package}
\alias{rodd-package}
\alias{rodd}
\docType{package}
\title{Optimal Discriminating Designs}
\description{This package provides several functions suitable for efficient numerical construction of optimal discriminative designs.}
\details{
At the current state the package provides the routine \code{\link{tpopt}} for the construction of \eqn{T_{\mathrm{P}}}{T_P}-optimal designs and several auxiliary procedures to represent the results. Function \code{\link{tpopt}} is based on the algorithms that were recently developed by Holger Dette, Viatcheslav B. Melas and Roman Guchenko in [7] (see the references for more details).  

It is planned to add several new routines for different types of discriminative designs. 
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
\keyword{package}
