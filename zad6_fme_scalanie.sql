-- scalenie wyników
CREATE TABLE public.Exports_scalone AS SELECT ST_Union(geom) FROM public.Exports