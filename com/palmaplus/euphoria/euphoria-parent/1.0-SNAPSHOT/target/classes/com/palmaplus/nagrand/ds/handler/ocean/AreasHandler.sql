SELECT
  ST_AsText("Shape"."Shape") AS "Shape",
  ST_AsText(ST_Transform("Shape"."Shape", 4326)) AS "IndexedShape",
  "Shape"."MaximumScale",
  "Shape"."MinimumScale",
  "Area"."ID",
  "Area"."LocationID",
  "Area"."PlanarGraphID",
  (SELECT DISTINCT
     CASE 	WHEN EXISTS(SELECT 1 FROM ocean."Building" WHERE "ID" = "Area"."LocationID") THEN 'BUILDING'
     WHEN EXISTS(SELECT 1 FROM ocean."Floor" WHERE "ID" = "Area"."LocationID") THEN 'FLOOR'
     WHEN EXISTS(SELECT 1 FROM ocean."PlanarGraph" WHERE "ID" = "Area"."LocationID") THEN 'PLANAR_GRAPH'
     WHEN EXISTS(SELECT 1 FROM ocean."Facility" WHERE "ID" = "Area"."LocationID") THEN 'FACILITY'
     ELSE 'LOCATION'
     END) AS "LocationType",
  "POI"."ID" AS "POIID",
  "POIL"."Name",
  "POI"."EnglishName",
  "POI","CommonArea",
  "POIL"."Display",
  "POI"."Logo",
  "LocationL"."Address",
  (SELECT "CategoryID" FROM ocean."POI_Category" WHERE "POIID"="POI"."ID" ORDER BY "CategoryID" ASC LIMIT 1) AS "CategoryID"
FROM
  ocean."Area"
  LEFT JOIN ocean."Shape" ON "Area"."ID"="Shape"."AreaID"
  LEFT JOIN ocean."Location" ON "Area"."LocationID"="Location"."ID"
  LEFT JOIN zh_cn."LocationL" ON "Location"."ID"="LocationL"."ID"
  LEFT JOIN ocean."POI" ON "Location"."POIID"="POI"."ID"
  LEFT JOIN zh_cn."POIL" ON "POI"."ID"="POIL"."ID"
WHERE "Area"."PlanarGraphID" = ?
ORDER BY "Shape"."Level" ASC, "Area"."LocationID" ASC;