use sakila;

-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*) AS number_of_copies
FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

-- List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id 
    FROM film_actor 
    WHERE film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip')
);

-- Identify all movies categorized as family films.
SELECT film.title AS Family_Films
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

-- Retrieve the name and email of customers from Canada using both subqueries and joins.
-- Using subqueries
SELECT first_name, last_name, email 
FROM customer 
WHERE address_id IN (
    SELECT address_id 
    FROM address 
    WHERE city_id IN (
        SELECT city_id 
        FROM city 
        WHERE country_id = (SELECT country_id FROM country WHERE country = 'Canada')
    )
);

-- using joins
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- Determine which films were starred by the most prolific actor in the Sakila database.
SELECT film.title 
FROM film 
JOIN film_actor ON film.film_id = film_actor.film_id 
WHERE film_actor.actor_id = (SELECT actor_id 
                     FROM film_actor 
                     GROUP BY actor_id 
                     ORDER BY COUNT(film_id) DESC 
                     LIMIT 1);

-- Find the films rented by the most profitable customer in the Sakila database.
SELECT film.title 
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON iinventory.film_id = film.film_id
WHERE rental.customer_id = (SELECT customer_id 
                       FROM payment 
                       GROUP BY customer_id 
                       ORDER BY SUM(amount) DESC 
                       LIMIT 1);
                       
-- Retrieve the client ID and total amount spent for clients who spent more than the average total amount spent by each client.    
SELECT customer_id, total_spent 
FROM (
    SELECT customer_id, SUM(amount) AS total_spent 
    FROM payment 
    GROUP BY customer_id
) AS customer_totals
WHERE total_spent > (SELECT AVG(total_spent) 
                     FROM (
                         SELECT SUM(amount) AS total_spent 
                         FROM payment 
                         GROUP BY customer_id
                     ) AS avg_totals);