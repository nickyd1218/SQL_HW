-- 1a Display First Name and Last Name --
use sakila;
select first_name, last_name 
from actor;

-- 1b Display First and Last name as Actor --
select concat(first_name,' ',last_name) as 'Actor'
from actor;

--  2a Find the ID number, first name, and last name of actor with first name Joe
select actor_id, first_name, last_name 
from actor
where first_name = 'Joe';

-- 2b Find all actors whose last name contain the letters GEN --
select first_name, last_name
from actor
where last_name like '%GEN%';

-- 2c Find all actors whose last names contain the letters LI, 
-- order rows by last name, first name
select last_name, first_name
from actor
where last_name like '%LI%';

-- 2d  Using IN, display the country_id and country columns of the
 -- following countries: Afghanistan, Bangladesh, and China:
select country_id, country 
from country
where country in (
'Afghanistan',
'Bangladesh',
'China');

-- 3a Create column in Actor called description dtype blob  --
alter table actor
add column description BLOB;

-- 3b Delete description column --
alter table actor
drop description;

-- 4a list the names of actors, as well as how many actors have that name --
select last_name,
count(last_name)
from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have
--  that last name, but only for names that are shared by at least two actors --
select last_name,
count(last_name) as 'count'
from actor
group by last_name
having count > 1;

-- 4c replace Harpo Williams with Groucho Williams --
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO'and last_name = 'WILLIAMS';

-- 4d  if the first name of the actor is currently HARPO, 
-- change it to GROUCHO

update actor
set first_name = 'GROUCHO'
where last_name = 'HARPO' and last_name = 'WILLIAMS';

-- 5a Locate address schema
show create table address;

-- 6a  Use JOIN to display the first and last names, 
-- as well as the address, of each staff member.
select s.first_name, s.last_name, a.address
from staff s
join address a on s.address_id = a.address_id;

-- 6b  Use JOIN to display the total amount rung up by each 
-- staff member in August of 2005.
select s.first_name, s.last_name, sum(p.amount)
from staff s
join payment p on s.staff_id = p.staff_id
group by s.first_name, s.last_name;

-- 6c List each film and the number of actors who are listed for that film. 
select f.title, count(distinct f_a.actor_id)
from film f
join film_actor f_a ON f.film_id = f_a.film_id
group by f.title;

-- 6d How many copies of Hunchback Impossible exist?
select count(i.inventory_id) as '# of Copies', f.title
from inventory i
join film f ON i.film_id = f.film_id
where f.title = 'Hunchback Impossible';

-- 6e  list the total paid by each customer
select c.first_name, c.last_name, sum(p.amount) as 'Total $ Paid'
from customer c
join payment p on c.customer_id = p.customer_id
group by c.first_name, c.last_name;

-- 7a Use subqueries to display the titles of movies starting with 
-- the letters K and Q whose language is English.
select title from film
where title in(
	select title 
    from film
		where(title like 'K%' OR title like 'Q%')
        and language_id in (
        
        select language_id
        from language
        where name = 'English'));

-- 7b Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name
from actor
where actor_id in(
	select actor_id
	from film_actor
	where film_id in (
		select film_id
        from film
        where title = 'Alone Trip'));

-- 7c names and email addresses of all Canadian customers
select concat(cu.first_name,' ', cu.last_name) as 'Customer_Name', cu.email
from customer cu
join address a on
cu.address_id = a.address_id
join city c on a.city_id = c.city_id
join country co on c.country_id
where co.country = 'Canada';

-- 7d Identify all movies categorized as family films.
select *from film f
join film_category c on f.film_id = c.film_id
join category ca on c.category_id = ca.category_id
where ca.name = 'Family';

-- 7e Display the most frequently rented movies in descending order.
select title, rental_rate
from film
order by rental_rate desc;

-- 7f Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(p.amount) as 'total'
from store s
join customer c on s.store_id = c.store_id
join payment p on c.customer_id = p.customer_id
group by s.store_id;

-- 7g Write a query to display for each store its store ID, city, and country.
select s.store_id, c.city,co.country
from store s 
join address a on s.address_id = a.address_id
join city c on a.city_id = c.city_id
join country co on c.country_id = co.country_id;

-- 7h List the top five genres in gross revenue in descending order
select c.name, sum(p.amount) as 'Total'
from category c
join film_category f_c on c.category_id = f_c.category_id
join inventory i on f_c.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by c.name
order by Total desc
limit 5; 
 
 -- 8a easy way of viewing the Top five genres by gross revenue. 
 create view v_top as
 select c.name, sum(p.amount) as 'Total'
 from category c
 join film_category f_c on c.category_id = f_c.category_id
 join inventory i on f_c.film_id = i.film_id
 join rental r on i.inventory_id = r.inventory_id
 join payment p on r.rental_id = p.rental_id
 group by c.name
 order by Total desc
 limit 5;
 
 -- 8b display new view
 select * from v_top;
 
 -- 8c delete view
 drop view if exists v_top;
 
 


