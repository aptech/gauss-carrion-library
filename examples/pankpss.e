/*
Lectura de la base de dades de PIB per capita
de Maddison.

Període: 1870-1994 per a 17 països (primera columna amb els anys).
*/

new;
cls;

library carrionlib;

// Load data
data = loadd(__FILE_DIR $+ "pankpss_data.dat");

// Print data headers
getheaders(__FILE_DIR $+ "pankpss_data.dat");

// Use for cross-sectional demeaning
// data=data-meanc(data)';


/*
** Calculation of the test with 1 change to the mean
*/

// Set kernal
kernel = 1|5;

// Maximum humber of structural changes allowed
m = 5;

// Model when there are no changes.
// Second model: individual effects + tendency
model0 = 2;

//  Model when there are changes.
// Changes in the mean and the slope
model = 4;

/*
** Settings for structural break estimation
*/
// Declare structural break control structure
struct breakControl bCtl;

// Set control structure members
// to default values
bCtl = breakControlCreate(bigt);

// Set to print the output from the iterations
bCtl.printd = 1;

// Option for construction of F-tests
//  Set to 1 if want to allow for the variance of the residuals
//  to be different across segments. If hetvar=0, the variance
//  of the residuals is assumed constant across segments
//  and constructed from the full sample. This option is not available
//  when robust = 1.
bCtl.hetvar = 1;

// Set to 1 if want to estimate the model with
// the number of breaks selected by BIC.
bCtl.estimbic = 1;

// Set to 1 if want to estimate the model with
// the number of breaks selected using the
// sequential procedure.
bCtl.estimseq = 0;

/*****************************************************************************/
/*****************************************************************************/
{ test_hom, test_het, kpsstest, num, den } = pankpss(data, bCtl);
