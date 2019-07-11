new;
cls;
library carrionlib;

/*
** Load data
** Note: __FILE_DIR returns the folder
**       containing this file.
*/
year  = loadd(__FILE_DIR $+ "year_month.dat",  "year");
month  = loadd(__FILE_DIR $+ "year_month.dat",  "month");

lpm = loadd(__FILE_DIR $+ "lpm.dat");
lfp = loadd(__FILE_DIR $+ "lfp.dat");
e = loadd(__FILE_DIR $+ "e.dat");

@+++++++++++++++++++++++++++++++++++++++++++++++++++++@
@ Estimation of the model allowing for common factors @
@+++++++++++++++++++++++++++++++++++++++++++++++++++++@

model = 4|1;
k = 12|1;

/* 
** Method to correct for the autoregressive squemes.
** method  == 0 for exogenous (fixed),
** and  ==1 for endogenous (t-sig)
*/
method = 1; 
p_max = 12;

/*
** Method of estimation:
** estima[1]  == 1 for OLS and  == 2 for DOLS;
** estima[2:3] collects the lags and leads for the DOLS
*/
klags = 0;
kleads = 0;

// Method of estimation
estima = 1|klags|kleads;

print "
    @++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++@
    @ Analysis for the longest panel data set (i.e. excluding Portugal,  Finland and Austria) @
    @++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++@";

// Number of observations
T = rows(e);

// Number of individuals
N = cols(e); 

// Set tolerance
tolerance = 0.001;

// Set max iterations
max_iter = 20;

// Find matrix of idiosyncratic disturbance terms 
{ mat_e_idio, fhat, csi, m_tbe, final_iter }  = factcoint_iter(lpm, lfp~e, model, zeros(n, 1), k, tolerance, max_iter);
