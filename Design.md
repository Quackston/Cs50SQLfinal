# Design Document

By Sterling Butterfield

Video overview: <https://youtu.be/Be-Ai3aQKN0>

## Scope
 ** "songs" Which allow you to see titles of songs, artists, duration of songs, and year/time in which they were listened to. This can be made more granular with the other tables below. This is the basic information on songs. **

 ** "genre" which allows you to see the genres you have listened to, the artist ID correlated to them, and the "song_id" which allows for you to see what song falls under this category. Directly correlates to the "songs" table. The reason for "song_id" being present is that sometimes artists will do different genres than the general genre of the band. Based on how genres are pulled there can be more than one genre assigned to any one song or artist.**

** "time" Which allows you to see the day, month, year, and season that a song was listened to. Connected via "song_id", and can be used to correlate directly to when a particular song was listened to (example of this being applicable is monthly listening trends, or seasonal trends). This can be used to identify trends within time of listening (example being what song is most listened to at 12am), and is useful for identifying listening trends within a certain time period. **

## Functional Requirements

** The data generally should be exported directly from LAST.FM, however any .CSV file should work assuming columns line up on the "temp" table when it is created. The file will need to be renamed to "song_data.csv" for it to automatically import and clean the data as it is coded with the .import command to work with a file of that name. The database must be able to identify music trends, genres and artists that frequently occur within your own listening habits. This is done automatically within the schema.sql file. This will also remove excel blanks and replace them with SQL NULLs for the sake of creating no conflicts when being added to relevant tables.
Query to find out when a song was listened to, how many times, what band, what genre, and the genre (example being top 5 Genres), find out top songs of the last 5 years or longer. The reason I did it for 5 years is simply how much listening data I had, however I can and is capable of doing a much longer period of time.
Can be used to find out specific time periods in which genres/songs were listened to the most, this is particularly useful for identifying trends.
Will NOT support Finding / have estimated future trends of what they may listen to, find out specific information about the bands they're listening to (formed, where they're from, etc.).LAST.FM export does NOT support these within a data export, and the database just directly pulls this information from SQL
This is on a per user basis, and not an overall view of multiple people as there is not a users table or anything similar. When you are importing your data it will drop the tables and the data that exists from the other user, leaving only the data relevant to you for granularity reasons as well as redundancy and keeping the size of the database small.

## Representation


### Entities

SONGS: This is the songs full name/title. This includes subtitles of songs (if they are present)
SONG ID : If there is a song_id associated with a track, this is the primary key that is referenced by the rest of the tables.
ARTISTS : If an artist is present, this is the musical group/musician responsible for the song.
ARTIST ID : Artist's id if applicable / present
DURATION : This is the song's length, in seconds if applicable / present.
TIMESTAMP : UTC Timestamp, day, month, year, and season. These are separated within the date table by day, month, year, and season.
GENRE: Genre per track, can include 2 different genres for one song. Linked directly via the song_id column to provide a connection.

These are the types of data that are pulled with LAST.FM, and are generally all you need to understand listening trends. There is more data that could be relevant, however cannot be pulled in via Last.FM data.


### Relationships

![IMAGE TITLE](<Songs to Genre Flow-2026-06-21-214949.png>)

The Song table is the table that holds the primary key that the other two tables (Genre, Time) reference, however both the tables (Genre, Time) can reference each other without the need of the song table via the song_id column.

## Optimizations

Created optimizations via INDEXs on the "genre" and "songs" table that will speed up queries involving artists and genre searches as I estimate this will be the most searched things queried. This will provide faster loading times when referencing these columns.

Created individual views for YEARS as this will sort all data based on whatever year, and will provide all song data.

Created a view to show top 100 artists, and allow you to query via them. This allows for identifying specific trends within the most listened to artists (songs, seasons, times listened, etc.) without there being a ton of data. The reason why it is structured like this is since (personally) within the CSV data file I have 13,000 unique artists, and I believe the majority of people who would want to know this information have 100 artists they listen to considerably more than others.

## Limitations

Cannot include artist information besides name. This is how the LAST.FM data is structured. If you had a separate database as long as the csv is lined up with the "temp" table format it will work. Must be in relation to a music listening database, cannot be representative of anything else. This does NOT have any triggers,and with the way it is set up currently it will drop all data and pull from the .csv file. This can be changed by changing the schema to have DROP TABLE IF EXISTS removed, as otherwise it would combine the CSV files data together, as there is not an individual table that would provide the separation.


