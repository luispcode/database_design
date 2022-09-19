-----Database Management

-- Role creation

CREATE ROLE data_scientist;

-- Create a role for Marta
Create role marta LOGIN;

-- Create an admin role
CREATE ROLE admin WITH CREATEDB CREATEROLE;

--GRANT privileges and ALTER attributes

-- Grant data_scientist update and insert privileges
GRANT update, insert ON long_reviews TO data_scientist;

-- Give Marta's role a password
alter role marta with password 's3cur3p@ssw0rd';

--Add a user role to a group role

-- Add Marta to the data scientist group
grant data_scientist to Marta;

-- Celebrate! You hired data scientists.

-- Remove Marta from the data scientist group
REVOKE data_scientist from Marta;


--Creating vertical partitions

-- Create a new table called film_descriptions
CREATE TABLE film_descriptions (
    film_id INT,
    long_description TEXT
);

-- Copy the descriptions from the film table
INSERT INTO film_descriptions
SELECT film_id, long_description FROM film;
    
-- Drop the descriptions from the original table
ALTER TABLE film Drop column long_description;

-- Join to view the original table
SELECT * FROM film 
JOIN film_descriptions USING(film_id);


-- Creating horizontal partitions

-- Create a new table called film_partitioned
CREATE TABLE film_partitioned (
  film_id INT,
  title TEXT NOT NULL,
  release_year TEXT
)
PARTITION BY LIST (release_year);

-- Create the partitions for 2019, 2018, and 2017
CREATE TABLE film_2019
	PARTITION OF film_partitioned FOR VALUES IN ('2019');

CREATE TABLE film_2018
	PARTITION OF film_partitioned FOR VALUES IN ('2018');

CREATE TABLE film_2017
	PARTITION OF film_partitioned FOR VALUES IN ('2017');

-- Insert the data into film_partitioned
INSERT INTO film_partitioned
SELECT film_id, title, release_year FROM film;

-- View film_partitioned
SELECT * FROM film_partitioned;
