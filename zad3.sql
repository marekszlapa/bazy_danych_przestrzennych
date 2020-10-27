CREATE EXTENSION postgis;

--4.
CREATE TABLE tableB
AS
SELECT  COUNT(DISTINCT p.geom) AS "Liczba_budynków" FROM popp p, majrivers m
WHERE p.f_codedesc = 'Building' AND ST_DWithin(p.geom, m.geom, 100000);
--SELECT * FROM tableB;

--5.
CREATE TABLE airportsNew
AS
SELECT name, geom, elev FROM airports;
--SELECT * FROM airportsNew;

--a)
SELECT name AS "Lotnisko_wschodnie" FROM airportsNew
WHERE ST_Y(geom) = (SELECT MAX(ST_Y(geom)) FROM airportsNew);
SELECT name AS "Lotnisko_zachodnie" FROM airportsNew
WHERE ST_Y(geom) = (SELECT MIN(ST_Y(geom)) FROM airportsNew);

--b)
INSERT INTO airportsNew(name, geom, elev) VALUES
('airportB',
(SELECT ST_Centroid(ST_MakeLine((SELECT geom FROM airportsNew
 WHERE ST_Y(geom) = (SELECT MAX(ST_Y(geom)) FROM airportsNew)), 
(SELECT geom FROM airportsNew
 WHERE ST_Y(geom) = (SELECT MIN(ST_Y(geom)) FROM airportsNew))))),
 100);

--SELECT * FROM airportsNew WHERE name = 'airportB';

--6.
SELECT ST_Area(ST_Buffer(ST_MakeLine(
(SELECT ST_Centroid(geom) FROM lakes WHERE names = 'Iliamna Lake'),
(SELECT geom FROM airports WHERE name = 'AMBLER')),1000)) AS "Pole_Powierzchni";

--7.
SELECT vegdesc, SUM(ST_Area(ST_Intersection(ST_Buffer(t.geom,0),ST_Intersection(ST_Buffer(tr.geom,0),ST_Buffer(s.geom,0))))) FROM tundra t, trees tr, swamp s
GROUP BY vegdesc;