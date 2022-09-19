---- Database Views
--Viewing views

-- Get all non-systems views
SELECT * FROM information_schema.views
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');

--Creating and querying a view

-- Create a view for reviews with a score above 9
CREATE VIEW high_scores AS
SELECT * FROM REVIEWS
WHERE score > 9;

-- Count the number of self-released works in high_scores
SELECT COUNT(*) FROM high_scores
INNER JOIN labels ON labels.reviewid = high_scores.reviewid
WHERE label = 'self-released';

--Creating a view from other views

-- Create a view with the top artists in 2017
-- with only one column holding the artist field
CREATE VIEW top_artists_2017 AS
SELECT artist_title.artist FROM artist_title
INNER JOIN top_15_2017
ON artist_title.reviewid = top_15_2017.reviewid;

-- Output the new view
SELECT * FROM top_artists_2017;



--command that would drop both top_15_2017 and top_artists_2017
DROP VIEW top_15_2017 CASCADE;
DROP VIEW top_15_2017 RESTRICT;


--Granting and revoking access

-- Revoke everyone's update and insert privileges
REVOKE INSERT, UPDATE ON long_reviews FROM PUBLIC; 

-- Grant the editor update and insert privileges 
GRANT UPDATE, INSERT ON long_reviews TO editor; 


--Updatable views

SELECT * 
FROM information_schema.views
WHERE is_updatable = 'YES' AND table_schema NOT IN ('pg_catalog')


--Redefining a view

-- Redefine the artist_title view to have a label column
CREATE OR REPLACE VIEW artist_title AS
SELECT reviews.reviewid, reviews.title, artists.artist, labels.label
FROM reviews
INNER JOIN artists
ON artists.reviewid = reviews.reviewid
INNER JOIN labels
ON reviews.reviewid = labels.reviewid;

SELECT * FROM artist_title;


--Creating and refreshing a materialized view

-- Create a materialized view called genre_count 
CREATE materialized view genre_count as
SELECT genre, COUNT(*) 
FROM genres
GROUP BY genre;

INSERT INTO genres
VALUES (50000, 'classical');

-- Refresh genre_count
Refresh materialized view genre_count;

SELECT * FROM genre_count;