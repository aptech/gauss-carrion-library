new;
cls;

library carrionlib;

/*
** This section 
** generates data for testing
*/

// Number of observations
T = 200;

// Location of break
lambda1 = 0.5;

// Find break point
tb1 = int(lambda1*t);

//  Break in mean
du1 = zeros(tb1, 1)|ones(t-tb1, 1);

//  Break in trend
dt1 = zeros(tb1, 1)|seqa(1, 1, t-tb1);

// Generate error term
v = rndn(t, 1);    

// Storage matrix
u = zeros(t, 1);

// Persistence
alpha = 1;

j = 2;
do until j>T;
    u[j] = alpha*u[j-1] + v[j];
    j = j + 1;
endo;

y = DT1 + u; @ DGP @

/*
** This section sets parameters 
** for testing.
*/
// Set up control structure
struct msburControl msburCtl;
msburCtl = msburControlCreate();

// Number of breaks
msburCtl.numberBreaks = 1;

// Model to use
model = 3;

/*
** Estimation method
** when = 1 we use the algorithm, 
** and = 0 brut force
*/
msburCtl.estimation = 1;
msburCtl.maxIters = 20;

// Output structure
struct msburOut msOut;
msOut = msbur_gls(y, model, msburCtl);

@+++++++++++++++++++++++++++++@
@ Compute the critical values @
@+++++++++++++++++++++++++++++@

lam = (msOut.min_tb/T)|zeros(4, 1); @ Only one break @
{critical_msb, critical_mza, critical_mzt, critical_pt} = msbur_rs(lam, msOut.cbar);

print "Test statistics and critical values (5% levelof significance)";

print "PT test " msOut.pt "cv(5%): " critical_pt[3];
print "MPT test " msOut.mpt "cv(5%): " critical_pt[3];
print "ADF test " msOut.adf "cv(5%): " critical_mzt[3];
print "ZA test " msOut.za "cv(5%): " critical_mza[3];
print "MZA test " msOut.mza "cv(5%): " critical_mza[3];
print "MSB test " msOut.msb "cv(5%): " critical_msb[3];
print "MZT test " msOut.mzt "cv(5%): " critical_mzt[3];
