SELECT
  "ID", "LocationID", ST_AsText("AngleLine") as "AngleLine",
  CASE
    WHEN EXISTS(SELECT 1 FROM ocean."Building" WHERE "ID" = M."LocationID")
      THEN (
        SELECT ST_AsText(ST_PointOnSurface("Shape"."Shape"))
        FROM ocean."Location"
          INNER JOIN ocean."Frame" ON "Location"."ID" = "Frame"."PlanarGraphID"
          INNER JOIN ocean."Shape" ON "Frame"."ID" = "Shape"."FrameID"
					INNER JOIN ocean."Location_Parent" on "Location"."ID" = "Location_Parent"."LocationID"
        WHERE "Location_Parent"."ParentID" = M."LocationID"
        LIMIT 1
      )
    WHEN EXISTS(SELECT 1 FROM ocean."PlanarGraph" WHERE "ID" = M."LocationID")
      THEN (
        SELECT ST_AsText(ST_PointOnSurface("Shape"."Shape"))
        FROM ocean."PlanarGraph"
          INNER JOIN ocean."Frame" ON "PlanarGraph"."ID" = "Frame"."PlanarGraphID"
          INNER JOIN ocean."Shape" ON "Frame"."ID" = "Shape"."FrameID"
        WHERE "PlanarGraph"."ID" = M."LocationID"
        LIMIT 1
      )
    ELSE NULL
  END AS "Shape"
FROM ocean."Map" AS M
WHERE M."ID" = ?;