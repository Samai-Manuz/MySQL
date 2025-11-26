# Evaluación Final Módulo 2: SQL

-- Ejercicio Samai --

use sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

select * from film;

select distinct title
from film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

select title, rating
from film
where rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la cadena de caracteres "amazing" en su descripción.

select title, description
from film
where description like "%amazing%"
order by title desc;

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

select title, length
from film
where length >= 120
order by length;

-- 5. Recupera los nombres y apellidos de todos los actores.

select * from actor;

select first_name, last_name
from actor;

-- 6. Encuentra el nombre y apellidos de los actores que tengan "Gibson" en su apellido.

select first_name, last_name
from actor
where last_name = "Gibson"; /* like "Gibson" o in ("Gibson") */

-- 7. Encuentra los nombres y apellidos de los actores que tengan un actor_id entre 10 y 20.

select first_name, last_name, actor_id
from actor
where actor_id between 10 and 20;

-- 8. Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

select * from film;

select title, rating
from film
where rating not in ("R","PG-13"); /* También lo podría hacer con != pero tendría que repetir el rating para cada valor */

/* Versión con union*/

select title, rating 
from film 
where rating = 'G'
union 
select title, rating 
from film 
where rating = 'PG'
union 
select title, rating 
from film 
where rating = 'NC-17'
order by title;

-- Union all

select title, rating 
from film 
where rating = 'G'
union all
select title, rating 
from film 
where rating = 'PG'
union all
select title, rating 
from film 
where rating = 'NC-17'
order by title;

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento.

select rating, count(film_id) as rating_movie_count
from film
where rating in ("PG-13", "R")
group by rating
having rating_movie_count > 200
order by rating_movie_count desc;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

select * from customer;
select * from rental;

select c.customer_id, concat(c.first_name, " ", c.last_name) as full_name, count(r.rental_id) as total_movies_rental
from customer c
inner join rental r
on c.customer_id = r.customer_id
group by c.customer_id
order by total_movies_rental desc;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

select * from category;
select * from rental;
select * from film_category;
select * from film;
select * from inventory;

select cat.name as category_name, count(r.rental_id) as total_rentals
from category cat
inner join film_category fc
on cat.category_id = fc.category_id
inner join film f
on fc.film_id = f.film_id
inner join inventory i
on f.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
group by cat.name
order by total_rentals desc;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla `film` y muestra la clasificación junto con el promedio de duración.

select * from film;

select rating, avg(length) as avg_duration
from film
group by rating
order by avg_duration desc;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

select * from actor;
select * from film;
select * from film_actor;

select f.title, concat(a.first_name, " ", a.last_name) as actor_or_actress
from film f
inner join film_actor fa
on f.film_id = fa.film_id
inner join actor a 
on fa.actor_id = a.actor_id
where f.title = "Indian Love";

-- 14. Muestra el título de todas las películas que contengan la cadena de caracteres "dog" o "cat" en su descripción.

select title, description
from film
where description regexp 'dog|cat'; /* También podría ser con "description like '%dog%'", pero tendría que repetir el "or description" para cat */

/* Versión con union */

select title, description 
from film 
where description like '%dog%'
union
select title, description 
from film 
where description like '%cat%';

-- 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla `film_actor`.

select * from actor;
select * from film_actor;

select concat(a.first_name, " ", a.last_name) as full_name
from actor a
left join film_actor fa
on a.actor_id = fa.actor_id
where fa.film_id is null;

/* Como no me devuelve ningún resultado, no sé si es verdad que no hay ningún actor a 0 pelis o que lo he hecho mal, así que hago otra consulta para contar las películas de cada actor: */

select concat(a.first_name, " ", a.last_name) as full_name, count(fa.film_id) as total_movies
from actor a
left join film_actor fa
on a.actor_id = fa.actor_id
group by a.actor_id
order by total_movies; /* Como la que menos, tiene 14 pelis, es que la consulta anterior estaba bien */

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

select * from film;

select title, release_year
from film
where release_year between 2005 and 2010
order by release_year;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

select * from film;
select * from film_category;
select * from category;

select f.title, cat.name
from film f
inner join film_category fc
on f.film_id = fc.film_id
inner join category cat
on fc.category_id = cat.category_id
where cat.name = "family";

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

select concat(a.first_name, " ", a.last_name) as full_name, count(fa.film_id) as total_movies
from actor a
left join film_actor fa
on a.actor_id = fa.actor_id
group by a.actor_id
having total_movies > 10
order by total_movies;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla `film`.

select * from film;

select title, rating, length 
from film
where rating = "R" and length > 120
order by length;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

select * from film;
select * from category;
select * from film_category;

select cat.name, avg(f.length) as average_duration
from category cat
inner join film_category fc
on cat.category_id = fc.category_id
inner join film f 
on fc.film_id = f.film_id
group by cat.name
having average_duration > 120
order by average_duration desc;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

select * from actor;
select * from film_actor;

select concat(a.first_name, " ", a.last_name) as full_name, count(fa.film_id) as total_movies
from actor a
inner join film_actor fa
on a.actor_id = fa.actor_id
group by a.actor_id
having total_movies >= 5
order by total_movies;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
--     Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

select * from film;
select * from rental;
select * from inventory;

select f.title, max(datediff(r.return_date, r.rental_date)) as max_days_rented
from film f
join inventory i 
on i.film_id = f.film_id
join rental r   
on r.inventory_id = i.inventory_id
where r.rental_id in (
  select rental_id
  from rental
  where datediff(return_date, rental_date) > 5)
group by f.film_id
order by max_days_rented;

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
--     Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

select * from actor;
select * from category;
select * from film_actor;
select * from film_category;

select concat(a.first_name, " ", a.last_name) as full_name
from actor a
where not exists (
  select fa.actor_id /* Sé que la convención es usar el 1 pero a mí me queda más claro así */
  from film_actor fa
  join film_category fc 
  on fa.film_id = fc.film_id
  join category cat     
  on fc.category_id = cat.category_id
  where fa.actor_id = a.actor_id and c.name = 'Horror')
order by full_name;

/* Se me ocurrió añadir una columna al select de la columna original donde aparezcan las categorías donde sí han actuado esos actores para confirmar que "Horror" no está entre ellas.
Pensé que podría hacerse con la función concat y le pregunté a ChatGPT, que me dijo que necesitaba un group_concat, y para lo cual necesitaría hacer toda la cadena de joins en la consulta original
con alias diferentes (2) de las tablas, para no confundirse con los de la subconsulta. */

select concat(a.first_name, " ", a.last_name) as full_name, group_concat(distinct c2.name order by c2.name separator ', ') as categories
from actor a
join film_actor fa2
  on fa2.actor_id = a.actor_id
join film_category fc2
  on fc2.film_id = fa2.film_id
join category c2
  on c2.category_id = fc2.category_id
where not exists (
  select fa.actor_id
  from film_actor fa
  join film_category fc on fc.film_id = fa.film_id
  join category c      on c.category_id = fc.category_id
  where fa.actor_id = a.actor_id
    and c.name = 'Horror'
)
group by a.actor_id
order by full_name;

-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla `film`.

select * from film;
select * from film_category;
select * from category;

select f.title, cat.name as category, f.length
from film f
inner join film_category fc
on f.film_id = fc.film_id
inner join category cat
on fc.category_id = cat.category_id
where cat.name = 'Comedy' and f.length > 180
order by f.length;


# ¡¡¡Esto es to, esto es to, esto es todo, amigos!!!
