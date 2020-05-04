new;
cls;
library carrionlib;

//**********************************************************
// Start reading your data (here we generate artificial data) 
//**********************************************************

t = 100;
n = 20;

// Dependemt variable
y = cumsumc(rndn(t, n)); 

// First regressor
x1 = cumsumc(rndn(t, n)); 

// Second regressor
x2 = cumsumc(rndn(t, n)); 

// Third regressors
x3 = cumsumc(rndn(t, n)); 

// Concatenation of the stochastic regressors 
// (in this example, we just consider three stochastic regressors) @
x = x1~x2~x3; 

//***************************************
// Start defining the options of the code 
//***************************************
struct cadfControl cadfCtl;

// Model = 0 for the non-deterministics specification, 
// 1 for the constant and 2 for the trend 
cadfCtl.model = 2; 

// Number of common factors
cadfCtl.numberFactors = cols(x)+1; 

// Method = 1 if you include CS averages in the cointegration regression as in Holly et al. (2010). 
// Method = 0 if you do not want to include them 
cadfCtl.method = 1; 

// Set 1 for the mean group estimator, 2 for the pooled estimator, 
// which is the estimator proposed in the paper 
cadfCtl.option = 2; 

// Order of the autoregressive correction
cadfCtl.numlags= 3;

//**********************************************
// Running the code that computes the statistics 
//**********************************************

{ panel_t_cadf, individual_t_cadf } = CADFcoin_multiple(y, x, cadfCtl); 

//******************************************************************
// Printing the statistics results (panel and individual statistics)
//******************************************************************

print "Panel cointegration CCE statistic: " panel_t_cadf;
print "N Individual cointegration CCE statistic: " individual_t_cadf;
