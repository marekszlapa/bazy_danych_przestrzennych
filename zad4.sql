CREATE EXTENSION postgis;

--1.
CREATE TABLE obiekty(
	id INT PRIMARY KEY NOT NULL,
	nazwa VARCHAR(40),
	geometria GEOMETRY
);

--SELECT * FROM obiekty;

--obiekt1
INSERT INTO obiekty VALUES
(1,'obiekt1',ST_GeomFromText('MULTICURVE((0 1, 1 1),CIRCULARSTRING(1 1, 2 0, 3 1, 4 2, 5 1),(5 1, 6 1))',0));
--SELECT ST_CurveToLine(geometria) FROM obiekty WHERE nazwa = 'obiekt1';

--obiekt2
INSERT INTO obiekty VALUES
(2,'obiekt2',ST_GeomFromText('CURVEPOLYGON(COMPOUNDCURVE((10 2, 10 6, 14 6),CIRCULARSTRING(14 6, 16 4, 14 2, 12 0, 10 2)),CIRCULARSTRING(11 2, 13 2, 11 2))',0));
--SELECT ST_CurveToLine(geometria) FROM obiekty WHERE nazwa = 'obiekt2';

--obiekt3
INSERT INTO obiekty VALUES
(3,'obiekt3',ST_GeomFromText('POLYGON((7 15, 10 17, 12 13, 7 15))',0));
--SELECT geometria FROM obiekty WHERE nazwa = 'obiekt3';

--obiekt4
INSERT INTO obiekty VALUES
(4,'obiekt4',ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)',0));
--SELECT geometria FROM obiekty WHERE nazwa = 'obiekt4';

--obiekt5
INSERT INTO obiekty VALUES
(5,'obiekt5',ST_GeomFromText('MULTIPOINT(30 30 59, 38 32 234)',0));
--SELECT geometria FROM obiekty WHERE nazwa = 'obiekt5';

--obiekt6
INSERT INTO obiekty VALUES
(6,'obiekt6',ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2),POINT(4 2))',0));
--SELECT geometria FROM obiekty WHERE nazwa = 'obiekt6';



--1.
SELECT ST_Area(ST_Buffer(ST_ShortestLine((SELECT geometria FROM obiekty WHERE nazwa = 'obiekt3'),(SELECT geometria FROM obiekty WHERE nazwa = 'obiekt4')),5));

--2. Aby zamienić obiekt na poligon ostatni punkt linii musi byc identyczny jak pierwszy, żeby obiekt był zakmnięty.
UPDATE obiekty SET geometria = ST_GeomFromText('Polygon((20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20))')
WHERE nazwa = 'obiekt4';
--SELECT geometria FROM obiekty WHERE nazwa = 'obiekt4';

--3.
INSERT INTO obiekty VALUES
(7,'obiekt7',(SELECT ST_Union(o1.geometria, o2.geometria) FROM obiekty o1, obiekty o2 WHERE o1.nazwa='obiekt3' AND o2.nazwa='obiekt4'));
--SELECT geometria FROM obiekty WHERE nazwa = 'obiekt7';

--4.
SELECT SUM(ST_Area(ST_Buffer(o.geometria,5))) FROM obiekty o
WHERE ST_HasArc(o.geometria) = false;