new;
cls;
library carrionlib;

/*
** Load the factor matrix;
** the result matrix from factcoint
** Note: __FILE_DIR returns the folder
**       containing this file.
*/
fname = __FILE_DIR $+ "fhat.fmt";
fhat = loadd(fname);

// Specify model;
model = 4;

// Count
N = 63;

/*
** Matrix to store the non-parametric test to estimate
** the number of common trends of the estimated common factors
*/
test_np = zeros(2, 1);

/*
** Matrix to store the parametric test to
** estimate the number of common trends of
** the estimated common factors
*/
test_p = zeros(2, 1);

// Non-parametric test
{ test_np[1], test_np[2] } = MQ_test(fhat, model[1], N, 0);

// Parametric test
{ test_p[1], test_p[2] } = MQ_test(fhat, model[1], N, 1);

print;
print "Number of common stochastic trends (Non-parametric test): " ;
print "Test statistic: " test_np[1] "number of stochastic trends" test_np[2];
print;
print "Number of common stochastic trends (Parametric test): ";
print "Test statistic: " test_p[1] "number of stochastic trends" test_p[2];
 
