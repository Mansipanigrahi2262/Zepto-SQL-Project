create database zepto_project ;
use zepto_project ;
create table zepto (
sku_id serial primary key ,
Category varchar(120) ,
name  varchar (150) not null ,
mrp numeric(8,2) ,
discountPercent numeric(5,2) ,
availableQuantity int ,
descountedSellingPrice numeric(8,2) ,
weightInGms int ,
outOfStock varchar(5),
quantity int 
);
use zepto_project ;
select count(*) from zepto ;

-- check the table 
select * from zepto limit 10 ;

-- checking if there any null value present 
select * from zepto where name is null
or
Category is null
or
mrp is null
or
discountPercent is null
or
availableQuantity is null
or
descountedSellingPrice is null
or
weightInGms is null
or
outOfStock is null
or
quantity is null ;

-- different product category

select distinct category from zepto order by category ;

-- product in stock vs out of stuck 

select outOfStock , count(sku_id) from zepto group by outOfStock ;

-- product name present multiple times 

select name , count(sku_id) as "Number of skus" 
from zepto 
group by name having count(sku_id) > 1
order by count(sku_id) DESC ;
-- data cleaning 

-- product with price 0
select * from zepto where mrp = 0 or descountedSellingPrice = 0 ;

set SQL_SAFE_UPDATES = 0 ;
 delete from zepto  where mrp = 0 ;
 set SQL_SAFE_UPDATES  = 1 ;
 
 -- covert paisa to rupees
 set SQL_SAFE_UPDATES = 0 ;
 update zepto 
 set mrp = mrp / 100.0 ,
 descountedSellingPrice = descountedSellingPrice / 100.0 ;
  select mrp ,descountedSellingPrice from zepto ;
  
  -- find the top 10 best value products based on the discount percentage.
    use zepto_project ;
  select distinct name , mrp ,discountPercent 
  from zepto order by discountPercent DESC 
  limit 10 ;
  
  -- What are with product with high mrp but out of stock ?
  select distinct name , mrp from zepto 
  where outOfStock = 1 and mrp > 300
  order by mrp ;
  
  -- calculate Estimate revenue for each category 
  select category ,
  sum(descountedSellingPrice * availableQuantity ) as total_revenue
  from zepto 
  group by category 
  order by total_revenue ;
  
  -- find all product where mrp is greater than 500 and discount is less than 10% .
  select distinct name , mrp , discountPercent 
  from zepto 
  where mrp >500 and discountPercent < 10 
  order by mrp DESC , discountPercent DESC ;
  
  -- identify the top 5 category offering the highest average discount percentage 
  select category ,
 round( avg(discountPercent) , 2) as avg_discount 
 from zepto 
 group by category 
 order by avg_discount DESC 
 limit 5 ;
 
 -- find the price per gram for product avobe 100g and sort by best value . 
 select distinct name , weightInGms , descountedSellingPrice , 
 round(descountedSellingPrice/ weightInGms , 2) as price_perGram
 from zepto
 where weightInGms >=  100
 order by price_perGram ;
 
 -- group the product into category like low , medium , bulk .
 select distinct name , weightInGms, 
 case when weightInGms < 1000 then 'low'
 when weightInGms < 5000 then 'medium'
 else 'bulk'
 end as weight_category 
 from zepto ;
 
 
 -- what is the total inventory weight per category .
 select category , 
 sum(weightInGms * availableQuantity) as total_weight 
 from zepto 
 group by category
 order by total_weight ;
 
  
  
  





