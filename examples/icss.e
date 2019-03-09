/*****************************************
* Replicates the emprirical aplication in
* Sanso, Aragó & Carrion (2002): "Testing for changes in the unconditional 
* variance of financial time series"
*
*****************************************/
new;
cls;

library carrionlib;

cls;

/*
** criteria for the kappa_2 test: 
** spectral quadratic window and 
** automatic bandwidth selection
*/
cri = { 1, 1 };
cri = cri|4;
 
// Load the "Han" data (521 observations)
"HAN";
load x[521, 1] = han.dat;

// Demean data
e = x - meanc(x);

/*
** Set to use Inclant-Tiao test
*/
test=0;

// Call icss test
{ cpr, nbr } = icss(e, test, cri);
"Using inclant-tiao test";
print "Number of breaks" nbr;
print "Break positions" cpr';

/* 
** Uses the kappa_1 test 
** (corrects for non-mesokurtosis)
*/
test = 1; 

// Call Kappa 1 test
{ cpr, nbr } = icss(e, test, cri);
"Using kappa 1 test";
print "Number of breaks" nbr;
print "Break positions" cpr';

/*
** Uses the kappa_2 test
** (corrects for non-mesokurtosis and 
** persistence in conditional variance)
*/
test = 2;

// Call Kappa 2 test	
{ cpr, nbr } = icss(e, test, cri);
"using kappa 2 test";
print "Number of breaks" nbr;
print "Break positions" cpr';

// Load the "SP" data (521 observations)
load x[521, 1] = sp.dat;
"SP";

// Demean the data
e = x - meanc(x);

/*
** Set to use Inclant-Tiao test
*/
test = 0;

// Call icss test
{ cpr, nbr } = icss(e, test, cri);
print "Number of breaks" nbr;
print "Break positions" cpr';

/* 
** Uses the kappa_1 test 
** (corrects for non-mesokurtosis)
*/
test = 1;

// Call icss test
{ cpr, nbr } = icss(e, test, cri);
print "Number of breaks" nbr;
print "Break positions" cpr';

/* 
** Uses the kappa_2 test 
** (corrects for non-mesokurtosis)
*/
test = 2;

// Call icss test
{ cpr, nbr } = icss(e, test, cri);
print "Number of breaks" nbr;
print "Break positions" cpr';

// Load the "FTSE" data (473 observations)
load x[473, 1] = ftse.dat;
"FTSE";

// Demean the data
e = x - meanc(x);

/*
** Set to use Inclant-Tiao test
*/
test = 0;
{ cpr, nbr } = icss(e, test, cri);
print "Number of breaks" nbr;
print "Break positions" cpr';

/* 
** Uses the kappa_1 test 
** (corrects for non-mesokurtosis)
*/
test = 1;
{ cpr, nbr } = icss(e, test, cri);
print "Number of breaks" nbr;
print "Break positions" cpr';

/* 
** Uses the kappa_2 test 
** (corrects for non-mesokurtosis)
*/
test = 2;
{ cpr, nbr } = icss(e, test, cri);
print "Number of breaks" nbr;
print "Break positions" cpr';

// Load the "FTSE" data (473 observations)
load x[466, 1] = nik.dat;
"NIK";

// Demean the data
e = x - meanc(x);

/*
** Set to use Inclant-Tiao test
*/
test = 0;
{ cpr, nbr } = icss(e, test, cri);
print "Number of breaks" nbr;
print "Break positions" cpr';

/* 
** Uses the kappa_1 test 
** (corrects for non-mesokurtosis)
*/
test = 1;
{ cpr, nbr } = icss(e, test, cri);
print "Number of breaks" nbr;
print "Break positions" cpr';

/* 
** Uses the kappa_2 test 
** (corrects for non-mesokurtosis)
*/
test = 2;
{ cpr, nbr } = icss(e, test, cri);
print "Number of breaks" nbr;
print "Break positions" cpr';





