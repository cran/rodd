second.order.num.deriv <- function(f, x, epsilon, ...)
{
	(Psi(x + epsilon, ...) - 2 * Psi(x, ...) + Psi(x - epsilon, ...)) / (epsilon * epsilon)
}

