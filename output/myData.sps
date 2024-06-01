
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

DATASET NAME myDatadat.
DATASET ACTIVATE myDatadat.

* ---------------------------------------------------------------- *

* SET VARIABLE LABELS *

VARIABLE LABELS
 geschl "Geschlecht"
 nudelmag "Nudelmag"
 groe "Größe"
 gewi "Gewicht"
 filmemag "Filmemag"
 nudelso "Nudeln und Sosse"
 alter "Alter"
 state "Anmerkung"
 geschl_fac "Geschlecht 2"
.
EXECUTE.

* ---------------------------------------------------------------- *

* SET VALUE LABELS *

VALUE LABELS geschl
 1 "männlich"
 2 "weiblich"
.

VALUE LABELS nudelmag
 1 "sehr gerne"
 2 "gerne"
 3 "geht so"
 4 "überhaupt nicht gerne"
.

VALUE LABELS filmemag
 1 "sehr gerne"
 2 "gerne"
 3 "geht so"
 4 "überhaupt nicht gerne"
.

VALUE LABELS nudelso
 -9 "MFR"
 1 "ja"
 2 "nein"
.

VALUE LABELS geschl_fac
 1 "männlich"
 2 "weiblich"
.

EXECUTE.

* ---------------------------------------------------------------- *

