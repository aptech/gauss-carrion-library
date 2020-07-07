new;
cls;

library carrionlib;

format /rd 7,4;

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
data = loadd(__FILE_DIR $+ "brics.xlsx", "code +lco2 + ly");

// Load country names
ctry_names = loaddsa(__FILE_DIR $+ "brics.xlsx", "Country");
uniq_names = uniquesa(ctry_names);

// Time periods
bigt = 29;
ncross = rows(data)/bigT;

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
cCtl.model = 1;  /*  = 1  model An,
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
cCtl.breakPoint = 4;

result_mat = zeros(ncross, 9);

// Cycle through all individuals
// and test separately
ind = unique(data[.,1]);
for i(1, rows(ind), 1);
    y = selif(data[., 2], data[., 1].==ind[i]);
    x = selif(data[., 3], data[., 1].==ind[i]);
    
    struct cointOut cOut;
    
    cOut = coint(y, x, cCtl);
    
    print "Test results for ";
    uniq_names[i];
    
    print "SC statistic: " cOut.kOut.tests "for the break point located at: " cOut.kOut.t_b;
    print;
    
    vc = valors(cCtl.model, cOut.kOut.t_b/bigt, cols(x));
    print "Critical values for the SC test at the 10, 5, 2.5 and 1% level of significance";
    vc[5:8]';
    
    result_mat[i, .] = cOut.kOut.tests~vc';
    
    print;
endfor;
