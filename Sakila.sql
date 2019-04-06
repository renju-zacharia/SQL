
#1a. Display the first and last names of all actors from the table actor.

USE SAKILA;

SELECT first_name, last_name
FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. 
#    Name the column Actor Name.

SELECT CONCAT ( UPPER(first_name) , UPPER(last_name)) 'ACTOR NAME'
FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, 
#of whom you know only the first name, "Joe." 
#What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
from actor 
where first_name = 'joe';

#2b. Find all actors whose last name contain the letters GEN:

SELECT * FROM actor WHERE LAST_NAME LIKE '%GEN%';

#2c. Find all actors whose last names contain the letters LI. 
#This time, order the rows by last name and first name, in that order:

SELECT * FROM actor 
WHERE last_name LIKE '%LI%'
ORDER BY LAST_NAME, FIRST_NAME ;

#2d. Using IN, display the country_id and country columns of the following countries: 
#Afghanistan, Bangladesh, and China:

select country_id, country 
from country 
where country in ( 'Afghanistan' , 'Bangladesh' , 'China') ;

#3a. You want to keep a description of each actor. 
#You don't think you will be performing queries on a description, 
#so create a column in the table actor named description and use the data type BLOB 
#(Make sure to research the type BLOB, as the difference between it and VARCHAR are significant)

ALTER TABLE actor add column description BLOB;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
#Delete the description column.

alter table actor drop column description;

#4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, count(*) 
from actor
group by last_name; 

#4b. List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors

SELECT last_name, count(*) 
from actor
group by last_name
having count(*) > 1 ;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
#Write a query to fix the record.

update actor
set first_name = 'HARPO' 
where last_name = 'Williams'
and first_name = 'Groucho';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
#It turns out that GROUCHO was the correct name after all! In a single query, 
#if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor
set first_name = 'GROUCHO'
where  first_name ='HARPO';

#5a. You cannot locate the schema of the address table. 
#Which query would you use to re-create it?

SHOW CREATE TABLE actor;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
#Use the tables staff and address:

SELECT s.first_name, s.last_name, a.address, a.address2, a.district, a.postal_code
FROM staff s 
INNER JOIN address a 
ON s.address_id = a.address_id
;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
#Use tables staff and payment.

SELECT s.first_name, s.last_name, SUM(p.AMOUNT) as Total_Amnt_Aug2005
from staff s 
inner join payment p 
on s.staff_id = p.staff_id
and extract(year from payment_date) = 2005
and extract(month from payment_date) = 8
group by s.first_name, s.last_name
;

#6c. List each film and the number of actors who are listed for that film. 
#Use tables film_actor and film. Use inner join.

SELECT f.title, count(distinct (fa.actor_id ) ) as num_actors
from film f 
inner join film_actor fa
on f.film_id = fa.film_id
group by f.title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?

select f.title, count(inventory_id ) as num_copies
from inventory i 
inner join film f
on f.film_id = i.film_id 
and f.title = 'Hunchback Impossible'
group by f.title;

#6e. Using the tables payment and customer and the JOIN command, 
#list the total paid by each customer. List the customers alphabetically by last name:

select c.first_name, c.last_name, sum(amount) as total_payment
from customer c
inner join payment p
on c.customer_id = p.customer_id
group by c.first_name, c.last_name
order by c.last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

select title 
from film 
where title like 'K%'
or title like 'Q%'
and language_id in 
(
SELECT language_id
from language
where name = 'ENGLISH'
);

#7b. Use subqueries to display all actors who appear in the film Alone Trip.

select a.first_name, a.last_name
from actor a  
where actor_id in 
( select actor_id 
  from  film_actor
  where film_id in 
     (
		select film_id
		from film 
		where title = 'ALONE TRIP'
      )
 );

#7c. You want to run an email marketing campaign in Canada, for which 
# you will need the names and email addresses of all Canadian customers.
# Use joins to retrieve this information.

select c.first_name, c.last_name, c.email
from customer  c
inner join address  a
on c.address_id = a.address_id 
inner join city city
on a.city_id = city.city_id
inner join country country
on country.country_id = city.country_id 
and country.country = 'CANADA' 
;

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
select f.title
from film f
inner join film_category fc
on fc.film_id = f.film_id
inner join category  c
on fc.category_id = c.category_id
and c.name = 'Family'
;

#7e. Display the most frequently rented movies in descending order.

select f.title, count(r.rental_id) as num_rentals
from film f
inner join inventory i
on i.film_id = f.film_id
inner join rental r
on r.inventory_id = i.inventory_id 
group by f.title
order by num_rentals desc;

#7f. Write a query to display how much business, in dollars, each store brought in.
select i.store_id, sum(p.amount)
from inventory i
inner join rental r
on r.inventory_id = i.inventory_id
inner join payment p
on p.rental_id = r.rental_id
group by store_id;

#7g. Write a query to display for each store its store ID, city, and country.

select s.store_id, city.city, country.country
from store s
inner join address a 
on a.address_id = s.address_id
inner join city city
on city.city_id = a.city_id
inner join country country
on country.country_id = city.country_id;

#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT 
    c.name, SUM(amount) AS sum_payment
FROM
    film f
        INNER JOIN
    film_category fc ON fc.film_id = f.film_id
        INNER JOIN
    category c ON fc.category_id = c.category_id
        INNER JOIN
    inventory i ON i.film_id = f.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
        INNER JOIN
    payment p ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY sum_payment DESC
LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW TOP_FIVE_GENRES AS
SELECT 
    c.name, SUM(amount) AS sum_payment
FROM
    film f
        INNER JOIN
    film_category fc ON fc.film_id = f.film_id
        INNER JOIN
    category c ON fc.category_id = c.category_id
        INNER JOIN
    inventory i ON i.film_id = f.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
        INNER JOIN
    payment p ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY sum_payment DESC
LIMIT 5;

#8b. How would you display the view that you created in 8a?

SHOW CREATE VIEW TOP_FIVE_GENRES;
SELECT * FROM TOP_FIVE_GENRES;
DESCRIBE TOP_FIVE_GENRES;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW TOP_FIVE_GENRES;





