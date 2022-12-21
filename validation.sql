# Missing backblasts per AO
WITH RECURSIVE all_dates AS (
    SELECT MIN(date) AS date FROM beatdown_info bi2
    UNION ALL
    SELECT date + INTERVAL 1 DAY AS date FROM all_dates WHERE date <= SYSDATE() - INTERVAL 1 DAY
),
ao_workouts AS (
	SELECT ad.date, DATE_FORMAT(ad.date,'%a') as day,
		CASE WHEN ad.date IN (SELECT date FROM beatdown_info bi WHERE bi.ao = 'ao-the-schoolyard') THEN 1 ELSE 0 END AS 'ao-the-schoolyard',
		CASE WHEN ad.date IN (SELECT date FROM beatdown_info bi WHERE bi.ao = 'ao-iditarod') THEN 1 ELSE 0 END AS 'ao-iditarod',
		CASE WHEN ad.date IN (SELECT date FROM beatdown_info bi WHERE bi.ao = 'ao-golem') THEN 1 ELSE 0 END AS 'ao-golem',
		CASE WHEN ad.date IN (SELECT date FROM beatdown_info bi WHERE bi.ao = 'ao-mush-ruck') THEN 1 ELSE 0 END AS 'ao-mush-ruck',
		CASE WHEN ad.date IN (SELECT date FROM beatdown_info bi WHERE bi.ao = 'ao-houseofpaine') THEN 1 ELSE 0 END AS 'ao-houseofpaine',
		CASE WHEN ad.date IN (SELECT date FROM beatdown_info bi WHERE bi.ao = 'ao-slagheap') THEN 1 ELSE 0 END AS 'ao-slagheap',
		CASE WHEN ad.date IN (SELECT date FROM beatdown_info bi WHERE bi.ao = 'ao-downrange') THEN 1 ELSE 0 END AS 'ao-downrange',
		CASE WHEN ad.date IN (SELECT date FROM beatdown_info bi WHERE bi.ao = 'ao-argonaut') THEN 1 ELSE 0 END AS 'ao-argonaut',
		CASE WHEN ad.date IN (SELECT date FROM beatdown_info bi WHERE bi.ao = 'ao-the-source') THEN 1 ELSE 0 END AS 'ao-the-source',
		CASE WHEN ad.date IN (SELECT date FROM beatdown_info bi WHERE bi.ao = 'ao-the-vet') THEN 1 ELSE 0 END AS 'ao-the-vet'
	FROM all_dates ad
)
SELECT date, day,
	CASE WHEN day IN ('Mon','Wed') AND `ao-the-schoolyard` = 0 THEN 'MISSING' ELSE '' END AS 'ao-the-schoolyard',
	CASE WHEN day IN ('Wed') AND `ao-iditarod` = 0 THEN 'MISSING' ELSE '' END AS 'ao-iditarod',
	CASE WHEN day IN ('Sat') AND `ao-golem` = 0 THEN 'MISSING' ELSE '' END AS 'ao-golem',
	CASE WHEN day IN ('Wed') AND `ao-mush-ruck` = 0 THEN 'MISSING' ELSE '' END AS 'ao-mush-ruck',
	CASE WHEN day IN ('Tue','Thu') AND `ao-houseofpaine` = 0 THEN 'MISSING' ELSE '' END AS 'ao-houseofpaine',
	CASE WHEN day IN ('Mon','Fri') AND `ao-slagheap` = 0 THEN 'MISSING' ELSE '' END AS 'ao-slagheap',
	CASE WHEN day IN ('Mon','Thu') AND `ao-argonaut` = 0 THEN 'MISSING' ELSE '' END AS 'ao-argonaut',
	CASE WHEN day IN ('Fri') AND `ao-the-source` = 0 THEN 'MISSING' ELSE '' END AS 'ao-the-source',
	CASE WHEN day IN ('Tue') AND `ao-the-vet` = 0 THEN 'MISSING' ELSE '' END AS 'ao-the-vet'
FROM ao_workouts
WHERE 
	(day IN ('Mon','Wed') AND `ao-the-schoolyard` = 0)
	OR (day IN ('Wed') AND `ao-iditarod` = 0)
	OR (day IN ('Sat') AND `ao-golem` = 0)
	OR (day IN ('Wed') AND `ao-mush-ruck` = 0)
	OR (day IN ('Tue', 'Thu') AND `ao-houseofpaine` = 0)
	OR (day IN ('Mon','Fri') AND `ao-slagheap` = 0)
	OR (day IN ('Mon','Thu') AND `ao-argonaut` = 0 AND date > '2022-03-31')
	OR (day IN ('Fri') AND `ao-the-source` = 0 AND date > '2022-04-01')
	OR (day IN ('Tue') AND `ao-the-vet` = 0 AND date > '2022-03-31')


# Find off-day backblasts per aos 
# Be sure to update AOs and their dates
# Day numbers start with Sunday = 1 and end with Saturday = 6
SELECT a.ao, a.channel_id, DATE_FORMAT(b.bd_date, '%a %b %D %Y'), u.user_name, b.backblast 
FROM beatdowns b
INNER JOIN aos a 
	ON a.channel_id = b.ao_id
INNER JOIN users u 
	ON u.user_id = b.q_user_id 
WHERE
	# Slag Heap Mon and Fri
	(a.ao = 'ao-slagheap'
		AND DAYOFWEEK(b.bd_date) NOT IN (2,6))
	# House of Paine Tue and Thu
	OR (a.ao = 'ao-houseofpaine'
		AND DAYOFWEEK(b.bd_date) NOT IN (3,5))
	# The Schoolyard Mon and Wed
	OR (a.ao = 'ao-the-schoolyard'
		AND DAYOFWEEK(b.bd_date) NOT IN (2,4))
	# Mush Ruck Wed
	OR (a.ao = 'ao-mush-ruck'
		AND DAYOFWEEK(b.bd_date) NOT IN (4))
	# Iditarod Wed
	OR (a.ao = 'ao-iditarod'
		AND DAYOFWEEK(b.bd_date) NOT IN (4)) 
	# Golem Sat
	OR (a.ao = 'ao-golem'
		AND DAYOFWEEK(b.bd_date) NOT IN (7))
	# Argonaut Mon and Thu
	OR (a.ao = 'ao-argonaut'
		AND DAYOFWEEK(b.bd_date) NOT IN (2,5))
	# The Source Fri
	OR (a.ao = 'ao-the-source'
		AND DAYOFWEEK(b.bd_date) NOT IN (6))
	# The Vet Tue
	OR (a.ao = 'ao-the-vet'
		AND DAYOFWEEK(b.bd_date) NOT IN (3))
	
	