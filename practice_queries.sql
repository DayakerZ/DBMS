select distinct actor_id from film_actor
order by actor_id;

select concat(cust.first_name,'  ',last_name) full_name
from (select first_name ,last_name 
		from customer where last_name = 'DAVIS' ) cust;
        
# temporary tables (volatile and gets discarded after the session ends)
create temporary table actor_j 
(actor_id smallint(5),
first_name varchar(45),
last_name varchar(45));

#inserting into temporary table 

insert into actor_j 
select actor_id,first_name,last_name
from actor
where last_name like 'J%';

select * from actor_j;

# creating a view (which creats a virtual table) 
create view cust_view as 
select customer_id ,first_name,last_name,active
from customer;

# quering a view 

select first_name ,last_name
from cust_view
where active = 0;


select * from film;
-------------------------------

create view temp as
select i.film_id ,t.customer_id ,i.inventory_id
from inventory as i inner join 
(select c.customer_id,r.inventory_id
from customer as c inner join 
rental as r on 
c.customer_id = r.customer_id) as t 
on t.inventory_id = i.inventory_id;

select c.name from 
customer_list as c inner join 
(select distinct temp.customer_id
from temp inner join 
(select FID from film_list where category like 'sports') as s
on s.FID = temp.film_id ) as t 
on t.customer_id = c.ID and c.country = 'India';

--------------------------------------

create table Ticket(Ticket_id varchar(45),Train_id varchar(45),Customer_id varchar(45),Ticket_status enum('RESERVED','UNRESERVED'),Start_time time,
constraint Ticket_PK primary key (Ticket_id),constraint Train_FK foreign key (Train_id) references Train(Train_id),
constraint Customer_FK foreign key (Customer_id) references Customer(Customer_id));

create table Customer(Customer_id varchar(45),First_name varchar(45),Last_name varchar(45),Age Int);


ALTER TABLE Customer
ADD CONSTRAINT Customer_PK PRIMARY KEY (Customer_id);

alter table Ticket
add constraint Ticket_Check
check ((Ticket_status = 'RESERVED' and Train_id != null) or (Ticket_status = 'UNRESERVED' and Train_id = null));


ALTER TABLE Ticket
ADD CONSTRAINT Ticket_Custo PRIMARY KEY (Customer_id);
-----------------------------------------------------------------------------
create table Supplier (Supplier_id varchar(45),First_name varchar(45),Last_name varchar(45),Contact_num bigint,
constraint PK_Supplier primary key (Supplier_id));

create table Items (Item_id varchar(45),Item_Name varchar(45),Item_Brand varchar(45),Price Decimal(10,2),
constraint PK_Items primary key (Item_id));

create table Customer(Customer_id varchar(45),First_name varchar(45),Last_name varchar(45),Age Int,Contact_num bigint,
constraint PK_Customer primary key (Customer_id));

create table Ordered (Order_id varchar(45),Item_id varchar(45),
constraint FK_Ordered foreign key (Item_id) references Items(Item_id));

ALTER TABLE Ordered
ADD CONSTRAINT PK_Ordered PRIMARY KEY (Order_id,Item_id);

alter table Ordered
add column Quantity int not null;

create table Orders (Customer_id varchar(45),Order_id varchar(45),Order_time Timestamp,Total_price Decimal(10,2),
constraint FK_Orders_1 foreign key (Customer_id) references Customer(Customer_id),
constraint FK_Orders_2 foreign key (Order_id) references Ordered (Order_id));

create table Supply (Supplier_id varchar(45),Item_id varchar(45),
constraint FK_Supply_1 foreign key (Supplier_id) references Supplier(Supplier_id),
constraint FK_Supply_2 foreign key (Item_id) references Items(Item_id));

-------------------------------------------------------------------------------

create table Movie (Movie_id varchar(45) primary key,Title varchar(45) not null,genre enum('G','PG','PG-13','R','NC-17'),
Cast text,IMDB_rating Decimal(3,2));

create table Actor (Actor_id varchar(45) primary key,first_name varchar(45) not null,last_name varchar(45) not null,
age int,Contact_num bigint);

create table TVSeries (TV_id varchar(45) primary key,Title varchar(45) not null,genre enum('G','PG','PG-13','R','NC-17'),
Cast text,IMDB_rating Decimal(3,2));

create table Acted (Movie_id varchar(45),Actor_id varchar(45) not null,TV_id varchar(45),
constraint FK_Acted_1 foreign key (Movie_id) references Movie(Movie_id),
constraint FK_Acted_2 foreign key (TV_id) references TVSeries(Tv_id),
constraint FK_Acted_2 foreign key (TVActed_id) references Actor(Actor_id));

alter table Acted
add constraint FK_Acted_3 foreign key (Actor_id) references Actor(Actor_id);

---------------------------------------------------------------------------------
create table Accounts 
(Account_num bigint primary key,Balance decimal(10,2) not null default 0.00,
Account_type enum('SAVINGS','CURRENT') not null,Is_joint_account boolean not null default false);

create table Customer(Customer_id varchar(45),First_name varchar(45) not null,Last_name varchar(45) not null,Age Int,Contact_num bigint,
constraint PK_Customer primary key (Customer_id));

create table Branch (Branch_id varchar(45) primary key,City varchar(45) not null,State varchar(45) not null);

create table Hold (Account_num bigint not null,Customer_id varchar(45) not null,Branch_id varchar(45) not null,
constraint UC_Hold unique(Customer_id,Branch_id),
constraint FK_Hold_1 foreign key (Account_num) references Accounts(Account_num) ,
constraint FK_Hold_2 foreign key (Customer_id) references Customer(Customer_id),
constraint FK_Hold_3 foreign key (Branch_id) references Branch(Branch_id));

create table Joints (Account_num bigint not null,Customer_id_1 varchar(45) not null,Customer_id_2 varchar(45) not null,
Customer_id_3 varchar(45),Branch_id varchar(45) not null,
constraint FK_Joints_1 foreign key (Account_num) references Accounts(Account_num),
constraint FK_Joints_2 foreign key (Branch_id) references Branch(Branch_id));


drop table Joints;

-----------------------------------------------------------------------------------
create table Student (rollno int primary key,first_Name varchar(45),last_name varchar(45),subject varchar(45));

alter table Student 
rename column subject to Subject;


--------------------------------------------------------------------------------------
#triggers

#A trigger is a user defined sql command that is invoked automatically when an event such as insert ,delete and update occur

-- create trigger 
-- trigger_name trigger_time
-- trigger_event 
-- on table_name for each row 
-- begin
-- .
-- .
-- .end

create database Triggers;
use Triggers;
show tables;

#before insert trigger
create table Customers
(cust_id int,age int,name varchar(45));

delimiter //
create trigger age_verify
before insert on Customers
for each row 
if new.age < 0 then set new.age = 0;
end if;
//

insert into Customers
values (101,21,'Daya'),
(102,-40,'amith'),
(103,32,'sai');


select  * from Customers;

#after triggers

create table customers1
(id int auto_increment primary key,
name varchar(45) not null,
email varchar(45),birthdate date);

create table message
(id int auto_increment,
messageid int,
message varchar(300) not null,
primary key (id,messageId));

delimiter //
create trigger 
check_null_dob
after insert
on customers1
for each row 
begin
if new.birthdate is null then
insert into message (messageId,message)
values (new.id,concat('Hi ',new.name,',  please update your date of birth'));
end if;
end//

insert into customers1 (name,email,birthdate)
values ('daya','daya1232gmail.com',null),
('amith','abc@cde.com','1992-11-16'),
('sai','sai@abc.com','1999-09-23'),
('raj','raj@yahoo.com',null);

select * from message;

#before update

create table employees
(emp_id int primary key,
emp_name varchar(45),age int,salary float);

insert into employees values 
(101,'daya',21,1800),
(102,'amith',20,1800),
(103,'sai',21,2800),
(104,'ram',21,800),
(105,'ravi',21,50000);

delimiter //
create trigger upd_trigger
before update
on employees
for each row
begin
if new.salary =10000 then
set new.salary = 85000;
elseif new.salary <10000 then
set new.salary = 72000;
end if;
end//

update employees
set salary = 8000;
where emp_id = 102;


#before delete
create table salary
(eid int primary key,
validform date not null,
amount float not null);

insert into salary (eid,validform,amount)
values (101,'2001-09-09',55500),
(103,'2002-09-01',56500),
(104,'2004-01-09',50000),
(102,'2001-09-29',75500);

create table salarydel
(id int primary key auto_increment,
eid int,
validform date not null,
amount float not null,
deldate timestamp default now());

delimiter //
create trigger salary_delete
before delete
on salary 
for each row 
begin 
insert into salarydel(eid,validform,amount)
value(old.eid,old.validform,old.amount);
end
//

delete from salary
where eid = 103;