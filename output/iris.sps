SET DECIMAL=DOT.

DATA LIST FILE= "iris.dat"  free (",")
ENCODING="Locale"
/ Sepal.Length Sepal.Width Petal.Length Petal.Width * Species (F8.0) 
  .

VARIABLE LABELS
Sepal.Length "Sepal.Length" 
 Sepal.Width "Sepal.Width" 
 Petal.Length "Petal.Length" 
 Petal.Width "Petal.Width" 
 Species "Species" 
 .

VALUE LABELS
/
Species 
1 "setosa" 
 2 "versicolor" 
 3 "virginica" 
.
VARIABLE LEVEL Sepal.Length, Sepal.Width, Petal.Length, Petal.Width 
 (scale).

EXECUTE.
