--display the customer names that share the same address
SELECT c1.first_name, c1.last_name,
	c2.first_name, c2.last_name
FROM customer c1
JOIN customer c2
ON c1.customer_id != c2.customer_id AND c1.address_id = c2.address_id


--customer who made the highest total payment
SELECT c. first_name, c. last_name
FROM customer c
JOIN(SELECT customer_id, SUM(amount) total_payment
FROM payment
GROUP BY customer_id
ORDER BY total_payment DESC LIMIT 1) as h
ON c.customer_id = h.customer_id


--movie that was rented the most
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 1;


--which movies have been rented so far
SELECT DISTINCT(f.title)
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
ORDER BY title


--which movies have not been rented so far
SELECT title
FROM film
WHERE film_id NOT IN(SELECT film_id
				FROM rental
				JOIN inventory
				ON rental.inventory_id = inventory.inventory_id)
ORDER BY title


--which customers have not rented any movies so far
SELECT first_name,last_name
FROM customer
WHERE customer_id NOT IN(SELECT DISTINCT customer_id
				FROM rental)


--display each movie and the number of times it got rented
SELECT f.title, COUNT(rental_id) times_rented
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY f.title DESC


--full name and number of films each actor acted in
SELECT a.first_name, a.last_name, COUNT(film_id) no_of_films
FROM film_actor f
JOIN actor a
ON f.actor_id = a.actor_id
GROUP BY a.first_name, a.last_name


--names of actor who aced in more than 20 films
SELECT a.first_name, a.last_name, COUNT(film_id) no_of_films
FROM film_actor f
JOIN actor a
ON f.actor_id = a.actor_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(film_id) > 20


--movie title and number of times rented for movies rated PG
SELECT f.title, COUNT(rental_id) times_rented
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
WHERE f.rating = 'PG'
GROUP BY f.title
ORDER BY f.title


--movies offered in store_id 1 and not offered in store_id 2
SELECT DISTINCT title
FROM film
WHERE film_id IN(SELECT film_id
				 FROM inventory
				 WHERE store_id = 1 AND film_id NOT IN(
				 SELECT film_id
				 FROM inventory
				 WHERE store_id = 2))
ORDER BY title DESC


--movies offered for rent in any of the two store 1 and 2
SELECT DISTINCT title
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
WHERE store_id = 1 OR store_id = 2
ORDER BY title


--display movie titles of movies offered in both stores at the same time
SELECT DISTINCT f.title
FROM film f
	JOIN inventory i1
	ON f.film_id = i1.film_id 
	AND i1.store_id = 1
		JOIN inventory i2
		ON f.film_id = i2.film_id
		AND i2.store_id = 2
ORDER BY f.title DESC


--movie that was rented the most
SELECT f.title
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
WHERE store_id = 1
GROUP BY f.title
ORDER BY COUNT(rental_id) DESC
LIMIT 1


--how many movies are not offered for rent in the stores yet
SELECT COUNT(film_id)
FROM film f
WHERE film_id NOT IN(SELECT film_id
					FROM inventory
					 WHERE store_id IN (1,2))


--number of rented movies under each rating
SELECT rating, COUNT(rental_id) no_of_rents
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON f.film_id = i.film_id
GROUP BY rating


--show the profit of each of the stores 1 and 2
SELECT store_id, SUM(amount) profit
FROM payment p
JOIN rental r
ON p.rental_id = r.rental_id
JOIN inventory i
ON r.inventory_id = i.inventory_id
GROUP BY store_id