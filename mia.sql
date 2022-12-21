# MIA List
SELECT pax, MAX(date) as last_post, COUNT(pax) AS total_posts
FROM attendance_view av 
GROUP BY pax
HAVING total_posts > 5
	AND last_post < DATE_ADD(SYSDATE(), INTERVAL -3 WEEK)
ORDER BY last_post DESC