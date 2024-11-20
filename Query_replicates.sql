SELECT
  bcdiscrete_mv.NAME,
  bcdiscrete_mv.EVENT_START,
  bcdiscrete_mv.COLLECTOR_SAMPLE_ID,
  bcdiscrete_mv.METHOD,
  /*rename DATA_VALUE in the detail and replicate tables to AVERAGE_VALUE and REPLICATE_VALUE so they're not confused with each other*/
  bcdiscrete_mv.DATA_VALUE AVERAGE_VALUE,
  bcdiscretereplicates.DATA_VALUE REPLICATE_VALUE
FROM 
  biochem.bcdiscrete_mv,
  biochem.bcdiscretereplicates
WHERE
  /*link tables by keys*/
  bcdiscrete_mv.discrete_detail_seq = bcdiscretereplicates.discrete_detail_seq
  AND NAME = 'cruisename'
  AND EVENT_START BETWEEN '01-JUN-22' AND '30-JUN-22'