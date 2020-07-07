new;
cls;

library carrionlib;

/*
** This section loads data
** note this test is a time series test
** we will test each individual in the panel
** separately
*/
// Here we load all data for testing
// Note that this dataset is stacked
// and the cadfcoin_multiple procedure
// requires wide panel data
y = loadd(__FILE_DIR $+ "gdp.dat", "GDP_1");
t = rows(y);

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
