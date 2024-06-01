
SET DECIMAL=DOT.

* IMPORT DATA FROM FILE *

GET DATA
 /TYPE=TXT
 /FILE='/home/lnx/Documents/ispss/output/myData.dat'
 /ENCODING='UTF-8'
 /QUALIFIER='"'
 /ARRANGEMENT=DELIMITED
 /DELIMITERS='	'
 /DELCASE=LINE
 /FIRSTCASE=2
 /VARIABLES =
 geschl F8.0
 nudelmag F8.0
 groe F8.2
 gewi F8.0
 filmemag F8.0
 nudelso F8.0
 alter F8.0
 state A26
 geschl_fac F8.0
.

* ---------------------------------------------------------------- *

