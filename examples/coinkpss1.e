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
cCtl.f = 0;

// Parameter vector
cCtl.exogenous = 0;

// Parametric correction
cCtl.lagsdols = 4; 
          
// Set model type          
cCtl.model = 1;  /*   = 1  model An,
                 2  model A,
                 3  model B,
                 4  model C,
                 5  model D,
                 6  model E. */
                 
print "***************************";
print "Test with known break point";
print "***************************";
// Method of testing
cCtl.method = "kpss";

// Break point
cCtl.breakPoint = 50;

struct cointOut cOut;

cOut = coint(y, x, cCtl);

print "SC statistic: " cOut.kOut.tests "for the break point located at: " cOut.kOut.t_b;
print;

vc = valors(cCtl.model, cOut.kOut.t_b/t, cols(x));
print "Critical values for the SC test at the 10, 5, 2.5 and 1% level of significance";
vc[5:8]';
