select * 
FROM biochem.discrete_data 
WHERE name = 'cruisename'
AND EVENT_START BETWEEN '01-JUN-22' AND '30-JUN-22'