-- Enable Foreign Key constraint enforcement in SQLite
PRAGMA foreign_keys = ON;

-- Clear previous tables to avoid conflict on re-runs
DROP TABLE IF EXISTS "time";
DROP TABLE IF EXISTS "genre";
DROP TABLE IF EXISTS "songs";
DROP TABLE IF EXISTS "temp";

-- Basic songs table, provides title artist and length
CREATE TABLE "songs" (
    "id" INTEGER,
    "track_id" TEXT,
    "title" TEXT,
    "artist" TEXT,
    "duration" NUMERIC,
    "timestamp" TEXT,
    PRIMARY KEY ("id")
);

-- Time when listened, separated by year day and month
CREATE TABLE "time" (
    "timestamp" TEXT,
    "year" NUMERIC,
    "month" NUMERIC,
    "date" NUMERIC,
    "season" TEXT,
    "song_id" INTEGER,
    FOREIGN KEY ("song_id") REFERENCES "songs"("id")
);

-- Genre with artist id and song ID to reference other tables
CREATE TABLE "genre" (
    "genre" TEXT,
    "song_id" INTEGER,
    "artist_id" TEXT,
    FOREIGN KEY ("song_id") REFERENCES "songs"("id")
);

-- Temp table to import csv into
CREATE TABLE "temp" (
    "unique_id" INTEGER,
    "utc_time" TEXT,
    "artist" TEXT,
    "artist_id" TEXT,
    "album" TEXT,
    "album_id" TEXT,
    "track" TEXT,
    "track_id" TEXT,
    "genre" TEXT,
    "track_duration" TEXT
);

-- Import CSV data
.import --csv --skip 1 song_data.csv temp

-- Removes Excel Blanks and replaces them with NULL values across the entire temp table
UPDATE "temp"
SET "utc_time" = CASE WHEN "utc_time" = '' THEN NULL ELSE "utc_time" END,
    "artist" = CASE WHEN "artist" = '' THEN NULL ELSE "artist" END,
    "artist_id" = CASE WHEN "artist_id" = '' THEN NULL ELSE "artist_id" END,
    "album" = CASE WHEN "album" = '' THEN NULL ELSE "album" END,
    "album_id" = CASE WHEN "album_id" = '' THEN NULL ELSE "album_id" END,
    "track" = CASE WHEN "track" = '' THEN NULL ELSE "track" END,
    "track_id" = CASE WHEN "track_id" = '' THEN NULL ELSE "track_id" END,
    "genre" = CASE WHEN "genre" = '' THEN NULL ELSE "genre" END,
    "track_duration" = CASE WHEN "track_duration" = '' THEN NULL ELSE "track_duration" END;

-- Inserts data into relevant tables, songs must be inserted first since it is the primary key
INSERT OR IGNORE INTO "songs" ("id", "track_id", "title", "artist", "duration", "timestamp")
SELECT "unique_id", "track_id", "track", "artist", "track_duration", "utc_time"
FROM "temp";

-- Populate child genre table
INSERT OR IGNORE INTO "genre" ("genre", "song_id", "artist_id")
SELECT "genre", "unique_id", "artist_id"
FROM "temp"
GROUP BY "unique_id", "genre";

-- Populate child time table with time formatting and matching columns, also seperates out the timestamp
INSERT INTO "time" ("timestamp", "year", "month", "date", "season", "song_id")
SELECT
    "utc_time",
    CAST(SUBSTR("utc_time", INSTR("utc_time", ' ') + 5, 4) AS INTEGER),
    CASE SUBSTR("utc_time", INSTR("utc_time", ' ') + 1, 3)
        WHEN 'Jan' THEN 1  WHEN 'Feb' THEN 2
        WHEN 'Mar' THEN 3  WHEN 'Apr' THEN 4
        WHEN 'May' THEN 5  WHEN 'Jun' THEN 6
        WHEN 'Jul' THEN 7  WHEN 'Aug' THEN 8
        WHEN 'Sep' THEN 9  WHEN 'Oct' THEN 10
        WHEN 'Nov' THEN 11 WHEN 'Dec' THEN 12
    END,
    CAST(TRIM(SUBSTR("utc_time", 1, INSTR("utc_time", ' ') - 1)) AS INTEGER),
    CASE SUBSTR("utc_time", INSTR("utc_time", ' ') + 1, 3)
        WHEN 'Dec' THEN 'Winter' WHEN 'Jan' THEN 'Winter' WHEN 'Feb' THEN 'Winter'
        WHEN 'Mar' THEN 'Spring' WHEN 'Apr' THEN 'Spring' WHEN 'May' THEN 'Spring'
        WHEN 'Jun' THEN 'Summer' WHEN 'Jul' THEN 'Summer' WHEN 'Aug' THEN 'Summer'
        WHEN 'Sep' THEN 'Autumn' WHEN 'Oct' THEN 'Autumn' WHEN 'Nov' THEN 'Autumn'
    END,
    "unique_id"
FROM "temp"
ORDER BY "uts" DESC;

-- Removes temp table as it is no longer needed
DROP TABLE IF EXISTS "temp";

-- Indexes for faster queries
CREATE INDEX "artist_index" ON "songs"("artist") ;
CREATE INDEX "genre_index" ON "genre" ("genre", "artist_id") ;
CREATE INDEX "songs_index" ON "songs" ("title") ;


--Testing
DROP VIEW IF EXISTS "top_artist";

--View for you to see top 100 artists
CREATE VIEW "top_artist" AS
SELECT COUNT("artist") AS "listens", "artist"
FROM "songs"
GROUP BY "artist"
ORDER BY "listens"  DESC LIMIT 100;

--For testing purposes
DROP VIEW IF EXISTS "2021";
DROP VIEW IF EXISTS "2022";
DROP VIEW IF EXISTS "2023";
DROP VIEW IF EXISTS "2024";
DROP VIEW IF EXISTS "2025";
DROP VIEW IF EXISTS "2026";

-- Views for last 5 years, personally have data going back to 2021
CREATE VIEW "2021" AS
SELECT "artist", "title", "track_id", "timestamp" FROM "songs"
WHERE "year" = '2021';

CREATE VIEW "2022" AS
SELECT "artist", "title", "track_id", "timestamp" FROM "songs"
WHERE "year" = '2022';

CREATE VIEW "2023" AS
SELECT "artist", "title", "track_id", "timestamp" FROM "songs"
WHERE "year" = '2023';

CREATE VIEW "2024" AS
SELECT "artist", "title", "track_id", "timestamp" FROM "songs"
WHERE "year" = '2024';


CREATE VIEW "2025" AS
SELECT "artist", "title", "track_id", "timestamp" FROM "songs"
WHERE "year" = '2025';

CREATE VIEW "2026" AS
SELECT "artist", "title", "track_id", "timestamp" FROM "songs"
WHERE "year" = '2026';
