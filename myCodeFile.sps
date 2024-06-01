SET DECIMAL=DOT.

DATA LIST FILE= "myData.csv"  free (",")
ENCODING="Locale"
/ geschl nudelmag groe gewi filmemag nudelso alter 
  .

VARIABLE LABELS
geschl "geschl" 
 nudelmag "nudelmag" 
 groe "groe" 
 gewi "gewi" 
 filmemag "filmemag" 
 nudelso "nudelso" 
 alter "alter" 
 .
VARIABLE LEVEL geschl, nudelmag, groe, gewi, filmemag, nudelso, alter 
 (scale).

EXECUTE.
