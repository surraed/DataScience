USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- finding no of rows in each table using count(*)
SELECT COUNT(*) AS rows_in_table FROM director_mapping; -- Ans: 3867 rows
/* Result of the above query
rows_in_table
3867
*/
SELECT COUNT(*) AS rows_in_table FROM genre; -- Ans 14662 rows
/* Result of the above query
rows_in_table
14662
*/
SELECT COUNT(*) AS rows_in_table FROM movie; -- Ans 7997 rows
/* Result of the above query
rows_in_table
7997
*/
SELECT COUNT(*) AS rows_in_table FROM names; -- Ans 25735 rows
/*
rows_in_table
25735
*/
SELECT COUNT(*) AS rows_in_table FROM ratings; -- Ans 7997 rows
/*
rows_in_table
7997
*/
SELECT COUNT(*) AS rows_in_table FROM role_mapping; -- Ans 15615 rows
/*
rows_in_table
15615
*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- using IS NULL condition to test for null values in the various columns of the movie table; going column by column manually
SELECT * FROM movie WHERE id IS NULL; -- no null values in column id
SELECT * FROM movie WHERE title IS NULL; -- no null values in column title
SELECT * FROM movie WHERE year IS NULL; -- no null values in column year
SELECT * FROM movie WHERE date_published IS NULL; -- no null values in column date_published
SELECT * FROM movie WHERE duration IS NULL; -- no null values in column duration
SELECT * FROM movie WHERE country IS NULL; -- 20 rows with null values in column country
SELECT * FROM movie WHERE worlwide_gross_income IS NULL; -- 3724 rows with null values in column worlwide_gross_income
SELECT * FROM movie WHERE languages IS NULL; -- 194 rows with null values in column languages
SELECT * FROM movie WHERE production_company IS NULL; -- 528 rows with null values in column production_company

-- Alternatively using CASE statement and IS NULL condition to know null values in columns in a tabular form
SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS null_count_of_id,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS null_count_of_title,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS null_count_of_year,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS null_count_of_date_published,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS null_count_of_duration,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS null_count_of_country,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS null_count_of_worlwide_gross_income,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS null_count_of_languages,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS null_count_of_production_company
FROM
    movie;

/*    Result of above query
null_count_of_id, null_count_of_title, null_count_of_year, null_count_of_date_published, null_count_of_duration, null_count_of_country, null_count_of_worlwide_gross_income, null_count_of_languages, null_count_of_production_company
0,                  0,                   0,                  0,                            0,                      20,                    3724,                                194,                     528
*/


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+
*/
-- Tabulating the Year and the total no of movies released in that particular year using movie table
SELECT 
    year AS Year, COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY year
ORDER BY year;

/* Result of above query
Year	number_of_movies
2017	3052
2018	2944
2019	2001

*/


/*
Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Tabulating the months from 1 to 12 (Jan to Dec) and the respective movies released during the respective months across the years.
SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY month_num;

/* Result of the above query
month_num	number_of_movies
1	804
2	640
3	824
4	680
5	625
6	580
7	493
8	678
9	809
10	801
11	625
12	438
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look 
at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of 
movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- Tabulating the no of movies produced in USA or India in the year 2019
SELECT 
    year, COUNT(id) AS movies_count
FROM
    movie
WHERE
    (country LIKE '%india%'
        OR country LIKE '%usa%')
        AND year = 2019;

/* Result of the above query
year	movies_count
2019	1059
*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.

Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
-- using distinct clause to identify unique genre names in the genre table
SELECT DISTINCT(genre) FROM genre;

/* Result of above query
# genre
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others

*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */
-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

/* 
Using CTE to avoid use of LIMIT. Using INNER JOIN to join tables movie and genre to know 
movie count in each genre
*/
WITH best_genres AS (
SELECT 
    g.genre, COUNT(g.movie_id) AS number_of_movies,
    RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
FROM
    genre AS g
        INNER JOIN
    movie AS m ON m.id = g.movie_id
GROUP BY genre
ORDER BY number_of_movies DESC
)
SELECT 
    genre, number_of_movies
FROM
    best_genres
WHERE
    genre_rank = 1;

/* Result of above query
genre	number_of_movies
Drama	4285

*/
-- genre Drama had highest no of movies (4285)

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
-- using CTE to get a count of movies with only 1 genre
WITH genres_count 
AS(
SELECT 
    movie_id, COUNT(genre) AS count_of_genre
FROM
    genre
GROUP BY movie_id
)
SELECT 
    COUNT(movie_id) AS movie_count_with_1_genre
FROM
    genres_count
WHERE
    count_of_genre = 1;

/*
movie_count_with_1_genre
3289
*/
-- movie count with 1 genre is 3289

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
/*
using inner join on tables movie and genre to calculate average duration of movies under each genre
using ROUND() on AVG(duration) to match the format shown; however it is observed that genre 'drama' 
duration is indeed 106.77 before rounding off.
*/
SELECT 
    genre, ROUND(AVG(duration)) AS avg_duration
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;

-- Alternatively using ROUND(AVG(duration), 2) to match output mentioned in note.
SELECT 
    genre, ROUND(AVG(duration), 2) AS avg_duration
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;

/* Result of above query with ROUND(AVG(duration))
#genre		avg_duration
Action		113
Romance		110
Drama		107
Crime		107
Fantasy		105
Comedy		103
Thriller	102
Adventure	102
Mystery		102
Family		101
Others		100
Sci-Fi		98
Horror		93


*/
-- Drama	106.77 The Drama genre's average duration on execution of the query with ROUND(AVG(duration), 2).

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the 
average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- using CTE to rank movies based on count of movies in each genre, and then using it to display rank of thriller genre subsequently
WITH movie_rank_by_genre AS (
SELECT 
    genre AS genre, COUNT(movie_id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM
    genre
GROUP BY genre
)
SELECT 
    *
FROM
    movie_rank_by_genre
WHERE
    genre LIKE 'thriller';

/* Result of above query
genre	movie_count	genre_rank
Thriller	1484	3

*/


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
/* 
using MIN() and MAX() functions to figure out the required values from ratings table; no outliers 
noticed in result. Using ROUND() to match format shown.
*/
SELECT 
    ROUND(MIN(avg_rating)) AS min_avg_rating,
    ROUND(MAX(avg_rating)) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;

/* Result of the above query
# min_avg_rating	max_avg_rating	min_total_votes	max_total_votes	min_median_rating	max_median_rating
1					10				100				725138			1					10

 */  

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

/* Using CTE to avoid using LIMIT clause; DENSE_RANK() function is the more apt function to use, but despite 
ROW_NUMBER() function is used to calculate movie rank as 10 movies can be easily taken off the result, 
else 10 ranks would span over 40 rows as in the case of DENSE_RANK(). 
Using INNER JOIN to join tables movie and ratings.
*/
WITH movie_rank_by_avg_rating AS(
SELECT title, avg_rating, ROW_NUMBER() OVER(ORDER BY avg_rating DESC) AS movie_rank 
FROM movie AS m
INNER JOIN
ratings AS r
ON m.id=r.movie_id
)
SELECT 
    title, avg_rating, movie_rank
FROM
    movie_rank_by_avg_rating
WHERE
    movie_rank <= 10;

/* Result of the above query
title								avg_rating				movie_rank
Kirket								10.0					1
Love in Kilnerry					10.0					2
Gini Helida Kathe					9.8						3
Runam								9.7						4
Fan									9.6						5
Android Kunjappan Version 5.25		9.6						6
Yeh Suhaagraat Impossible			9.5						7
Safe								9.5						8
The Brighton Miracle				9.5						9
Shibu								9.4						10

*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? 
If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors 
can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- counting the number of movies having a particular median rating
SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;

/*
median_rating	movie_count
1				94
2				119
3				283
4				479
5				985
6				1975
7				2257
8				1030
9				429
10				346

*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
/* using CTE to avoid use of LIMIT clause. using INNER JOIN on tables movie and ratings. using DENSE_RANK() 
function to rank production companies having avg rating > 8 and highest count of movies. Company with rank 1
is the best production company.
*/
WITH prod_company_summary AS(
SELECT m.production_company, COUNT(m.id) AS movie_count, 
DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM movie as m
INNER JOIN
ratings as r
ON m.id=r.movie_id
WHERE r.avg_rating > 8 AND m.production_company IS NOT NULL
GROUP BY production_company
)
SELECT 
    *
FROM
    prod_company_summary
WHERE
    prod_company_rank = 1;

/* Result of above query
production_company		movie_count	prod_company_rank
Dream Warrior Pictures	3			1
National Theatre Live	3			1

*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* Finding movies by genre that garnered more than 1000 votes, and was released in the US, in the March of 2017
tables genre, movie, and ratings are joined by INNER JOIN to extract the desired results.
*/
SELECT 
    g.genre, COUNT(g.movie_id) AS movie_count
FROM
    genre AS g
        INNER JOIN
    movie AS m ON g.movie_id = m.id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.country LIKE '%usa%'
        AND MONTH(date_published) = 3
        AND year = 2017
        AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;

/* Result of above query
# genre		movie_count
Drama		24
Comedy		9
Action		8
Thriller	8
Sci-Fi		7
Crime		6
Horror		6
Mystery		4
Romance		4
Fantasy		3
Adventure	3
Family		1

*/
-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
/* Joining tables ratings, movie, and genre by INNER JOIN to extract the desired results. Movies with 
average rating > 8 are chosen, and so also movies starting with the word 'The'
*/

SELECT 
    m.title, r.avg_rating, g.genre
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
        INNER JOIN
    genre AS g ON m.id = g.movie_id
WHERE
    m.title LIKE 'The%'
        AND r.avg_rating > 8
GROUP BY title
ORDER BY avg_rating DESC;

/* Result of the above query
title									avg_rating	genre
The Brighton Miracle					9.5			Drama
The Colour of Darkness					9.1			Drama
The Blue Elephant 2						8.8			Drama
The Irishman							8.7			Crime
The Mystery of Godliness: The Sequel	8.5			Drama
The Gambinos							8.4			Crime
Theeran Adhigaaram Ondru				8.3			Action
The King and I							8.2			Drama

*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
/* Tables movie and ratings are joined by INNER JOIN to extract the desired results. The BETWEEN operator is
used to search a period between two dates for movies with a median rating of 8. 
*/
SELECT 
    r.median_rating, COUNT(m.id) AS movie_count
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND r.median_rating = 8
GROUP BY median_rating;

/* Result of the above query
median_rating	movie_count
8				361

*/

-- result of the query is 361

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
/* Tables ratings and movie are joined by INNER JOIN to extract the required details. The votes earned
for movies with country as Germany and Italy are totalled to figure out who earned the larger votes.
*/
SELECT 
    m.country, SUM(r.total_votes) AS total_votes
FROM
    ratings AS r
        INNER JOIN
    movie AS m ON m.id = r.movie_id
WHERE
    m.country LIKE 'germany' OR m.country LIKE 'italy'
GROUP BY m.country;

/*
country		total_votes
Germany		106710
Italy		77965

*/
-- German movies have more votes than Italian movies

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
/* Case statement is used to tabulate the desired results.
*/
SELECT 
    COUNT(CASE
        WHEN name IS NULL THEN 1
    END) AS name_nulls,
    COUNT(CASE
        WHEN height IS NULL THEN 1
    END) AS height_nulls,
    COUNT(CASE
        WHEN date_of_birth IS NULL THEN 1
    END) AS date_of_birth_nulls,
    COUNT(CASE
        WHEN known_for_movies IS NULL THEN 1
    END) AS known_for_movies_nulls
FROM
    names;

/* Result of the above query
# name_nulls	height_nulls	date_of_birth_nulls		known_for_movies_nulls
0				17335			13431					15226

*/


/* There are no Null value in the column 'name'.

The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* CTE is used to find the best 3 genres, and these genres are used to extract the best director who has average
rating > 8 and highest movie count. Avoiding use of LIMIT clause
*/

WITH best_of_genres AS (
SELECT g.genre, COUNT(m.id) AS movie_count, 
RANK() OVER(ORDER BY COUNT(m.id) DESC) AS rank_of_genre
FROM movie AS m
INNER JOIN
genre AS g
ON m.id=g.movie_id
INNER JOIN
ratings AS r
ON m.id=r.movie_id
WHERE avg_rating > 8
GROUP BY genre
), best_3_genres AS (
SELECT 
    genre
FROM
    best_of_genres
WHERE
    rank_of_genre < 4
), director_summary AS (
SELECT 
    n.name AS director_name, COUNT(d.movie_id) AS movie_count,
    ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_rank
FROM
    director_mapping AS d
        INNER JOIN
    genre AS g ON d.movie_id = g.movie_id
        INNER JOIN
    names AS n ON n.id = d.name_id
        INNER JOIN
    best_3_genres AS bg ON g.genre = bg.genre
        INNER JOIN
    ratings AS r ON r.movie_id = d.movie_id
WHERE
    avg_rating > 8 
GROUP BY name
ORDER BY movie_count DESC
)
SELECT 
    director_name, movie_count
FROM
    director_summary
WHERE
    director_rank < 4;

/* Result of the above query
director_name	movie_count
James Mangold	4
Anthony Russo	3
Soubin Shahir	3
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
/* 
using tables movie, role_mapping, and ratings and joining them by INNER JOIN to extract the required details.
using ROW_NUMBER() function to rank actors. CTE used to avoid using LIMIT.
*/
WITH actor_summary AS (
SELECT 
    n.name AS actor_name, COUNT(m.id) AS movie_count,
    ROW_NUMBER() OVER(ORDER BY COUNT(m.id) DESC) AS actor_rank
FROM
    names AS n
        INNER JOIN
    role_mapping AS rm ON n.id = rm.name_id
        INNER JOIN
    movie AS m ON m.id = rm.movie_id
        INNER JOIN
    ratings AS r ON r.movie_id = rm.movie_id
WHERE
    r.median_rating >= 8 AND rm.category = 'actor'
GROUP BY name
ORDER BY movie_count DESC
) SELECT 
    actor_name, movie_count
FROM
    actor_summary
WHERE
    actor_rank <3;


/* Result of the above query
name		movie_count
Mammootty	8
Mohanlal	5
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
/* Tables movie and ratings are joined by INNER JOIN to extract the production houses' movies that received the 
maximum votes. 
*/

WITH best_production_companies AS (
SELECT production_company, SUM(total_votes) AS vote_count, 
RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN
ratings AS r
ON m.id=r.movie_id
GROUP BY production_company
)
SELECT 
    production_company, vote_count, prod_comp_rank
FROM
    best_production_companies
WHERE
    prod_comp_rank < 4;

/* Result of the above query
production_company		vote_count	prod_comp_rank
Marvel Studios			2656967		1
Twentieth Century Fox	2411163		2
Warner Bros.			2396057		3

*/
/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
/* 
Observation: The ratings table has ratings only for movies. Individual ratings of actors, actresses, 
or directors are absent. All rating analysis being done for an actor, actress, or director is 
using the rating of the particular movie or movies, they have been associated with. Hence a column name like
actor_avg_rating is inappropriate and misleading.

CTE is used to calculate weighted average based on votes, RANK() function is used to calculate the rank.
*/
WITH actor_rating AS (
SELECT n.name AS actor_name, SUM(r.total_votes) AS total_votes, COUNT(m.id) AS movie_count, 
ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating,
RANK() OVER(ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actor_rank
FROM names AS n
INNER JOIN
role_mapping AS rm
ON n.id=rm.name_id
INNER JOIN
movie AS m
ON m.id=rm.movie_id
INNER JOIN
ratings AS r
ON r.movie_id=m.id
WHERE rm.category = 'actor'
GROUP BY name
HAVING movie_count >=5
)
SELECT 
    actor_name, total_votes, movie_count, actor_avg_rating, actor_rank
FROM
    actor_rating
WHERE
    actor_rank = 1;
    
/*
actor_name			total_votes		movie_count		actor_avg_rating	actor_rank
Vijay Sethupathi	23114			5				8.42				1

*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
/*
Observation: The ratings table has ratings only for movies. Individual ratings of actors, actresses, 
or directors are absent. All rating analysis being done for an actor, actress, or director is using 
the rating of the particular movie or movies, they have been associated with. The question clearly hints
about use of the movie's ratings, but the name of the column like actress_avg_rating is deceptive.

Using CTE to avoid using LIMIT. Using RANK() function to generate rank of actresses on weighted average
based on votes.
*/
WITH actress_rating AS (
SELECT 
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes),
            2) AS actress_avg_rating,
	RANK() OVER(ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes),
            2) DESC, SUM(r.total_votes) DESC) AS actress_rank
FROM
    names AS n
        INNER JOIN
    role_mapping AS rm ON n.id = rm.name_id
        INNER JOIN
    movie AS m ON m.id = rm.movie_id
        INNER JOIN
    ratings AS r ON r.movie_id = m.id
WHERE
    rm.category = 'actress'
        AND m.country LIKE 'india'
        AND languages LIKE 'hindi'
GROUP BY name
HAVING movie_count >= 3
)
SELECT 
    actress_name, total_votes, movie_count, actress_avg_rating, actress_rank
FROM
    actress_rating
WHERE
    actress_rank < 6;

/* Result of the above query
# actress_name	total_votes	movie_count	actress_avg_rating	actress_rank
Taapsee Pannu	18061		3			7.74				1
Divya Dutta		8579		3			6.88				2
Kriti Kharbanda	2549		3			4.80				3
Sonakshi Sinha	4025		4			4.18				4

*/

/* Taapsee Pannu tops with average rating 7.74. 

Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
/*
Using CTE to extract 'thriller' movies and using CASE statement to classify them into various categories
*/
WITH thriller_genre_movies AS (
SELECT 
    DISTINCT title, avg_rating
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
        INNER JOIN
    genre AS g USING (movie_id)
WHERE
    g.genre LIKE 'thriller'
)
SELECT 
    *,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS movie_classification
FROM
    thriller_genre_movies;

/* Partial selection of the result of the above query
title			avg_rating			movie_classification
Der müde Tod	7.7					Hit movies
Fahrenheit 451	4.9					Flop movies
Pet Sematary	5.8					One-time-watch movies
Rakshasudu		8.4					Superhit movies

*/
/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH genre_summary AS (
SELECT g.genre, 
	ROUND(AVG(m.duration)) AS avg_duration, 
	SUM(ROUND(AVG(duration), 1)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration, 
	AVG(ROUND(AVG(duration), 2)) OVER(ORDER BY genre ROWS 5 PRECEDING) AS moving_avg_duration_temp
FROM movie AS m
INNER JOIN
genre AS g
ON g.movie_id=m.id
GROUP BY genre
)
SELECT 
    genre,
    avg_duration,
    running_total_duration,
    ROUND(moving_avg_duration_temp, 2) AS moving_avg_duration
FROM
    genre_summary;

/*
genre		avg_duration	running_total_duration	moving_avg_duration
Action		113				112.9					112.88
Adventure	102				214.8					107.38
Comedy		103				317.4					105.79
Crime		107				424.5					106.11
Drama		107				531.3					106.24
Family		101				632.3					105.36
Fantasy		105				737.4					104.07
Horror		93				830.1					102.55
Mystery		102				931.9					102.41
Others		100				1032.1					101.26
Romance		110				1141.6					101.72
Sci-Fi		98				1239.5					101.22
Thriller	102				1341.1					100.62


*/

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
/*
Using CTE to get top 3 genres based on most number of movies
using REPLACE() function to work on data real-time without modifying data in the database 
to replace occurence of 'INR' and '$' with empty space('').
using IFNULL() function to replace null values in column worlwide_gross_income in real-time 
with 0, without making changes to data in the database.
using DENSE_RANK() function to get rank without skipping of ranks
using CAST() function; CAST(expression AS datatype(length)) to convert string to decimal
using CONCAT() function to insert '$' while displaying worlwide_gross_income
*/

WITH best_of_genres AS (
SELECT g.genre, COUNT(m.id) AS movie_count, 
RANK() OVER(ORDER BY COUNT(m.id) DESC) AS rank_of_genre
FROM movie AS m
INNER JOIN
genre AS g
ON m.id=g.movie_id
INNER JOIN
ratings AS r
ON m.id=r.movie_id
GROUP BY genre
), 
required_movies AS (
SELECT genre, year, title AS movie_name, 
CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income, 0), 'INR', ''), '$', '') AS DECIMAL(10)) AS worlwide_gross_income_temp, 
DENSE_RANK() OVER(PARTITION BY year ORDER BY CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income, 0), 'INR', ''), '$', '') AS DECIMAL(10)) DESC) AS movie_rank
FROM movie AS m
INNER JOIN
genre AS g
ON m.id=g.movie_id
WHERE g.genre IN (SELECT genre FROM best_of_genres WHERE rank_of_genre < 4)
GROUP BY movie_name
)
SELECT 
    genre,
    year,
    movie_name,
    CONCAT('$', '', worlwide_gross_income_temp) AS worlwide_gross_income,
    movie_rank
FROM
    required_movies
WHERE
    movie_rank <= 5
ORDER BY YEAR;

/* Result of the above query
genre		year	movie_name							worlwide_gross_income	movie_rank
Thriller	2017	The Fate of the Furious				$1236005118				1
Comedy		2017	Despicable Me 3						$1034799409				2
Comedy		2017	Jumanji: Welcome to the Jungle		$962102237				3
Drama		2017	Zhan lang II						$870325439				4
Comedy		2017	Guardians of the Galaxy Vol. 2		$863756051				5
Thriller	2018	The Villain							$1300000000				1
Drama		2018	Bohemian Rhapsody					$903655259				2
Thriller	2018	Venom								$856085151				3
Thriller	2018	Mission: Impossible - Fallout		$791115104				4
Comedy		2018	Deadpool 2							$785046920				5
Drama		2019	Avengers: Endgame					$2797800564				1
Drama		2019	The Lion King						$1655156910				2
Comedy		2019	Toy Story 4							$1073168585				3
Drama		2019	Joker								$995064593				4
Thriller	2019	Ne Zha zhi mo tong jiang shi		$700547754				5

*/

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- using POSITION() function to determine existence of multiple langauges separated by a comma ','
WITH best_multilingual_PCs AS (
SELECT 
    production_company, COUNT(id) AS movie_count
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    POSITION(',' IN m.languages) > 0
        AND r.median_rating >= 8
        AND production_company IS NOT NULL
GROUP BY production_company
ORDER BY movie_count DESC
), prod_comp_rank_summary AS (
SELECT *, 
DENSE_RANK() OVER(ORDER BY movie_count DESC) AS prod_comp_rank
FROM best_multilingual_PCs
)
SELECT 
    production_company, movie_count, prod_comp_rank
FROM
    prod_comp_rank_summary
WHERE
    prod_comp_rank < 3;

/* Result of the above query
production_company		movie_count		prod_comp_rank
Star Cinema				7				1
Twentieth Century Fox	4				2

*/

-- Ans: Star Cinema and Twentieth Century Fox occupy the first two spots.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+
*/
-- Type your code below:
/*
Observation: The ratings table has ratings only for movies. Individual ratings of actors, actresses, 
or directors are absent. All rating analysis being done for an actor, actress, or director 
is using the rating of the particular movie or movies, they have been associated with. Hence using a name
like actress_avg_rating to name a column is misleading.

Using CTE to avoid using LIMIT. Using ROW_NUMBER() function to calculate rank. 
*/
WITH best_actresses AS (
SELECT 
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(AVG(r.avg_rating), 2) AS actress_avg_rating,
    ROW_NUMBER() OVER(ORDER BY COUNT(m.id) DESC, SUM(r.total_votes) DESC) AS actress_rank
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
        INNER JOIN
    genre AS g USING (movie_id)
        INNER JOIN
    role_mapping AS rm USING (movie_id)
        INNER JOIN
    names AS n ON n.id = rm.name_id
WHERE
    g.genre LIKE 'drama'
        AND r.avg_rating > 8
        AND rm.category LIKE 'actress'
GROUP BY n.id
) 
SELECT 
    actress_name, total_votes, movie_count, actress_avg_rating, actress_rank
FROM
    best_actresses
WHERE
    actress_rank < 4;
    


/* Result of the above query
actress_name			total_votes		movie_count		actress_avg_rating		actress_rank
Parvathy Thiruvothu		4974			2				8.20					1
Susan Brown				656				2				8.95					2
Amanda Lawrence			656				2				8.95					3

*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
/* creating partition over director_id to retrieve values only in relation to that particular director;
   using LEAD() window function to get publish date of next movie and place it within the same 
   row of a particular director for finding date difference at a later time.
*/

WITH director_movie_date_details AS (
SELECT dm.name_id AS director_id, 
n.name AS director_name, dm.movie_id, m.title, r.avg_rating, r.total_votes, r.median_rating, m.duration, m.date_published, 
LEAD(date_published, 1) OVER(PARTITION BY dm.name_id ORDER BY date_published) AS next_movie_publish_date
FROM director_mapping AS dm
INNER JOIN
names AS n
ON n.id=dm.name_id
INNER JOIN 
movie AS m
ON m.id=dm.movie_id
INNER JOIN
ratings AS r
ON m.id=r.movie_id
), 
-- using DATEDIFF() function to calculate the no of days elapsed between publishing of the director's next movie and the one published just before that.
director_movie_after_date_diff AS (
SELECT *, DATEDIFF(next_movie_publish_date, date_published) AS difference_of_published_dates
FROM director_movie_date_details
), director_summary AS (
SELECT director_id, director_name, COUNT(movie_id) AS number_of_movies, 
ROUND(AVG(difference_of_published_dates), 2) AS avg_inter_movie_days_temp, ROUND(SUM(avg_rating*total_votes)/SUM(total_votes), 2) AS avg_rating, 
SUM(total_votes) AS total_votes,  MIN(avg_rating) AS min_rating, MAX(avg_rating) AS max_rating, SUM(duration) AS total_duration
FROM director_movie_after_date_diff
GROUP BY director_id
-- ORDER BY number_of_movies DESC
), director_rank_summary AS (
SELECT *, DENSE_RANK() OVER(ORDER BY number_of_movies DESC, avg_rating DESC) AS director_rank
FROM director_summary
)
SELECT 
    director_id,
    director_name,
    number_of_movies,
    ROUND(avg_inter_movie_days_temp) AS avg_inter_movie_days,
    avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration
FROM
    director_rank_summary
WHERE
    director_rank < 10;

/* Result of the above query
director_id	director_name		number_of_movies	avg_inter_movie_days	avg_rating	total_votes	min_rating	max_rating	total_duration
nm1777967	A.L. Vijay			5					177						5.65		1754		3.7			6.9			613
nm2096009	Andrew Jones		5					191						3.04		1989		2.7			3.2			432
nm0001752	Steven Soderbergh	4					254						6.77		171684		6.2			7.0			401
nm0515005	Sam Liu				4					260						6.32		28557		5.8			6.7			312
nm0814469	Sion Sono			4					331						6.31		2972		5.4			6.4			502
nm0425364	Jesse V. Johnson	4					299						6.10		14778		4.2			6.5			383
nm2691863	Justin Price		4					315						4.93		5343		3.0			5.8			346
nm0831321	Chris Stokes		4					198						4.32		3664		4.0			4.6			352
nm6356309	Özgür Bakar			4					112						3.96		1092		3.1			4.9			374


*/
 

