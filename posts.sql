# Top posts and weekly averages this year
SELECT pax, COUNT(pax) AS posts, COUNT(pax)/CEILING(DAYOFYEAR(SYSDATE())/7) AS weekly
FROM attendance_view av 
WHERE av.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
GROUP BY pax
ORDER BY COUNT(pax) DESC;

# Top posts all time
	SELECT pax, COUNT(pax) AS posts
	FROM attendance_view av 
	GROUP BY pax
	ORDER BY COUNT(pax) DESC;

# Hit ALL AOs this year
SELECT s.pax, COUNT(s.pax) AS unique_aos
FROM (
	SELECT DISTINCT av.pax, av.ao
	FROM attendance_view av
	WHERE av.ao != 'ao-downrange'
		AND av.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
) s
GROUP BY s.pax
HAVING unique_aos = (SELECT COUNT(ao) FROM aos WHERE backblast = 1 AND archived = 0 AND ao != 'ao-downrange')
ORDER BY COUNT(s.pax) DESC, s.pax

# Hit ALL AOs ever
SELECT s.pax, COUNT(s.pax) AS unique_aos
FROM (
	SELECT DISTINCT av.pax, av.ao
	FROM attendance_view av
	WHERE av.ao != 'ao-downrange'
) s
GROUP BY s.pax
HAVING unique_aos = (SELECT COUNT(ao) FROM aos WHERE backblast = 1 AND archived = 0 AND ao != 'ao-downrange')
ORDER BY COUNT(s.pax) DESC, s.pax

# Slag Heap top posters this year
SELECT av.pax, COUNT(av.pax)
FROM attendance_view av 
WHERE av.date DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND av.ao = 'ao-slagheap'
GROUP BY av.pax
ORDER BY COUNT(av.pax) DESC

# HoP top posters this year
SELECT av.pax, COUNT(av.pax)
FROM attendance_view av 
WHERE av.date DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND av.ao = 'ao-houseofpaine'
GROUP BY av.pax
ORDER BY COUNT(av.pax) DESC

# Iditarod top posters this year
SELECT av.pax, COUNT(av.pax)
FROM attendance_view av 
WHERE av.date DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND av.ao = 'ao-iditarod'
GROUP BY av.pax
ORDER BY COUNT(av.pax) DESC

# Mush Ruck top posters this year
SELECT av.pax, COUNT(av.pax)
FROM attendance_view av 
WHERE av.date DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND av.ao = 'ao-mush-ruck'
GROUP BY av.pax
ORDER BY COUNT(av.pax) DESC

# The Schoolyard top posters this year
SELECT av.pax, COUNT(av.pax)
FROM attendance_view av 
WHERE av.date DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND av.ao = 'ao-the-schoolyard'
GROUP BY av.pax
ORDER BY COUNT(av.pax) DESC

# Golem top posters this year
SELECT av.pax, COUNT(av.pax)
FROM attendance_view av 
WHERE av.date DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND av.ao = 'ao-golem'
GROUP BY av.pax
ORDER BY COUNT(av.pax) DESC

# Argonaut top posters this year
SELECT av.pax, COUNT(av.pax)
FROM attendance_view av 
WHERE av.date DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND av.ao = 'ao-argonaut'
GROUP BY av.pax
ORDER BY COUNT(av.pax) DESC

# The Vet top posters this year
SELECT av.pax, COUNT(av.pax)
FROM attendance_view av 
WHERE av.date DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND av.ao = 'ao-the-vet'
GROUP BY av.pax
ORDER BY COUNT(av.pax) DESC

# The Source top posters this year
SELECT av.pax, COUNT(av.pax)
FROM attendance_view av 
WHERE av.date DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	AND av.ao = 'ao-the-source'
GROUP BY av.pax
ORDER BY COUNT(av.pax) DESC