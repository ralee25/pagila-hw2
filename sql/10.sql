/*
 * Management is planning on purchasing new inventory.
 * Films with special features cost more to purchase than films without special features,
 * and so management wants to know if the addition of special features impacts revenue from movies.
 *
 * Write a query that for each special_feature, calculates the total profit of all movies rented with that special feature.
 *
 * HINT:
 * Start with the query you created in pagila-hw1 problem 16, but add the special_features column to the output.
 * Use this query as a subquery in a select statement similar to answer to the previous problem.
 */

SELECT sf.special_feature, SUM(fp.profit) AS profit
FROM (
    SELECT f.film_id, f.title, f.special_features, SUM(p.amount) AS profit
    FROM film AS f
    JOIN inventory AS i ON f.film_id = i.film_id
    JOIN rental AS r ON i.inventory_id = r.inventory_id
    JOIN payment AS p ON r.rental_id = p.rental_id
    GROUP BY f.film_id, f.title, f.special_features
) AS fp
CROSS JOIN LATERAL unnest(fp.special_features) AS sf(special_feature)
GROUP BY sf.special_feature
ORDER BY sf.special_feature;

