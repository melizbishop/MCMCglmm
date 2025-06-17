#include "MCMCglmm.h"

double entropy_calc(double* alpha, int len) {
    double alpha0 = 0.0;
    double sum_gammaln = 0.0;
    double sum_term = 0.0;

    for (int i = 0; i < len; i++) {
        alpha0 += alpha[i];
        sum_gammaln += lgamma(alpha[i]);
        sum_term += (alpha[i] - 1.0) * digamma(alpha[i]);
    }

    return sum_gammaln - lgamma(alpha0) + (alpha0 - len) * digamma(alpha0) - sum_term;
}
