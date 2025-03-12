/*
 * This problem is the same as 07.sql,
 * but instead of using the NOT IN operator, you are to use a LEFT JOIN.
 */

SELECT f.title
FROM film AS f
JOIN inventory AS i
  ON f.film_id = i.film_id
LEFT JOIN rental AS r
  ON i.inventory_id = r.inventory_id
LEFT JOIN customer AS c
  ON r.customer_id = c.customer_id
LEFT JOIN address AS a
  ON c.address_id = a.address_id
LEFT JOIN city AS ci
  ON a.city_id = ci.city_id
LEFT JOIN country AS co
  ON ci.country_id = co.country_id
     AND co.country = 'United States'
GROUP BY f.title
HAVING COUNT(co.country) = 0
ORDER BY f.title;

