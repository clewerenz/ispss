
SET DECIMAL=DOT.

* IMPORT DATA FROM FILE *

GET DATA
 /TYPE=TXT
 /FILE='output/myData.dat'
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
 date F8.0
 test A25
.

* ---------------------------------------------------------------- *

DATASET NAME myData.
DATASET ACTIVATE myData.

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
 date "Erhebungsdatum"
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

VALUE LABELS test
 "A" "AA"
 "B" "BB"
.

EXECUTE.

* ---------------------------------------------------------------- *

* SET MISSING RANGE

MISSING VALUES alter (-9 THRU -1).

EXECUTE.

* ---------------------------------------------------------------- *

* SET MISSING VALUES *

MISSING VALUES groe (-9, -8, -7).
MISSING VALUES gewi (-9, -8).
MISSING VALUES nudelso (-9).

EXECUTE.

* ---------------------------------------------------------------- *

