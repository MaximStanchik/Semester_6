CREATE EXTENSION postgis;
SELECT PostGIS_Version();

-- 5. Скопируйте в свою базу данных таблицы, содержащие пространственные данные
SELECT * FROM "LakeCounty_Health";

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'LakeCounty_Health'; 

SELECT * FROM "Erreichbarkeit_auf";

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'Erreichbarkeit_auf'; 

SELECT * FROM "gadm41_SYR_2"; 

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'gadm41_SYR_2'; 

-- 6. Определите тип пространственных данных во всех таблицах
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public';

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name = 'vehicle'; 

select * from Vehicle;

-- 7. Определите SRID
SELECT srid FROM geometry_columns;

SELECT * FROM geometry_columns;
SELECT * FROM information_schema.tables
WHERE table_name = 'geometry_columns';
SELECT * FROM "gadm41_SYR_2"; 
select * from geometry_columns;

-- 8. Определите атрибутивные столбцы
SELECT COLUMN_NAME, TABLE_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND DATA_TYPE != 'geometry';

-- 9. Верните описания пространственных объектов в формате WKT
SELECT ST_AsText(geom) AS WKT_Description
FROM "gadm41_SYR_2";  

-- 10. Продемонстрируйте:
select * from "gadm41_SYR_2";

-- 10.1. Нахождение пересечения пространственных объектов;
SELECT 
    a."GID_2" AS gid_a, 
    b."GID_2" AS gid_b, 
    ST_Intersection(a."geom", b."geom") AS intersection_geom
FROM 
    "gadm41_SYR_2" AS a, 
    "gadm41_SYR_2" AS b
WHERE 
    a."GID_2" <> b."GID_2"  
    AND ST_Intersects(a."geom", b."geom");
   
-- 10.2. Нахождение координат вершин пространственного объектов;
SELECT 
    id,
    ST_AsText(geom) AS coordinates
FROM 
    "gadm41_SYR_2";
   
-- 10.3. Нахождение площади пространственных объектов;
   SELECT 
    id,
    ST_Area(geom) AS area
FROM 
    "gadm41_SYR_2";
   
-- 11. Создайте пространственный объект в виде точки (1) /линии (2) /полигона (3)
   
-- Точка:
INSERT INTO "gadm41_SYR_2" (geom, "GID_2", "COUNTRY", "NAME_1")
VALUES 
(ST_Point(41.2897, 36.2492), 'example_gid', 'Syria', 'Example Point');

select * from "gadm41_SYR_2";

-- Линия:
INSERT INTO "gadm41_SYR_2" (geom, "GID_2", "COUNTRY", "NAME_1")
VALUES 
(ST_MakeLine(
    ARRAY[
        ST_MakePoint(41.2897, 36.2492),
        ST_MakePoint(41.2669, 36.092),
        ST_MakePoint(41.258, 36.0546)
    ]
), 'example_gid', 'Syria', 'Example Line');

-- Полигон:
INSERT INTO "gadm41_SYR_2" (geom, "GID_2", "COUNTRY", "NAME_1")
VALUES 
(ST_PolygonFromText('POLYGON((
    41.2897 36.2492,
    41.2669 36.092,
    41.258 36.0546,
    41.2897 36.2492
))', 4326), 'example_gid', 'Syria', 'Example Polygon');
   
-- 12. Найдите, в какие пространственные объекты попадают созданные вами объекты

-- Точка:
SELECT 
    a.id,
    a.geom,
    a."GID_2",
    a."COUNTRY",
    a."NAME_1"
FROM 
    "gadm41_SYR_2" a
WHERE 
    ST_Intersects(a.geom, ST_SetSRID(ST_Point(41.2897, 36.2492), 4326));

-- Линия:
SELECT 
    a.id,
    a.geom,
    a."GID_2",
    a."COUNTRY",
    a."NAME_1"
FROM 
    "gadm41_SYR_2" a
WHERE 
    ST_Intersects(a.geom, ST_SetSRID(ST_MakeLine(
        ARRAY[
            ST_SetSRID(ST_MakePoint(41.3500, 36.2500), 4326),
            ST_SetSRID(ST_MakePoint(41.3600, 36.2600), 4326),
            ST_SetSRID(ST_MakePoint(41.3700, 36.2700), 4326)
        ]
    ), 4326));

-- Полигон:
SELECT 
    a.id,
    a.geom,
    a."GID_2",
    a."COUNTRY",
    a."NAME_1"
FROM 
    "gadm41_SYR_2" a
WHERE 
    ST_Intersects(a.geom, ST_SetSRID(ST_PolygonFromText('POLYGON((
        41.3500 36.2500,
        41.3600 36.2600,
        41.3700 36.2700,
        41.3500 36.2500
    ))', 4326), 4326));

-- 13. Продемонстрируйте индексирование пространственных объектов
   
CREATE INDEX idx_geom ON "gadm41_SYR_2" USING GIST (geom);
SELECT * 
FROM pg_indexes 
WHERE tablename = 'gadm41_SYR_2';

-- 14. Разработайте хранимую процедуру, которая принимает координаты точки и возвращает пространственный объект, в который эта точка попадает
DROP FUNCTION IF EXISTS get_spatial_object(double precision, double precision);
CREATE OR REPLACE FUNCTION get_spatial_object(x DOUBLE PRECISION, y DOUBLE PRECISION)
RETURNS TABLE(id INT, geom GEOMETRY, gid_2 CHARACTER VARYING, country CHARACTER VARYING, name_1 CHARACTER VARYING) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id,
        a.geom,
        a."GID_2",
        a."COUNTRY",
        a."NAME_1"
    FROM 
        "gadm41_SYR_2" a
    WHERE 
        ST_Intersects(a.geom, ST_SetSRID(ST_Point(x, y), 4326));
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_spatial_object(41.2897, 36.2492);

