-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

--Top 10 artists you've listened to and total listens to them
SELECT COUNT(*) AS "listens", "artist" as "Artist" FROM "songs"
GROUP BY "artist"
ORDER BY "listens" DESC LIMIT 10;

-- Most listened to genres, displays general genre and total count of total listens
SELECT "genre"."genre", COUNT("genre"."genre") AS "total_genre_count" FROM "songs"
JOIN "genre" ON "songs"."id" = "genre"."song_id"
WHERE "genre" <> 'Unknown'
GROUP BY "genre"."genre"
ORDER BY "total_genre_count" DESC  LIMIT 100;

--Average Song Duration, includes top and bottom
SELECT MAX("duration") AS "max_duration_seconds", ROUND(AVG("duration"), 2) AS "avg_duration_seconds",  MIN("duration") AS "min_duration_seconds"
FROM "songs" ;

--Top 100 songs of 2021
SELECT COUNT("title") AS "Listens", "title", "artist" FROM "songs"
WHERE "timestamp" LIKE "%2021%"
GROUP BY "title"
ORDER BY "listens" DESC LIMIT 100 ;


--Same amount of listens of 2023 VS 2024

SELECT COUNT("title") AS "Listens", "title", "artist" FROM "songs"
WHERE "timestamp" LIKE "%2023%"
GROUP BY "title"

INTERSECT

SELECT COUNT("title") AS "Listens", "title", "artist" FROM "songs"
WHERE "timestamp" LIKE "%2024%"
GROUP BY "title"
ORDER BY "listens" DESC LIMIT 100 ;

-- Total time spend listening per year
SELECT SUM("duration")/60 AS "total_time_min" FROM "songs"
WHERE "timestamp" LIKE '%2021%';

--Most lisented to songs based on season (winter)

SELECT COUNT("title") AS "Listens", "title", "artist" ,"time"."season", "time"."year", "time"."month", "time"."date"  FROM "songs"
JOIN "time" ON "songs"."id" = "time"."song_id"
WHERE "season" = 'Winter'
GROUP BY "title"
ORDER BY "time"."year" DESC, "Listens" DESC LIMIT 100;

--Same as above for summer
SELECT COUNT("title") AS "Listens", "title", "artist" ,"time"."season", "time"."year", "time"."month" FROM "songs"
JOIN "time" ON "songs"."id" = "time"."song_id"
WHERE "season" = 'Summer'
AND "time"."year" = 2026
GROUP BY "title"
ORDER BY "time"."year" DESC, "Listens" DESC LIMIT 100;



