--create database dbs211;
--drop database dbs211;

-- use

create table positions(
   positionid integer constraint pk_positions Primary Key,
   posname varchar(15),
   constraint ck_positions_positionid check(positionid>0) );

create table employees(
   empid integer constraint pk_employees Primary Key,
   empfname varchar(30) not null,
   emplname varchar(30) not null,
   socins varchar(9) constraint ck_employees_socins check(socins not like '%[^0-9]%') unique not null,     --varchar(9) up to 9 charactors? 
   positionid integer constraint fk_employees_positionid Foreign Key(positionid) references positions(positionid),
   hire_date date,
   supvid integer,
   constraint ck_employees_empid check(empid>0),
   constraint ck_employees_supvid check(supvid>0)    );        --not sure if we need to set FK for self reference

--alter table employees add constraint ck_employees_socins
    --check (socins like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

--alter table employees add constraint ck_employees_socins
    -- check (len(socins) = 9 and socins not like '%[^0-9]%');

create table customers(
   custid integer constraint pk_customers Primary Key,
   custfname varchar(30) not null unique,
   custlname varchar(30) not null unique,
   location varchar(15),
   empid integer not null constraint fk_customers_empid Foreign Key(empid) references employees(empid),
   constraint ck_cunstomers_custid check(custid>0)    );

create table products(
   prodid integer constraint pk_products Primary Key,
   prodname varchar(30),
   edition varchar(30) null,
   purchasecost decimal(5, 2) default 0,
   retailprice decimal(5, 2) not null,
   constraint ck_products_prodid check(prodid>0), 
   constraint ck_products_purchasecost check(purchasecost>=0),
   constraint ck_product_retailprice check(retailprice>0)   );

create table authors(
   authorid integer constraint pk_authors Primary Key,
   autfname varchar(30) not null,
   autlname varchar(30) not null,
   constraint ck_authors_authorid check(authorid>0)  );    

create table titleauthors(
   authorid integer,
   prodid integer,
   constraint pk_titleauthors Primary Key(authorid, prodid),
   constraint fk_titleauthors_authorid Foreign Key(authorid) references authors(authorid),
   constraint fk_titleauthors_prodid Foreign Key(prodid) references products(prodid) );
   --I have no sequence column, but we can include that. (Optional)

create table invoices(
   invoiceid integer constraint pk_invoices Primary Key,
   custid integer not null constraint fk_invoices_custid Foreign Key(custid) references customers(custid),
   orderdate date,
   constraint ck_invoices_invoiceid check(invoiceid>0) );

create table orderdetails(
    invoiceid integer,
	prodid integer,
	qty integer,
	price decimal(5,2) constraint ck_orderdetails_price check(price>0),    --total is a depentant variable, thus not included. 
	constraint pk_orderdetails Primary Key(invoiceid, prodid),
	constraint fk_orderdetails_invoiceid Foreign Key(invoiceid) references invoices(invoiceid),
	constraint fk_orderdetails_prodid Foreign Key(prodid) references products(prodid) );
