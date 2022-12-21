#Longest streaks this year
WITH workouts AS (
	SELECT 
		s.date,
		ROW_NUMBER() OVER ( ORDER BY s.date ) AS workout_num
	FROM (
		SELECT DISTINCT 
			bi.date
		FROM beatdown_info bi
		WHERE bi.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
			AND DAYOFWEEK(bi.date) != 1 # Always ignore Sundays
		ORDER BY bi.date
	) s
),
pax_posts AS (
	SELECT 
		s.pax,
		s.date,
		ROW_NUMBER() OVER ( PARTITION BY pax ORDER BY date ) AS pax_post_num
	FROM (
		# Have to do this because people do have 2 posts in a single day
		SELECT DISTINCT av.pax, av.date
		FROM attendance_view av 
		WHERE av.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
	) s
	ORDER BY s.pax, s.date
),
streak_groups AS (
	SELECT p.pax, p.date, wo.workout_num, p.pax_post_num,
		wo.workout_num - p.pax_post_num AS group_id
	FROM pax_posts p
	INNER JOIN workouts wo
		ON p.date = wo.date
),
streaks AS (
	SELECT g.pax, g.date, g.workout_num, g.pax_post_num, group_id,
		ROW_NUMBER() OVER ( PARTITION BY pax, group_id ORDER BY date) AS streak_count
	FROM streak_groups g
)
SELECT pax, MAX(streak_count) as streak
FROM streaks
WHERE streak_count > 1
GROUP BY pax
ORDER BY MAX(streak_count) DESC

#Longest streaks all time
WITH workouts AS (
	SELECT 
		s.date,
		ROW_NUMBER() OVER ( ORDER BY s.date ) AS workout_num
	FROM (
		SELECT DISTINCT 
			bi.date
		FROM beatdown_info bi
		WHERE DAYOFWEEK(bi.date) != 1 # Always ignore Sundays
		ORDER BY bi.date
	) s
),
pax_posts AS (
	SELECT 
		s.pax,
		s.date,
		ROW_NUMBER() OVER ( PARTITION BY pax ORDER BY date ) AS pax_post_num
	FROM (
		# Have to do this because people do have 2 posts in a single day
		SELECT DISTINCT av.pax, av.date
		FROM attendance_view av 
	) s
	ORDER BY s.pax, s.date
),
streak_groups AS (
	SELECT p.pax, p.date, wo.workout_num, p.pax_post_num,
		wo.workout_num - p.pax_post_num AS group_id
	FROM pax_posts p
	INNER JOIN workouts wo
		ON p.date = wo.date
),
streaks AS (
	SELECT g.pax, g.date, g.workout_num, g.pax_post_num, group_id,
		ROW_NUMBER() OVER ( PARTITION BY pax, group_id ORDER BY date) AS streak_count
	FROM streak_groups g
)
SELECT pax, MAX(streak_count) as streak
FROM streaks
WHERE streak_count > 1
GROUP BY pax
ORDER BY MAX(streak_count) DESC

# 6-Packs this year
WITH posts AS (
	SELECT DISTINCT
		av.pax, 
		av.date, 
		DAYOFYEAR(av.date) doy
	FROM attendance_view av 
	WHERE av.date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND NOW()
		AND DAYOFWEEK(av.date) != 1 # Not Sundays
	ORDER BY av.pax, av.date
),
post_numbered AS (
	SELECT *,
		ROW_NUMBER() OVER ( PARTITION BY pax ORDER BY date) num
	FROM posts
),
streak_groups AS (
	SELECT *,
		p.doy-p.num AS group_id
	FROM post_numbered p
)
SELECT pax, group_id, MIN(date) AS week_start, COUNT(pax) AS number_posts
FROM streak_groups
GROUP BY pax, group_id
HAVING COUNT(pax) >= 6

# Everyone's current streak
WITH workouts AS (
        SELECT 
            s.date,
            ROW_NUMBER() OVER ( ORDER BY s.date ) AS workout_num
        FROM (
            SELECT DISTINCT 
                bi.date
            FROM beatdown_info bi
            WHERE DAYOFWEEK(bi.date) != 1 # Always ignore Sundays
            ORDER BY bi.date
        ) s
    ),
    pax_posts AS (
        SELECT 
            s.pax,
            s.date,
            ROW_NUMBER() OVER ( PARTITION BY pax ORDER BY date ) AS pax_post_num
        FROM (
            # Have to do this because people do have 2 posts in a single day
            SELECT DISTINCT av.pax, av.date
            FROM attendance_view av
        ) s
        ORDER BY s.pax, s.date
    ),
    streak_groups AS (
        SELECT p.pax, p.date, wo.workout_num, p.pax_post_num,
            wo.workout_num - p.pax_post_num AS group_id
        FROM pax_posts p
        INNER JOIN workouts wo
            ON p.date = wo.date
    ),
    streaks AS (
        SELECT g.pax, g.date, g.workout_num, g.pax_post_num, group_id,
            ROW_NUMBER() OVER ( PARTITION BY pax, group_id ORDER BY date) AS streak_count
        FROM streak_groups g
    ),
    all_streaks AS (
	    SELECT pax, group_id, MAX(streak_count) as streak, MAX(date) as last_post, u.user_id
	    FROM streaks
	    INNER JOIN users u
	        ON u.user_name = streaks.pax
	    
	    WHERE streak_count > 1
	    GROUP BY pax, group_id
	    ORDER BY pax, MAX(date) DESC
	)
	SELECT as1.pax, as1.streak, as1.last_post
	FROM all_streaks as1
	LEFT JOIN all_streaks as2
		ON as1.pax = as2.pax
		AND as1.last_post < as2.last_post
	WHERE as2.pax IS NULL
		AND as1.last_post = CURDATE()
	ORDER BY as1.streak DESC
