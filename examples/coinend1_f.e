new;
cls;

library carrionlib;

format /rd 7,4;

/*
** This section generates data
*/
t = 200;  
print "Sample size=" t;

// Generate two independent I(1) processes 
x = cumsumc(rndn(t, 1));
y = cumsumc(rndn(t, 1));

/*
** This section sets up the 
** model parameters
*/
// Structure 
struct cointControl cCtl;

// Factors
cCtl.f = 4*rndn(t, 1);

// Method of testing
cCtl.method = "end";

// Parameter vector
cCtl.exogenous = 0;

// Parametric correction
cCtl.lagsdols = 4; 
          
// Set model type          
cCtl.model = 1;  /*  = 1  model An,
                       2  model A,
                       3  model B,
                       4  model C,
                       5  model D,
                       6  model E. */

print "********************************";
print "Test with endogenous break point";
print "********************************";
struct cointOut cOut;

cOut = coint(y, x, cCtl);

vec_out = cOut.eOut.vec_out; 

print "min(SC) test statistic: " vec_out[1, 1] "and estimated break point based on argmin(SC): "  vec_out[1,2];
print "SC test statistic: " vec_out[2, 1] "and estimated break point based on argmin(SSR): "  vec_out[2,2];
print;

vc = valors(cCtl.model, cOut.eOut.vec_out[2, 2]/t, cols(x));
print "Critical values for the SC test at the 10, 5, 2.5 and 1% level of significance";
print "IMPORTANT: note that these critical values are for the SC test, not the min(SC) one";
vc[5:8]';

print;


