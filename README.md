# gauss-carrion-library

## What is GAUSS?
[**GAUSS**](www.aptech.com) is an easy-to-use data analysis, mathematical and statistical environment based on the powerful, fast and efficient **GAUSS Matrix Programming Language**. [**GAUSS**](www.aptech.com) is a complete analysis environment with the built-in tools you need for estimation, forecasting, simulation, visualization and more.

## What is the GAUSS carrion library?
The [**GAUSS**](www.aptech.com) carrion library is a collection of [**GAUSS**](www.aptech.com) codes developed by [Josep Carrion-i-Silvestre](https://webgrec.ub.edu/webpages/personal/ang/000698_carrion.ub.edu.html). The [raw codes](https://webgrec.ub.edu/webpages/personal/ang/000698_carrion.ub.edu.html) provided by Carrion-i-Silvestre have been modified to make use of [**GAUSS**](www.aptech.com) structures.

## Getting Started
### Prerequisites
The program files require a working copy of [**GAUSS 18+**](www.aptech.com). Many can be run on earlier versions with some small revisions.

### Installing
**GAUSS 20+**
The GAUSS Carrion library can be installed and updated directly in GAUSS using the [GAUSS package manager](https://www.aptech.com/blog/gauss-package-manager-basics/).

**GAUSS 18+**
The GAUSS Carrion library can be easily installed using the [**GAUSS Application Installer**](https://www.aptech.com/support/installation/using-the-applications-installer-wizard/), as shown below:

1. Download the zipped folder `carrionlib.zip` from the [Carrion Library Release page](https://github.com/aptech/gauss-carrion-library/releases).
2. Select **Tools > Install Application** from the main **GAUSS** menu.  
![install wizard](images/install_application.png)  

3. Follow the installer prompts, making sure to navigate to the downloaded `carrionlib.zip`.
4. Before using the functions created by `carrionlib` you will need to load the newly created `carrionlib` library. This can be done in a number of ways:
  *   Navigate to the **Library Tool Window** and click the small wrench located next to the `carrionlib` library. Select `Load Library`.  
  ![load library](images/load_carrionlib.jpg)
  *  Enter `library carrionlib` in the **Program Input/output Window**.
  *  Put the line `library carrionlib;` at the beginning of your program files.

>Note: I have provided the individual files found in `carrionlib.zip` for examination and review. However, installation should always be done using the [`carrionlib.zip` from the release page](https://github.com/aptech/gauss-carrion-library/releases) and the [**GAUSS Application Installer**](https://www.aptech.com/support/installation/using-the-applications-installer-wizard/).

## Supported

|src file| Reference| Example File | Procedures |
|:------:|:---------|:-------------|:-------------|
|rsperron.src| [Carrion-i-Silvestre, JL; Samson, A.; Artís, M. (1999).](https://www.sciencedirect.com/science/article/abs/pii/S0165176599000440) Response surfaces estimates for the Dickey-Fuller unit root test with structural breaks. Economics Letters, 63, pp. 279 - 283 .| None | `coint`, `valors`|
|icss.src| [Samson, A ..; Aragon, V.; Carrion-i-Silvestre, JL (2004).](https://core.ac.uk/download/pdf/6509165.pdf). Testing for changes in the unconditional variance of financial time series. Revista de Economía Financiera, 4, pp. 32 - 53.| [icss.e](examples/icss.e) | `icss` |
|coikpss.src| [Carrion-i-Silvestre, JL; Sansó, A. (2006).](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1468-0084.2006.00180.x) Testing the null of cointegration with structural breaks. Oxford Bulletin of Economics and Statistics, 68, pp. 623 - 646 . | [coinend1.e](examples/coinend1.e), [coinkpss1.e](examples/coinkpss1.e)| `coint`, `valors`|
|msbur.src| [Carrion-i-Silvestre, JL; Kim, D.; Perron, P. (2009).](https://www.cambridge.org/core/journals/econometric-theory/article/glsbased-unit-root-tests-with-multiple-structural-breaks-under-both-the-null-and-the-alternative-hypotheses/9159BB7FBC1E1D0A6AE25C827A9CDB18) GLS-based unit root tests with multiple structural breaks under both the null and alternative hypotheses. Econometric Theory, 25, pp. 1754 - 1792 .| [msbur.e](examples/msbur.e)| `panelbreak`|
|brcode2_noprint.src, panicbrk.src| [Bai, J.; Carrion-i-Silvestre, JL (2009).](https://www.jstor.org/stable/40247611?seq=1)Structural changes, common stochastic trends, and unit roots in panel data. The Review of Economic Studies, 76, pp. 471 - 501 .| [panelbrk.e](examples/panelbrk.e)| `msbur_gls`|
|brkcoint.src| [Bai, J.; Carrion-i-Silvestre, J.L. (2013).](https://academic.oup.com/ectj/article-abstract/16/2/222/5060519?redirectedFrom=PDF) Testing panel cointegration with unobservable dynamic common factors that are correlated with the regressors. Econometrics Journal, 16, pp. 222 - 249 . | [adfrc.e](examples/adfrc.e), [coinend1_f.e](examples/coinend1_f.e), [coinkpss1_f.e](examples/coinkpss1_f.e)  | `coint`|
|brkcoint.src| [Banerjee, A.; Carrion-i-Silvestre, JL (2015) .](https://www.ecb.europa.eu/pub/pdf/scpwps/ecbwp591.pdf) Cointegration in panel data with structural breaks and cross-section dependence. Journal of Applied Econometrics, 30 (1), pp. 1 - 23. | [mqtest.e](examples/mqtest.e), [brkfactors_heterog1.e](examples/brkfactors_heterog1.e), [brkfactors_heterog_minSSR_iter.e](examples/brkfactors_heterog_minSSR_iter.e)  | `factcoint_iter`, `MQ_test`|
|code09.src|[Carrion-i-Silvestre, JL; Surdeanu, L. (2011).](https://www.nottingham.ac.uk/research/groups/grangercentre/documents/confs/paper-carrion-june-2007.pdf) Panel cointegration rank test with cross-section dependence. Studies in Nonlinear Dynamics & Econometrics, 15 (4).| [mqtest_gdp.e](examples/mqtest_gdp.e), [mqtest_money.e](examples/mqtest_money.e), [panel_2011.e](examples/panel_2011.e)  | `msb_min`, `msb`|
|pu_mp.src|[Moon and Perron (2004).](https://www.sciencedirect.com/science/article/abs/pii/S0304407603002707) Testing for unit root in panels with dynamic factors. Journal of Econometrics, 122 (1). | [pu_gdp.e](examples/pu_gdp.e), [pu_money.e](examples/pu_money.e) | `pu_mp04` |
## Authors
[Erica Clower](mailto:erica@aptech.com)  
[Aptech Systems, Inc](https://www.aptech.com/)  
[![alt text][1.1]][1]
[![alt text][2.1]][2]
[![alt text][3.1]][3]

<!-- links to social media icons -->
[1.1]: https://www.aptech.com/wp-content/uploads/2019/02/fb.png (Visit Aptech Facebook)
[2.1]: https://www.aptech.com/wp-content/uploads/2019/02/gh.png (Aptech Github)
[3.1]: https://www.aptech.com/wp-content/uploads/2019/02/li.png (Find us on LinkedIn)

<!-- links to your social media accounts -->
[1]: https://www.facebook.com/GAUSSAptech/
[2]: https://github.com/aptech
[3]: https://linkedin.com/in/ericaclower
<!-- Please don't remove this: Grab your social icons from https://github.com/carlsednaoui/gitsocial -->
