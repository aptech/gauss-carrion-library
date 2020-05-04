new;
cls;
library carrionlib;


// Load GDP data
data_test = loadd("gdp.dat"); 

// Set up data
y = data_test;
n = cols(y);
T = rows(y);

// Set model to include both individual
// and time effects
model = 2;

// Set vector for common factor
// k[1] --> maximum number of factors
// k[2] --> set number of common factor to be unknown
k = 6|1;

// Get factors
// The factcoint_orig test is to be 
// used when there are no exogenous 
// variables
{ e, Fhat } = factcoint_orig(y, model, k);

// Detrend the factors
fhat = detrend_fact(fhat, 2, T);

// Storage matrices
prova_np = zeros(2, 1);
prova_p = zeros(2, 1);

// Non-parametric test MQ test [Bai and Ng]
{ prova_np[1], prova_np[2] } = MQ_test(fhat, model, N, 0); 

// Parametric test MQ test [Bai and Ng]
{ prova_p[1], prova_p[2] } = MQ_test(fhat, model, N, 1); 

print "Parametric test results: "; prova_p;
print "Non parametric test results: "; prova_np;

