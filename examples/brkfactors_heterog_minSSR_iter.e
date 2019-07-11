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

/*
** Deterministic model
**     model[1] = 1 for the individual effects model (Pedroni model), 
**     model[1] = 2 for the individual and time effects model (Pedroni model), 
**     model[1] = 3 for the individual effects and one level shift model (no break in the cointegrating vector), 
**     model[1] = 4 for the individual and time effects and one level shift (no break in the cointegrating vector), 
**     model[1] = 5 for the individual and time effects,  with both level and slope shift (no break in the cointegrating vector), 
**     model[1] = 6 for the individual effects,  with both level and cointegrating vector shift, 
**     model[1] = 7 for the individual and time effects,  with both level (no trend shift) and cointegrating vector shift, 
**     model[1] = 8 for the individual and time effects,  with all level,  time trend and cointegrating vector shift.
**
**     model[2] = 0 if the break dates are known
**              = 1 if the break dates are unknown
*/
model = 4|1;

/*
** Specify factors
**
**     k[1] = 0 if the number of common factors is known
**          = 1 if the number of common factors is unknown
**     k[2] scalar,  with the maximum number of common factors
*/
k = 12|1;

/* 
** Method to correct for the autoregressive squemes.
** method  == 0 for exogenous (fixed),
** and  ==1 for endogenous (t-sig)
*/
method = 1;

// Maximum lags
p_max = 12;

/*
** Method of estimation:
** estima[1]  == 1 for OLS and  == 2 for DOLS;
** estima[2:3] collects the lags and leads for the DOLS
*/
klags = 0;
kleads = 0;
estima = 1|klags|kleads;

/* Empirical moments of the distribution obtained for T=100 and 100,000 replications */
if model[1] == 1 or model[1] == 3 or model[1] == 6;
    mean_t = -0.41632799;
    var_t = 0.98339487;
elseif model[1] == 2 or model[1] == 4 or model[1] == 7;
    mean_t = -1.5377067;
    var_t = 0.35005403;
elseif model[1]==5 or model[1] == 8;
    mean_t = {-1.6803178,
            -1.8163351,
            -1.9198423,
            -1.9805257,
            -1.998013,
            -1.9752734,
            -1.9125286,
            -1.816865,
            -1.6755147}; @ Each row for different values of lambda @
    
    var_t = {0.40488013,
            0.41454518,
            0.40165997,
            0.36829752,
            0.35833849,
            0.36808259,
            0.39040626,
            0.4229098,
            0.39749512}; @ Each row for different values of lambda @
endif;



@+++++++++++++++++++++++++++@
@ for the coikpss procedure @
@+++++++++++++++++++++++++++@

cri_coikpss=0|0;  @  cri[1]==0 :   weak exogenous regressors (OLS estimation)
                     cri[1]==1 :   endogenous regressors (DOLS estimation)
                     cri[2] : scalar with the initial maximum value for the leads and lags @

if model[1] == 4; 
    model_coikpss=2;  @   =  1  model An,
                             2  model A,
                             3  model B,
                             4  model C,
                             5  model D,
                             6  model E. @
elseif model[1] == 7; 
    model_coikpss=5;  @   =  1  model An,
                             2  model A,
                             3  model B,
                             4  model C,
                             5  model D,
                             6  model E. @
endif;


print "
@++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++@
@ Analysis for the longest panel data set (i.e. excluding Portugal, Finland and Austria) @
@++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++@";
// Number of observations
T = rows(e);

// Number of individuals
N = cols(e); 

// Set tolerance
tolerance = 0.001;

// Set max iterations
max_iter = 20;

@++++++++++++++++++++++++++++++++@
@ Estimation of the factor model @
@++++++++++++++++++++++++++++++++@
// Matrix of idiosyncratic disturbance terms
{ mat_e_idio, fhat, csi, m_tbe, final_iter } = 
factcoint_iter(lpm, lfp~e, model, zeros(n, 1), k, tolerance, max_iter); 

@++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++@
@ Estimation of the equation unit-by-unit assuming cointegration @
@++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++@

m_tb_minSSR = zeros(N, 1);
m_BIC_minSSR = zeros(N, 1);

num_stregs = 2;

if model_coikpss == 2;
    mat_beta = zeros(N, 3+num_stregs);
elseif model_coikpss == 5;
    mat_beta = zeros(N, 3+2*num_stregs);
endif;

mat_MSE = zeros(N, 1);

i = 1;
do until i>N;
    //  We lose the first observation because of the factors estimation procedure
    y = lpm[2:T, i];
    x = lfp[2:T,i]~e[2:T,i];

    { vec_out, bic } = coi_end_factor(y, x, fhat, model_coikpss, 1, cri_coikpss); 

    m_tb_minSSR[i] = vec_out[2, 2];
    m_BIC_minSSR[i] = bic;

    { b, tests, u, t_b, bic } = coi_kpss_factor(y, x, fhat, model_coikpss|m_tb_minSSR[i], 1, cri_coikpss);

    mat_beta[i, .] = b[1:cols(mat_beta)]';

    y_fit = y - u;

    mat_MSE[i] = u'u/(T-1);

    plotxy(seqa(1, 1, t-1), y~y_fit);
    //wait;

    i = i + 1;
endo;

print "Estimated parameters";
print "The first three parameters for the deterministic component (constant, slope of the trend and change in level) and the others for the stochastic regressors";
print mat_beta;
print "Estimated break points (year and month)";
print year[m_tb_minSSR,1]~month[m_tb_minSSR,1];


