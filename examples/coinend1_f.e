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
cCtl.f = 4*rndn(bigt, 1);

// Method of testing
cCtl.method = "end";

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

result_array = arrayinit(ncross|2|10, 0);

// Cycle through all individuals
// and test separately
ind = unique(data[.,1]);
for i(1, rows(ind), 1);
    y = selif(data[., 2], data[., 1].==ind[i]);
    x = selif(data[., 3], data[., 1].==ind[i]);
    
    print "********************************";
    print "Test with endogenous break point";
    print "********************************";
    struct cointOut cOut;
    
    cOut = coint(y, x, cCtl);
    
    vec_out = cOut.eOut.vec_out;
    
    print "Test results for ";
    uniq_names[i];
    
    print "min(SC) test statistic: " vec_out[1, 1] "and estimated break point based on argmin(SC): "  vec_out[1,2];
    print "SC test statistic: " vec_out[2, 1] "and estimated break point based on argmin(SSR): "  vec_out[2,2];
    print;
    
    vc = valors(cCtl.model, cOut.eOut.vec_out[2, 2]/bigt, cols(x));
    print "Critical values for the SC test at the 10, 5, 2.5 and 1% level of significance";
    print "IMPORTANT: note that these critical values are for the SC test, not the min(SC) one";
    vc[5:8]';
    
    result_array[i, ., .] = vec_out~(ones(1,8)*error(0)|vc');
    print;
endfor;


