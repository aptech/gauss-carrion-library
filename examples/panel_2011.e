new;
cls;

library pgraph, carrionlib;
m1_T100 = loadd(__FILE_DIR $+ "m1.dat");
m2_T200 = loadd(__FILE_DIR $+ "m2.dat");
w = loadd(__FILE_DIR $+ "gdp.dat");
y = loadd(__FILE_DIR $+ "money.dat");
z = loadd(__FILE_DIR $+ "exch.dat");


maxlags = int((40)^(1/3));
maxfact = 6; @ Maximum number of factors that is allowed @
model = 2;

n = 18;
t = 94;
k = 3;


if model == 1;        /* 5% , only constant  */
    
    pval = m1_t100;
    mean_var = {0.50363233 0.29973853 ,
        0.09293090 0.00387378 ,
        0.04653255 0.00042435 ,
        0.03106941 0.00010149 ,
        0.02378946 0.00003807 ,
        0.01969598 0.00001723 };
    
    
elseif model == 2;        /* 5% , constant + trend  */
    
    pval = m2_t200;
    mean_var = {0.17829789 0.02079461 ,
        0.06172200 0.00108132 ,
        0.03708937 0.00019160 ,
        0.02696152 0.00005735 ,
        0.02160916 0.00002413 ,
        0.01831139 0.00001183 };
    
else;
    print "choose model 1 or 2";
endif;

size2 = zeros(1, k);
size_c2 = zeros(1, k);
size_c1 = zeros(1, k);
size_wu = zeros(1, k);

@ construct x=w[.,1]~y[.,1]~z[.,1]~w[.,2]~y[.,2]~z[.,2]~.....w[.,n]~y[.,n]~z[.,n] @ @ first columns din w,y,z ~ 2nd columns din w,y,z, ~ etc  @


x = w[., 1];
x = x~y[., 1];
x = x~z[., 1];

i = 2;
do while i <= n;
    x = x~w[., i];
    x = x~y[., i];
    x = x~z[., i];
    i = i + 1;
endo;

big_x=x;
{ e, Fhat } = factcoint_orig(BIG_X, model, maxfact|1);

fhat1 = detrend_carrion(fhat, 1);

// Non-parametric test
{ mq_non, nr_fact_non } = MQ_test(fhat1, model, N, 0); 

// Parametric test
{ mq_par ,nr_fact_par } = MQ_test(fhat1, model, N, 1); 

print;
print "MQ_test non-parametric and the number of non-stationary factors";
mq_non;
nr_fact_non;
print;
print "MQ_test parametric and the number of non-stationary factors";
mq_par;
nr_fact_par;
print;

// Parametric test
{ mqc_test, nr_fact_c } = MQ_test_c(fhat1, model, N); 

print "MQ_test_c and the number of non-stationary factors";
mqc_test;
nr_fact_c;
print;

mat_msb = zeros(n, k);
indiv_r = zeros(n, 1);
indiv_msb = zeros(n, 1);
vec_pv = zeros(k, 1);
mat_pv = zeros(n, k);

i_n = 1;
do until i_n > N;
    // The variables for the i-th individual
    vec_e_i = e[., k*(i_n-1)+1:i_n*k]; @  @
    { dd_test, r1, mat_l } = msb_min(vec_e_i, model);
    mat_msb[i_n, .] = mat_l';
    
    i = 1;
    do while i<=k;
        pval_i = pvalue(mat_l[i], k-i+1, pval);
        vec_pv[i] = pval_i;
        i = i + 1;
    endo;
    
    mat_pv[i_n, .] = vec_pv';
    indiv_msb[i_n, .] = DD_TEST;
    indiv_r[i_n, 1]= k - r1;
    i_n = i_n + 1;
endo;

panel_c1=-(sumc(ln(mat_pv))+n)/sqrt(n);
panel_msb=sqrt(n)*(meanc(mat_msb)-rev(mean_var[1:k,1]))./sqrt(rev(mean_var[1:k,2]));
panel_wu=-2*sumc(ln(mat_pv));
panel_c2=(sumc(cdfni(mat_pv)))/sqrt(n);
cv_wu=cdfchii(.95,2*n);

// Initial value for the number of stochastic trends
r = k; 
ii = 1;
do until ii>k;
    
    if ii==1;
        if panel_msb[ii] < -1.645;
            // Cointegrating rank
            r = r-1;
            size2[., ii] = 1;
        endif;
    else;
        if size2[.,ii-1] .ne 0; @ We have rejected in the previous test @
            if panel_msb[ii] < -1.645;
                // Cointegrating rank
                r = r-1; 
                size2[., ii] = 1;
            endif;
        endif;
    endif;
    ii = ii + 1;
endo;
r_msb = r;

rr = k; @ Initial value for the number of stochastic trends @
ii = 1;
do until ii>k;
    
    if ii==1;
        if panel_c2[ii] < -1.645;
            // Cointegrating rank
            rr = rr-1; 
            size_c2[., ii] = 1;
        endif;
    else;
        if size_c2[., ii-1] .ne 0; 
            if panel_c2[ii] < -1.645;
                // Cointegrating rank
                rr = rr-1;
                size_c2[., ii] = 1;
            endif;
        endif;
    endif;
    ii = ii + 1;
endo;
r_c2 = rr;

// Initial value for the number of stochastic trends
r1 = k;
ii = 1;
do until ii>k;
    
    if ii==1;
        if panel_c1[ii] > 1.645;
            //  Cointegrating rank
            r1 = r1 - 1; 
            size_c1[., ii] = 1;
        endif;
    else;
        if size_c1[.,ii-1] .ne 0; 
            if panel_c1[ii] > 1.645;
                // Cointegrating rank
                r1 = r1-1; 
                size_c1[., ii] = 1;
            endif;
        endif;
    endif;
    ii = ii + 1;
endo;
r_c1 = r1;

// Initial value for the number of stochastic trends
r2 = k;
ii = 1;
do until ii>k;
    
    if ii == 1;
        if panel_wu[ii] > cv_wu;
            
            r2 = r2 - 1; 
            size_wu[., ii] = 1;
        endif;
    else;
        if size_c2[., ii-1] .ne 0; @ We have rejected in the previous test @
            if panel_wu[ii] > cv_wu;
                // Cointegrating rank
                r2 = r2 - 1; 
                size_wu[., ii] = 1;
            endif;
        endif;
    endif;
    ii=ii+1;
endo;

r_wu = r2;


print "Model:  ";
model;
print "panel MSB rank:  ";
k-r_msb;
print "panel Maddala_Wu rank:  ";
k-r_wu;
print "panel C1 rank:  ";
k-r_c1;
print "panel C2 rank:  ";
k-r_c2;

print "Country and cointegration rank";;
indiv_r;
if cols(Fhat)==1 and Fhat == 0;
    a=0;
    print "Number of factors: " 0;
else;
    print "Number of factors: " cols(Fhat);
endif;

print "tests";

panel_msb;
panel_wu;
panel_c1;
panel_c2;
print "countries";
mat_msb;



@++++++++++++++++++++++++++++++++@
@ Analysis of the common factors @
@++++++++++++++++++++++++++++++++@
fhat = detrend_fact(fhat, model, t);

// Non-parametric test
{ mq_non, nr_fact_non } = MQ_test(fhat1, model, N, 0); 

//Parametric test
{ mq_par, nr_fact_par } = MQ_test(fhat1, model, N, 1);

print;
print "MQ_test non-parametric and the number of non-stationary factors";
mq_non;
nr_fact_non;
print;
print "MQ_test parametric and the number of non-stationary factors";
mq_par;
nr_fact_par;
print;

// Analysis for the estimated factors using the MSB statistic 
{ dd_test_fhat, r1_fhat, mat_l_fhat } = msb_min(fhat, model);
print "I(1) Common factors: " r1_fhat;
print "MSB_tau_f:  " dd_test_fhat;


plotXY(seqa(1,1,rows(fhat)), fhat);

// Set up plots
struct plotControl myPlot;
myPlot = plotGetDefaults("XY");

plotOpenWindow();
plotSettitle(&myPlot, "GDP");
plotXY(myPlot, seqa(1973, 0.3, T), w);

plotOpenWindow();
plotSettitle(&myPlot,"M1");
plotXY(myPlot, seqa(1973, 0.3, T), y);

plotOpenWindow();
plotSettitle(&myPlot,"Exchange rates");
plotXY(myPlot, seqa(1973, 0.3, T), z);
