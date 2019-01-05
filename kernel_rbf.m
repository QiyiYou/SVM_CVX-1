function K = kernel_rbf(set1, set2, sigma)


K = exp(-(norm(set1 - set2) ^ 2) / (2 * sigma ^ 2));