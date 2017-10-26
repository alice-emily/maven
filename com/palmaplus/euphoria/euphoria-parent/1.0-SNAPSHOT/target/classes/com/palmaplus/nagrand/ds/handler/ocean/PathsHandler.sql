SELECT
ST_AsText("Shape"."Shape") AS "Shape",
"Path"."ID",
"Path"."PlanarGraphID",
"Path"."Direction",
"Path"."Rank"
FROM
ocean."Path"
LEFT JOIN ocean."Shape" ON "Path"."ID" = "Shape"."PathID"
WHERE "Path"."PlanarGraphID" = ?