SELECT
  "Location"."ID",
  "Location"."POIID",
  (SELECT DISTINCT
     CASE 	WHEN EXISTS(SELECT 1 FROM ocean."Building" WHERE "ID" = "Location"."ID") THEN 'BUILDING'
     WHEN EXISTS(SELECT 1 FROM ocean."Floor" WHERE "ID" = "Location"."ID") THEN 'FLOOR'
     WHEN EXISTS(SELECT 1 FROM ocean."PlanarGraph" WHERE "ID" = "Location"."ID") THEN 'PLANAR_GRAPH'
     WHEN EXISTS(SELECT 1 FROM ocean."Facility" WHERE "LocationID" = "Location"."ID") THEN 'FACILITY'
     ELSE 'LOCATION'
     END) AS "Type",
  (SELECT DISTINCT "PlanarGraph"."ID" FROM ocean."PlanarGraph"
     JOIN ocean."Location_Parent" ON "Location_Parent"."LocationID" = "PlanarGraph"."ID"
     WHERE "PlanarGraph"."ID" = ANY("Location_Ancestors"."Ancestors") LIMIT 1) AS "PlanarGraphID",
  "LocationDeep"."Country",
  "LocationDeep"."RegionCode",
  "LocationDeep"."ZipCode",
  "LocationL"."Address",
  (SELECT ARRAY(SELECT "ParentID" AS "ID" FROM ocean."Location_Parent" WHERE "LocationID" = "Location"."ID")) AS "Parents",
  "Location_Ancestors"."Ancestors",
  "POI"."SpecialName",
  "POI"."EnglishName",
  "POI"."Logo",
  "POI"."CommonArea",
  "POIDeep"."Phone",
  "POIDeep"."Membership",
  "POIDeep"."Parking",
  "POIDeep"."ParkingSpace",
  "POIL"."Name",
  "POIL"."Display",
  "POIDeepL"."ParkingFee",
  "POIDeepL"."OpeningTime",
  "Floor"."DefaultFloor",
  "Floor"."Altitude",
  "Facility"."AreaLocationID",
  (SELECT ARRAY(SELECT "POI_TagL"."Tag" FROM zh_cn."POI_TagL" WHERE "POI_TagL"."POIID" = "Location"."POIID")) AS "Tags"
FROM
  ocean."Location"
  LEFT JOIN ocean."LocationDeep" ON "Location"."ID"="LocationDeep"."ID"
  LEFT JOIN ocean."Location_Ancestors" ON "Location"."ID"="Location_Ancestors"."LocationID"
  LEFT JOIN ocean."POI" ON "Location"."POIID"="POI"."ID"
  LEFT JOIN ocean."POIDeep" ON "POI"."ID"="POIDeep"."ID"
  LEFT JOIN ocean."Floor" ON "Location"."ID"="Floor"."ID"
  LEFT JOIN ocean."Facility" ON "Location"."ID"="Facility"."LocationID"
  LEFT JOIN zh_cn."LocationL" ON "Location"."ID"="LocationL"."ID"
  LEFT JOIN zh_cn."POIDeepL" ON "POIDeep"."ID"="POIDeepL"."ID"
  LEFT JOIN zh_cn."POIL" ON "POI"."ID"="POIL"."ID"
WHERE
  "Location"."ID"=?;