new;
cls;
library carrionlib;

/*
** Load data
** Note: __FILE_DIR returns the folder
**       containing this file.
*/
year = loadd(__FILE_DIR $+ "year_month.dat",  "year");
month = loadd(__FILE_DIR $+ "year_month.dat",  "month");

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


/* 
** Empirical moments of the 
** distribution obtained for 
** T =100 and 100, 000 replications 
*/
if model[1]  == 1 or model[1]  == 3 or model[1]  == 6;
    mean_t  = -0.41632799;
    var_t  = 0.98339487;
elseif model[1]  == 2 or model[1]  == 4 or model[1]  == 7;
    mean_t  = -1.5377067;
    var_t  = 0.35005403;
elseif model[1] == 5 or model[1]  == 8;
    mean_t  = {-1.6803178, 
        -1.8163351, 
        -1.9198423, 
        -1.9805257, 
        -1.998013, 
        -1.9752734, 
        -1.9125286, 
        -1.816865, 
        -1.6755147}; @ Each row for different values of lambda @
    
    var_t  = {0.40488013, 
        0.41454518, 
        0.40165997, 
        0.36829752, 
        0.35833849, 
        0.36808259, 
        0.39040626, 
        0.4229098, 
        0.39749512}; @ Each row for different values of lambda @
endif;

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

original_coint_residual  = mat_e_idio + fhat*csi';

// Matrix to store the individual ADF statistics
m_adf  = zeros(n, 1);

j = 1;
do until j>n;
    // ADF test onto the idiosyncratic disturbances
    {t_adf, rho_adf, p} = ADFRC(mat_e_idio[., j], method, p_max);
    m_adf[j] = t_adf;
    j = j + 1;
endo;

test_t  = (((N^(-1/2)*sumc(m_adf[., 1]))-(mean_t)*sqrt(N))/sqrt(var_t))~cols(fhat);

print "Sample size: " T;
print "Number of individuals: " N;
print "Test statistic" test_t;
print "Number of iterations used: " final_iter;
if final_iter == max_iter+1;
    print "WARNING: the maximum number of iterations has been achieved!!!!!!";
endif;
print "% of rejections for the individual tests (5% level of sig.): " meanc(m_adf .lt -1.95);
print "Estimated break point,  year and month: " (year[m_tbe])~(month[m_tbe]);

@+++++++++++++++++++++++++++++@
@ Test for the common factors @
@+++++++++++++++++++++++++++++@

// Check for common factors
if rows(fhat) >1 ; 
    
    if model[1] == 1 or model[1] == 3 or model[1] == 6;
        
        fhat = fhat - meanc(fhat)';
    elseif model[1] == 2 or model[1] == 4 or model[1] == 7;
        xreg =ones(t-1, 1)~seqa(1, 1, t-1);
        j = 1;
        do until j>cols(fhat);
            // Detrend for the deterministic
            fhat[., j] = fhat[., j]-xreg*(fhat[., j]/xreg);
            j = j + 1;
        endo;
    endif;
    
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
    
else;
    
    print "No common factors are detected";
    
endif;



print "**************************************************************************";
print "Compute CD test statistics for each p,  original EG cointegration residuals";
print "**************************************************************************";

CD_maxp = 12;
case = 1;
var_mat = original_coint_residual;
{a, b, c, d} = ips(var_mat, CD_maxp, case);

temp_t = rows(var_mat) - CD_maxp - 1;

i = 1;
do while i<= CD_maxp+1;
    res_p_mat = d[1+(i-1)*temp_t:(i)*temp_t, .];
    { cd_p, lm_p, lm_z, vect_corr } = cdlm(res_p_mat);
    { FR, pval_FR, FRE, FRE_cv, FRE_asymp } = csd_tests(res_p_mat);
    format /rd 8, 4;
    "p =";;
    i-1;;
    ":";;
    cd_p;;
    lm_p;;
    lm_z;;
    meanc(vect_corr[., 3]);;
    median(vect_corr[., 3]);;
    stdc(vect_corr[., 3]);;
    FR;;
    pval_FR;;
    FRE;;
    FRE_asymp;
    i = i + 1;
endo;



print "**************************************************************";
print "Compute CD test statistics for each p,  idiosyncratic residuals";
print "**************************************************************";

var_mat = mat_e_idio;

{ a, b, c, d } = ips(var_mat, CD_maxp, case);

temp_t = rows(var_mat) - CD_maxp - 1;
n_big = cols(var_mat)*(cols(var_mat) - 1)/2;

mat_corr = zeros(n_big, CD_maxp+1);


i = 1;
do while i <= CD_maxp+1;
    res_p_mat =d[1+(i-1)*temp_t:(i)*temp_t, .];
    { cd_p, lm_p, lm_z, vect_corr } = cdlm(res_p_mat);
    { FR, pval_FR, FRE, FRE_cv, FRE_asymp } = csd_tests(res_p_mat);
    format /rd 8, 4;
    "p =";;
    i-1;;
    ":";;
    cd_p;;
    lm_p;;
    lm_z;;
    meanc(vect_corr[., 3]);;
    median(vect_corr[., 3]);;
    stdc(vect_corr[., 3]);;
    FR;;
    pval_FR;;
    FRE;;
    FRE_asymp;
    mat_corr[., i] = vect_corr[., 3];
    i = i + 1;
endo;


pair = vect_corr[., 1:2];
x_out = ones(n_big, 1);

i = 1;
do while i<= CD_maxp+1;
    
    { res_studentized, DDFITS, indic_outlier, indic_influen, _beta, _beta_rob_out, _beta_rob_influen } = outlier_restud(mat_corr[., i], x_out, pair);
    print "CD and Rob-CD: " (_beta*sqrt(temp_t*n_big))~(_beta_rob_out*sqrt(temp_t*(n_big-rows(indic_outlier))))~(_beta_rob_influen*sqrt(temp_t*(n_big-rows(indic_influen))));
    
    i = i + 1;
endo;
