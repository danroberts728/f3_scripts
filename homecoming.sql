SELECT
	u.user_id,
	u.user_name AS `PAX`, 
	u.real_name AS `Real Name`,
	COUNT(av.pax) AS `Total Posts`,
	last_posts.post_date AS `Last Post`,
	CONCAT(
		DATE_FORMAT(homecoming_posts.post_date, '%b %e, %Y'), 
		' at ',
		CASE 
			WHEN homecoming_posts.ao = 'ao-argonaut' THEN 'Argonaut'
			WHEN homecoming_posts.ao = 'ao-downrange' THEN 'Downrange'
			WHEN homecoming_posts.ao = 'ao-golem' THEN 'Golem'
			WHEN homecoming_posts.ao = 'ao-houseofpaine' THEN 'House of Paine'
			WHEN homecoming_posts.ao = 'ao-iditarod' THEN 'Iditarod'
			WHEN homecoming_posts.ao = 'ao-mush-ruck' THEN 'Mush Ruck'
			WHEN homecoming_posts.ao = 'ao-slagheap' THEN 'Slag Heap'
			WHEN homecoming_posts.ao = 'ao-the-schoolyard' THEN 'The Schoolyard'
			WHEN homecoming_posts.ao = 'ao-the-source' THEN 'The Source'
			WHEN homecoming_posts.ao = 'ao-the-vet' THEN 'The Vet'
			ELSE homecoming_posts.ao
		END,
		'
Q: ', homecoming_posts.q) AS `Homecoming`
FROM users u
LEFT JOIN attendance_view av 
	ON av.pax = u.user_name 
LEFT JOIN (
	SELECT av2.pax, MAX(av2.date) AS post_date
	FROM attendance_view av2
	-- Last post defined as most recent post before start date
	WHERE av2.date < ${start_date}
	GROUP BY av2.pax
) AS last_posts
	ON last_posts.pax = av.pax
LEFT JOIN (
	SELECT av3.pax, av3.date AS post_date,
	av3.ao, av3.q
	FROM attendance_view av3
	INNER JOIN (
		SELECT av4.pax, MIN(av4.date) AS post_date
		FROM attendance_view av4 
		-- Homecoming post is first post in $start_date month
		WHERE av4.date BETWEEN ${start_date} AND DATE_ADD(${start_date}, INTERVAL +1 MONTH)
		GROUP BY pax
	) november_posts 
	ON av3.date = november_posts.post_date AND av3.pax = november_posts.pax	
) AS homecoming_posts
	ON homecoming_posts.pax = av.pax
WHERE (last_posts.post_date < Date_ADD(${start_date}, INTERVAL -1 MONTH)
	OR last_posts.post_date IS NULL)
	AND u.user_id NOT IN (
	-- Exclude PAX for reasons
	-- Moved
	'U02ME6B57D1',	-- Cleaver
	'U02BEQJBP6Y',	-- Flinstone
	-- System users
	'U02B8QG3K8T',	-- F3 Beast
	'U02ELQNFLM8', 	-- Standuply-Poll
	'U02J4UEJ95L',	-- Backblast
	'U02FDCXLCSZ',	-- Backblast
	'U02FDPC69FX',	-- Backblast test
	'U02JLS0P86N',	-- PAXMiner
	'U02R0E3FXL3',	-- Google Drive
	'USLACKBOT',	-- Slackbot
	-- Duplicates
	'U02JGUZB8K1',	-- Don G Thomas	(Rascal)
	'U03VAF9BA4A',	-- Daniel Holifield (splat)
	'U03VDBC9NAG', 	-- danielholifiedl (splat)
	-- PAX that were FNGs less than a month ago
	'U0466F6A1AP',	-- Snowbird - FNG on 10/12/2022
	'U047CA4KD2A',	-- Spann (Jake Skellett) - FNG on 10/21/2022
	'U046QTTGJ5A',	-- Hosepipe - FNG on 10/14/2022
	'U03CW6CS6QL',	-- Flip-It - Not really FNG but new to Slack
	'U049X6BKKPX',	-- Rio - FNG on 11/8/2022
	'U04ALAMTLGP',	-- Beaoudreaux on 11/15/2022
	-- Because I keep forgetting the trailing comma
	'DUMMY'
)
GROUP BY u.user_name, u.real_name, last_posts.post_date, homecoming_posts.post_date
ORDER BY homecoming_posts.post_date DESC, `Total Posts` DESC, `Last Post` DESC, u.user_name