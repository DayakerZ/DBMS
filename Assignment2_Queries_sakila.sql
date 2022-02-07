#Assignment 2
#1. Find out the number of documentaries with deleted scenes.

select f.title
from film_list as fl
inner join 
film as f
on fl.FID = f.film_id and f.special_features like '%Deleted Scenes%' and fl.category = 'Documentary';

-----------------
#2. Find out the number of sci-fi movies rented by the store managed by Jon Stephens.

select count(distinct i.film_id) from 
staff as s
inner join 
inventory as i
on s.staff_id = i.store_id
and s.first_name = 'Jon' and s.last_name = 'Stephens' 
and i.film_id in (select FID from film_list
					where category = 'Sci-Fi');
----------------
#3. Find out the total sales from Animation movies.

select total_sales 
from sales_by_film_category 
where category = 'Animation';

----------------
#4. Find out the top 3 rented category of movies by “PATRICIA JOHNSON”

select fl.category ,count(fl.category) 
from customer as c
inner join 
rental as r
on c.customer_id = r.customer_id and c.first_name like 'PATRICIA' and c.last_name like 'JOHNSON'
inner join 
inventory as i 
on r.inventory_id = i.inventory_id
inner join
film_list as fl
on i.film_id = fl.FID 
group by fl.category
order by count(fl.category) desc
limit 3;
---------------
#5. Find out the number of R rated movies rented by “SUSAN WILSON”.


select count(icr.film_id)
from inventory_customer_rental as icr
where icr.first_name like 'SUSAN' and icr.last_name like 'WILSON'
and icr.film_id in (select FID from film_list
where rating = 'R');




