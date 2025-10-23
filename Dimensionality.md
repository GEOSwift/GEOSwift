# Dimensionality Notes

* `isValidReaon` only contains XY values because GEOSisValidReason_r only returns XY values
* It is common for geos to return nan values for Z/M coordinates. Double.nan != Double.nan so you cannot check equality with .nan coordinates. Instead cast to XY (i.e. XY(coordinate)) to test x/y equality.
* For topological tests (e.g. `isTopologicallyEquivalent`, `isDisjoint`, `intersects`) only X and Y coordinates are taken into account
* Binary topological operations (e.g. `intersection(with:)`, `union(with:)`) currently only return XY geometries. Higher dimension support coming soon.
* `convexHull` and `concaveHull` return XY goemetry.
* `minimumRotatedRectangle` returns XY geometry
* `minimumWidth` returns XY geometry
* More function documentation