--SELECT *
--FROM biochem.discrete_data
--WHERE some condition;

-- Grab all average BBMP data from 2022
SELECT *
FROM biochem.discrete_data
WHERE name = 'BCD2022667';

-- filter by location and date
SELECT *
FROM biochem.discrete_data
WHERE event_min_lat BETWEEN 37 AND 48
AND event_min_lon BETWEEN -71 AND -48
AND mission_start > '01-Jan-2023';

-- grab data and add in units from look up tables
SELECT 
dd.name,
dd.event_start,
dd.event_start_time,
dd.collector_station_name, 
dd.collector_event_id,
dd.event_min_lat,
dd.event_min_lon,
dd.event_max_lat,
dd.event_max_lon,
dd.header_start_depth,
dd.parameter_name,
-- 1. add unit column
u.description unit,
dd.data_value,
dd.data_qc_code
FROM biochem.discrete_data dd, 
-- 2. link unit look up table
biochem.bcunits u
WHERE event_min_lat BETWEEN 37 AND 48
AND event_min_lon BETWEEN -71 AND -48
AND mission_start > '01-Jan-2023'
-- 3. connect tables by key
AND dd.converted_unit = u.unit_seq;

-- Grab replicate data from BBMP 2022
SELECT 
dd.name,
dd.mission_start,
dd.mission_end,
dd.event_start,
dd.event_start_time,
dd.event_end,
dd.event_end_time,
dd.collector_station_name,
dd.collector_event_id,
dd.event_min_lat,
dd.event_min_lon,
dd.event_max_lat,
dd.event_max_lon,
dd.header_start,
dd.header_start_time,
dd.header_end,
dd.header_end_time,
dd.header_start_depth, 
dd.header_end_depth,
dd.sounding,
dd.collector_sample_id,
dd.method,
dd.parameter_name, 
u.description unit,
dd.data_value, 
dd.averaged_data,
dd.data_qc_code,
dd.detection_limit
FROM biochem.discrete_data dd, biochem.bcunits u
WHERE dd.averaged_data = 'N'
AND dd.name = 'BCD2022667'
AND dd.converted_unit = u.unit_seq
UNION ALL
SELECT 
dd.name,
dd.mission_start,
dd.mission_end,
dd.event_start,
dd.event_start_time,
dd.event_end,
dd.event_end_time,
dd.collector_station_name,
dd.collector_event_id,
dd.event_min_lat,
dd.event_min_lon,
dd.event_max_lat,
dd.event_max_lon,
dd.header_start,
dd.header_start_time,
dd.header_end,
dd.header_end_time,
dd.header_start_depth, 
dd.header_end_depth,
dd.sounding,
dd.collector_sample_id,
dd.method,
dd.parameter_name, 
u.description unit,
dr.data_value, 
dd.averaged_data,
dr.data_qc_code,
dd.detection_limit
FROM biochem.discrete_data dd, biochem.bcdiscretereplicates dr, biochem.bcunits u
WHERE dd.discrete_detail_seq = dr.discrete_detail_seq
AND dd.converted_unit = u.unit_seq
AND dd.name = 'BCD2022667';






