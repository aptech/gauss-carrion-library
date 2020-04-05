Data files and code for the paper "Cointegration and panel data with breaks and cross-section dependence”, written by Anindya Banerjee and Josep Lluís Carrion-i-Silvestre.

Barcelona, July 10th, 2013


The zipped file is organized as follows:

* Data folder.  This contains the ASCII data for ten countries (one file for each country) on the logarithm of import prices (lm?), foreign prices (lf?) and exchange rate against the US dollar. The question mark denotes the sector, which can take values from 0 to 8. See the companion appendix for further details.
				
* Program folder. Here we present the GAUSS procedures that are used to obtain the results. Practitioners do not need to change anything of the content of these files. There is an explanation of the sintaxis used for each procedure on these files.
				  
* brkfactors_heterog.gss GAUSS program that computes the panel data cointegration test statistic allowing for one structural break.

* brkfactors_heterog_2sb.gss GAUSS program that computes the panel data cointegration test statistics allowing for two structural breaks.

* brkfactors_heterog_minSSR_iter.gss GAUSS program that estimates the cointegration relationship for each unit, assuming that cointegration holds and accounting for one structural break.

* brkfactors_heterog_minSSR_iter_2sb.gss GAUSS program that estimates the cointegration relationship for each unit, assuming that cointegration holds and accounting for two structural breaks.

