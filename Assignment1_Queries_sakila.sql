#Assignment 1
#1.Find out the PG-13 rated comedy movies. DO NOT use the film_list table.

select film.title 
from film inner join 
(select f.film_id 
from film_category as f inner join 
category as c where c.name = 'Comedy') as ft
where film.film_id = ft.film_id and film.rating = 'PG-13';



#2. Find out the top 3 rented horror movies

select f.title ,count(f.FID) as count
from rental as r inner join 
(select f.FID,f.title,i.inventory_id,f.category
from film_list as f inner join 
inventory as i 
where f.FID = i.film_id and f.category = 'Horror') as f
where f.inventory_id = r.inventory_id
group by f.title 
order by count desc 
limit 3;

#3. Find out the list of customers from India who have rented sports movies.

create view inventory_customer as
select i.film_id ,t.customer_id ,i.inventory_id
from inventory as i inner join 
(select c.customer_id,r.inventory_id
from customer as c inner join 
rental as r on 
c.customer_id = r.customer_id) as t 
on t.inventory_id = i.inventory_id;

select c.name from 
customer_list as c inner join 
(select distinct ic.customer_id
from inventory_customer as ic inner join 
(select FID from film_list where category like 'sports') as s
on s.FID = ic.film_id ) as t 
on t.customer_id = c.ID and c.country = 'India';



#4. Find out the list of customers from Canada who have rented “NICK WAHLBERG” movies.


select fa.film_id
from actor as a inner join 
film_actor as fa
On a.actor_id = fa.actor_id and a.first_name = 'NICK' and a.last_name = 'WAHLBERG';

select ic.customer_id
from inventory_customer as ic inner join 
(select fa.film_id
from actor as a inner join 
film_actor as fa
On a.actor_id = fa.actor_id and a.first_name = 'NICK' and a.last_name = 'WAHLBERG') as af
On af.film_id = ic.film_id order by ic.customer_id;

select c.name 
from customer_list as c 
where c.country = 'canada' 
and c.ID in (select ic.customer_id
			from inventory_customer as ic inner join 
			(select fa.film_id ,concat(a.first_name,'  ',a.last_name) as fullname 
			from actor as a inner join 
			film_actor as fa
			On a.actor_id = fa.actor_id and a.first_name = 'NICK' and a.last_name = 'WAHLBERG') as af
			On af.film_id = ic.film_id order by ic.customer_id);
			
			
			
#5. Find out the number of movies in which “SEAN WILLIAMS” acted.

select count(*) Total_Movies 
from actor as a inner join 
film_actor as fa
On a.actor_id = fa.actor_id and a.first_name = 'SEAN' and a.last_name = 'WILLIAMS';			
			
			
