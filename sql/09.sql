/*
 * Count the number of movies that contain each type of special feature.
 * Order the results alphabetically be the special_feature.
 */

SELECT special_features, count
FROM (
    SELECT 'Trailers' AS special_features, COUNT(*) AS count
    FROM film
    WHERE 'Trailers' = ANY(special_features)
    UNION ALL
    SELECT 'Commentaries' AS special_features, COUNT(*) AS count
    FROM film
    WHERE 'Commentaries' = ANY(special_features)
    UNION ALL
    SELECT 'Deleted Scenes' AS special_features, COUNT(*) AS count
    FROM film
    WHERE 'Deleted Scenes' = ANY(special_features)
    UNION ALL
    SELECT 'Behind the Scenes' AS special_features, COUNT(*) AS count
    FROM film
    WHERE 'Behind the Scenes' = ANY(special_features)
) AS sf_counts
ORDER BY special_features;

