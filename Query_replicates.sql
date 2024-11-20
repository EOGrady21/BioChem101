SELECT *
FROM biochem.bcdiscretereplicates
WHERE discrete_detail_seq IN (
  SELECT discrete_detail_seq
  FROM biochem.bcdiscrete_mv
  WHERE name = 'cruisename')