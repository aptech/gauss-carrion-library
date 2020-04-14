new;
cls;


// Declare control structurea
struct breakControl bCtl;

// Number of breaks
m = 3;        

// Model
model = 4|m|1|1|2;

// Set the number of factors
k = 2;

// Number of maximum factors to allow
// and estimation method
kmax = 6|1;

// AR degress
p_ar = 0;

// Datevec
datevec = 0;

// Generate data
bigt = 100;
x = cumsumc(rndn(bigt, 20));

{ Z_test, test_n, test_chi, Z_test_sim, test_n_sim, test_chi_sim, fhat } = panelbreak(x, model, p_ar, kmax, datevec);

print "Z test: " Z_test;
print "Pval (normal): " test_n;
print "Pval (Chi-square): " test_chi;
print;

print "Simplified tests";
print "Z test: " Z_test_sim;
print "Pval (normal): " test_n_sim;
print "Pval (Chi-square): " test_chi_sim;

