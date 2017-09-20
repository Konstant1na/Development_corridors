
SET search_path=cci_2017_20km,cci_2015,public,topology;


--find/display current path for sql processing 
SHOW search_path;


select *
from corridors_type_3_dis_buffer55;

--making a new clean corridor dataset
drop table if exists corridors_type_3_buff_agg;
create table corridors_type_3_buff_agg as
select *, st_buffer(st_transform(the_geom,54032),0) as the_geom_azim_eq_dist 
from corridors_type_3_dis_buffer55;


drop index if exists corridors_type_3_buff_agg_geom_gist;
CREATE INDEX corridors_type_3_buff_agg_geom_gist ON corridors_type_3_buff_agg USING GIST (the_geom_azim_eq_dist);
CLUSTER corridors_type_3_buff_agg USING corridors_type_3_buff_agg_geom_gist;
ANALYZE corridors_type_3_buff_agg;