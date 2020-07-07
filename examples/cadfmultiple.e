new;
cls;
library carrionlib;

//**********************************************************
// Start reading your data (here we generate artificial data) 
//**********************************************************

// Here we load all data for testing
// Note that this dataset is stacked
// and the cadfcoin_multiple procedure
// requires wide panel data
data = loadd(__FILE_DIR $+ "brics.xlsx", "lco2 + ly"); 

// Time periods
bigt = 29;
ncross = rows(data)/bigT;
k = 1;

// Convert dependent data
// from stacked to wide
y = reshape(data[., 1], ncross, bigT)';

// Convert independent data
// from stacked to wide
x = reshape(data[., 2]', ncross*k, bigT)';

//***************************************
// Start defining the options of the code 
//***************************************
struct cadfControl cadfCtl;

// Model = 0 for the non-deterministics specification, 
// 1 for the constant and 2 for the trend 
cadfCtl.model = 1; 

// Number of common factors
cadfCtl.numberFactors = cols(x)+1; 

// Method = 1 if you include CS averages in the cointegration regression as in Holly et al. (2010). 
// Method = 0 if you do not want to include them 
cadfCtl.method = 0; 

// Set 1 for the mean group estimator, 2 for the pooled estimator, 
// which is the estimator proposed in the paper 
cadfCtl.option = 1; 

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
