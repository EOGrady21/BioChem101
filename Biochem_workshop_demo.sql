--SELECT *
--FROM biochem.discrete_data
--WHERE some condition
-- AND some more things;

-- Grab all average BBMP data from 2022
SELECT *
FROM biochem.bcdiscrete_mv
WHERE name = 'BCD2022667';

-- filter by location and date
SELECT *
FROM biochem.bcdiscrete_mv
WHERE event_min_lat BETWEEN 37 AND 48
AND event_min_lon BETWEEN -71 AND -48
AND mission_start > '01-Jan-2023';

-- filter by method
SELECT *
FROM biochem.bcdiscrete_mv
WHERE event_min_lat BETWEEN 37 AND 48
AND event_min_lon BETWEEN -71 AND -48
AND mission_start > '01-Jan-2023'
AND upper(METHOD) LIKE 'HPLC%';

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
dd.converted_unit,
dd.data_value, 
dd.averaged_data,
dd.data_qc_code,
dd.detection_limit
FROM biochem.bcdiscrete_mv dd
WHERE dd.averaged_data = 'N'
AND dd.name = 'BCD2022667'
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
dd.converted_unit,
dr.data_value, 
dd.averaged_data,
dr.data_qc_code,
dd.detection_limit
FROM biochem.bcdiscrete_mv dd, biochem.bcdiscretereplicates dr
WHERE dd.discrete_detail_seq = dr.discrete_detail_seq
AND dd.name = 'BCD2022667'
AND dd.averaged_data = 'Y';








