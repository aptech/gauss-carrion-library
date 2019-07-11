new;
cls;
library carrionlib;

/*
** Load results matrices from 
** factcoint
*/
fhat = loadd(__FILE_DIR $+ "fhat.fmt");
mat_e_idio = loadd(__FILE_DIR $+ "mat_e_idio.fmt");
csi = loadd(__FILE_DIR $+ "csi.fmt");

/* 
** Method to correct for the autoregressive squemes.
** method  == 0 for exogenous (fixed),
** and  ==1 for endogenous (t-sig)
*/
method = 1; 
p_max = 12;

// Count number of rows
n = cols(mat_e_idio);

// Matrix to store the individual ADF statistics
m_adf  = zeros(n, 1);

j = 1;
do until j>n;
    // ADF test onto the idiosyncratic disturbances
    {t_adf, rho_adf, p} = ADFRC(mat_e_idio[., j], method, p_max);
    m_adf[j] = t_adf;
    j = j + 1;
endo;
