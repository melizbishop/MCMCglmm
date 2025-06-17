#include "MCMCglmm.h"
#include <math.h>
double digamma(double x) {
    double result = 0.0, xx, xx2, xx4;
    for (; x < 7.0; ++x) result -= 1.0/x;
    x -= 1.0/2.0;
    xx = 1.0/x;
    xx2 = xx*xx;
    xx4 = xx2*xx2;
    result += log(x) + (1.0/24.0)*xx2 - (7.0/960.0)*xx4 + (31.0/8064.0)*xx4*xx2 - (127.0/30720.0)*xx4*xx4;
    return result;
}

double dirichlet_entropy(double *logalpha, int len) {
    double alpha0 = 0.0, entropy = 0.0;
    for (int i = 0; i < len; i++) {
        alpha[i] = exp(logalpha[i]);
        alpha0 += alpha[i];
    }

    double log_beta = 0.0;
    double digamma_alpha0 = digamma(alpha0);

    for (int i = 0; i < len; i++) {
        log_beta += lgamma(alpha[i]);
    }
    log_beta -= lgamma(alpha0);

    entropy = log_beta - (alpha0 - len) * digamma_alpha0;
    for (int i = 0; i < len; i++) {
        entropy += (alpha[i] - 1.0) * digamma(alpha[i]);
    }
    
    free(alpha);
    return entropy;
}

double entropy_penalty(double target, double current, double intensity) {
    return intensity * pow((current - target) / target, 2.0);
}
}
