SELECT
c."From" AS "FromLocationID",
c."To" AS "ToLocationID",
c."Direction",
ST_AsText(sf."Shape") AS "FromShape",
ff."PlanarGraphID" AS "FromPlanarGraphID",
tf."PlanarGraphID" AS "ToPlanarGraphID",
ST_AsText(st."Shape") AS "ToShape",
pc."CategoryID"
FROM ocean."Connection" AS c
INNER JOIN ocean."Facility" AS ff ON c."From" = ff."LocationID"
INNER JOIN ocean."Shape" AS sf ON sf."FacilityID" = ff."ID"
INNER JOIN ocean."Facility" AS tf ON tf."LocationID" = c."To"
INNER JOIN ocean."Shape" AS st ON tf."ID" = st."FacilityID"
INNER JOIN ocean."Location" l on c."From" = l."ID"
INNER JOIN ocean."POI_Category" pc on l."POIID" = pc."POIID"
WHERE ff."PlanarGraphID" IN (LIST_PARAMS) AND tf."PlanarGraphID" IN (LIST_PARAMS);