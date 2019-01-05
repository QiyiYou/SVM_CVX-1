function K = kernel_poly(set1, set2, p)


K = (set1 * set2' + 1) ^ p;