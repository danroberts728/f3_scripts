
# Least Popular Q this year
# Order ascending by attendance_view in case people entered a higher number
SELECT av.q, av.ao, av.`Date`, COUNT(av.q) AS '# pax', bi.pax_count 
FROM attendance_view av 
LEFT JOIN beatdown_info bi 
	ON bi.`Date` = av.`Date` 
	AND bi.ao = av.ao
WHERE av.`Date` BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND av.ao != 'ao-downrange'
GROUP BY av.q, av.`Date` 
ORDER BY COUNT(av.q)

# Most Popular Single Qs this year
# Order descending by pax_count to account for FNGs
SELECT av.q, av.ao, av.`Date`, COUNT(av.q) AS '# pax', bi.pax_count 
FROM attendance_view av 
LEFT JOIN beatdown_info bi 
	ON bi.`Date` = av.`Date` 
	AND bi.ao = av.ao
WHERE av.`Date` BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND av.ao != 'ao-downrange'
GROUP BY av.q, av.`Date` 
ORDER BY bi.pax_count DESC

# Most Popular Q (Average PAX per Q)
SELECT bi.q, AVG(bi.pax_count), COUNT(bi.q) AS q_count
FROM beatdown_info bi 
GROUP BY bi.q 
HAVING COUNT(bi.q) > 1
ORDER BY AVG(bi.pax_count) DESC

# Most Qs this year
SELECT bi.q, COUNT(bi.q)
FROM beatdown_info bi 
WHERE bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND bi.ao != 'ao-downrange'
GROUP BY bi.q 
ORDER BY COUNT(bi.q) DESC

# Led most men in total this year
SELECT bi.q, SUM(bi.pax_count), COUNT(bi.q)
FROM beatdown_info bi 
WHERE bi.ao != 'ao-downrange'
	AND bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
GROUP BY bi.q 
ORDER BY SUM(bi.pax_count) DESC

# Qed all 9 AOs this year
SELECT s.q, COUNT(s.q) AS unique_aos_qed
FROM (
	SELECT DISTINCT bi.q, bi.ao
	FROM beatdown_info bi 
	WHERE bi.ao != 'ao-downrange'
		AND bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
) s 
GROUP BY s.q
HAVING unique_aos_qed = 9
ORDER BY COUNT(s.q) DESC

# Top Slag Heap Qs this year
SELECT bi.q, COUNT(bi.q)
FROM beatdown_info bi  
WHERE bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND bi.ao = 'ao-slagheap' 
GROUP BY bi.q
ORDER BY COUNT(bi.q) DESC

# Top House of Paine Qs this year
SELECT bi.q, COUNT(bi.q)
FROM beatdown_info bi  
WHERE bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND bi.ao = 'ao-houseofpaine' 
GROUP BY bi.q
ORDER BY COUNT(bi.q) DESC

# Top Iditarod Qs this year
SELECT bi.q, COUNT(bi.q)
FROM beatdown_info bi  
WHERE bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND bi.ao = 'ao-iditarod' 
GROUP BY bi.q
ORDER BY COUNT(bi.q) DESC

# Top Mush Ruck Qs this year
SELECT bi.q, COUNT(bi.q)
FROM beatdown_info bi  
WHERE bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND bi.ao = 'ao-mush-ruck' 
GROUP BY bi.q
ORDER BY COUNT(bi.q) DESC

# Top School Yard Qs this year
SELECT bi.q, COUNT(bi.q)
FROM beatdown_info bi  
WHERE bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND bi.ao = 'ao-the-schoolyard' 
GROUP BY bi.q
ORDER BY COUNT(bi.q) DESC

# Top Golem Qs thsi year
SELECT bi.q, COUNT(bi.q)
FROM beatdown_info bi  
WHERE bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND bi.ao = 'ao-golem' 
GROUP BY bi.q
ORDER BY COUNT(bi.q) DESC

# Top Argonaut Qs this year
SELECT bi.q, COUNT(bi.q)
FROM beatdown_info bi  
WHERE bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND bi.ao = 'ao-argonaut' 
GROUP BY bi.q
ORDER BY COUNT(bi.q) DESC

# Top Vet Qs this year
SELECT bi.q, COUNT(bi.q)
FROM beatdown_info bi  
WHERE bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND bi.ao = 'ao-the-vet' 
GROUP BY bi.q
ORDER BY COUNT(bi.q) DESC

# Top Source Qs this year
SELECT bi.q, COUNT(bi.q)
FROM beatdown_info bi  
WHERE bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND bi.ao = 'ao-the-source' 
GROUP BY bi.q
ORDER BY COUNT(bi.q) DESC