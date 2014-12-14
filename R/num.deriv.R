num.deriv <- function(f, x, epsilon, ...)
{
    (Psi(x + epsilon, ...) - Psi(x - epsilon, ...)) / (2 * epsilon)
}
