new;
cls;
library carrionlib;

// Load data
test_data = loadd(__FILE_DIR $+ "brics.xlsx", "lco2");

// Time periods
bigt = 29;
ncross = rows(test_data)/bigT;

// Create wide panel data
lco2_wide = reshape(test_data, ncross, bigT)';

// Number of breaks
m = 3;        

// Model
model = 4|m|1|1|2;

// Set the number of factors
k = 2;

// Number of maximum factors to allow
// and estimation method
kmax = 3|1;

// AR degress
p_ar = 0;

// Datevec
datevec = 0;

{ Z_test, test_n, test_chi, Z_test_sim, test_n_sim, test_chi_sim, fhat } = panelbreak(lco2_wide, model, p_ar, kmax, datevec);

print "Z test: " Z_test;
print "Pval (normal): " test_n;
print "Pval (Chi-square): " test_chi;
print;

print "Simplified tests";
print "Z test: " Z_test_sim;
print "Pval (normal): " test_n_sim;
print "Pval (Chi-square): " test_chi_sim;

