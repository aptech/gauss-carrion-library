new;
cls;



load france[123,19]=z:\france.txt;
load netherlands[123,19]=z:\netherlands.txt;
load germany[123,19]=z:\germany.txt;
load italy[123,19]=z:\italy.txt;
load ireland[123,19]=z:\ireland.txt;
load greece[123,19]=z:\greece.txt;
load portugal[120,19]=z:\portugal.txt; @ Looses 3 observations at the end @
load spain[123,19]=z:\spain.txt;
load finland[123,19]=z:\finland.txt;
load austria[120,19]=z:\austria.txt; @ Looses 3 observations at the end @


load year_month[123,2]=z:\year_month.txt;
year=year_month[.,1];
month=year_month[.,2];



lpm_france = france[.,1:9];
lfp_france = france[.,10:18];
e_france = france[.,19].*ones(rows(lfp_france),cols(lfp_france));

lpm_netherlands = netherlands[.,1:9];
lfp_netherlands = netherlands[.,10:18];
e_netherlands = netherlands[.,19].*ones(rows(lfp_netherlands),cols(lfp_france));

lpm_germany = germany[.,1:9];
lfp_germany = germany[.,10:18];
e_germany = germany[.,19].*ones(rows(lfp_germany),cols(lfp_germany));

lpm_italy = italy[.,1:9];
lfp_italy = italy[.,10:18];
e_italy = italy[.,19].*ones(rows(lfp_italy),cols(lfp_italy));

lpm_ireland = ireland[.,1:9];
lfp_ireland = ireland[.,10:18];
e_ireland = ireland[.,19].*ones(rows(lfp_ireland),cols(lfp_ireland));

lpm_greece = greece[.,1:9];
lfp_greece = greece[.,10:18];
e_greece = greece[.,19].*ones(rows(lfp_greece),cols(lfp_greece));

lpm_portugal = portugal[.,1:9];
lfp_portugal = portugal[.,10:18];
e_portugal = portugal[.,19].*ones(rows(lfp_portugal),cols(lfp_portugal));

lpm_spain = spain[.,1:9];
lfp_spain = spain[.,10:18];
e_spain = spain[.,19].*ones(rows(lfp_spain),cols(lfp_spain));

lpm_finland = finland[.,1:9];
lfp_finland = finland[.,10:18];
e_finland = finland[.,19].*ones(rows(lfp_finland),cols(lfp_finland));

lpm_austria = austria[.,1:9];
lfp_austria = austria[.,10:18];
e_austria = austria[.,19].*ones(rows(lfp_austria),cols(lfp_austria));



@+++++++++++++++++++++++++++++++++++++++++++++++++++++@
@ Estimation of the model allowing for common factors @
@+++++++++++++++++++++++++++++++++++++++++++++++++++++@

model=7|1;
k=12|1;

method=1; @ Method to correct for the autoregressive squemes. method == 0 for exogenous (fixed), and ==1 for endogenous (t-sig) @
p_max=12;

klags=0;
kleads=0;
estima=1|klags|kleads; @ Method of estimation: estima[1] == 1 for OLS and == 2 for DOLS; estima[2:3] collects the lags and leads for the DOLS @


/* Empirical moments of the distribution obtained for T=100 and 100,000 replications */
if model[1] == 1 or model[1] == 3 or model[1] == 6;
    mean_t = -0.41632799;
    var_t = 0.98339487;
elseif model[1] == 2 or model[1] == 4 or model[1] == 7;
    mean_t = -1.5377067;
    var_t = 0.35005403;
elseif model[1] ==5 or model[1] == 8;
    mean_t = {-1.6803178,
            -1.8163351,
            -1.9198423,
            -1.9805257,
            -1.998013,
            -1.9752734,
            -1.9125286,
            -1.816865,
            -1.6755147}; @ Each row for different values of lambda @
    
    var_t = {0.40488013,
            0.41454518,
            0.40165997,
            0.36829752,
            0.35833849,
            0.36808259,
            0.39040626,
            0.4229098,
            0.39749512}; @ Each row for different values of lambda @
endif;




print "
@++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++@
@ Analysis for the longest panel data set (i.e. excluding Portugal, Finland and Austria) @
@++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++@";

lpm = lpm_france~lpm_netherlands~lpm_germany~lpm_italy~lpm_ireland~lpm_greece~lpm_spain;
lfp = lfp_france~lfp_netherlands~lfp_germany~lfp_italy~lfp_ireland~lfp_greece~lfp_spain;
e = e_france~e_netherlands~e_germany~e_italy~e_ireland~e_greece~e_spain;
