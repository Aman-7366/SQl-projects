--1. Which channel is most frequently used for transactions?
 select top 1 Store_type--, count(transaction_id)  no_of_tran
 from Transactions
 group by Store_type
 order by 
 count(transaction_id) desc

 --2. What is the count of Male and Female customers in the database?
select Gender,count(customer_Id) as count from Customer
where gender is not null
group by Gender
--3. . From which city do we have the maximum number of customers and how many?
select top 1 city_code,count(customer_Id) as cust_count from Customer
group by city_code
order by cust_count desc

--4.4. How many sub-categories are there under the Books category?

select prod_cat,count(prod_subcat) as count from prod_cat_info
where prod_cat= 'books'
group by prod_cat

--5. What is the maximum quantity of products ever ordered?
select TOP 1 prod_cat, sum(Qty) as quantity from Transactions as t
join Customer as c on t.cust_id=c.customer_Id
join prod_cat_info as p on p.prod_cat_code=t.prod_cat_code
AND T.prod_subcat_code=P.prod_sub_cat_code

group by 
prod_cat
order by quantity desc

----OR---

SELECT SUM(QTY) AS TOTAL_QUANTITY FROM Transactions

--.6.. What is the net total revenue generated in categories Electronics and Books?
select prod_cat, sum(total_amt) as amount from Transactions as t
join Customer as c on t.cust_id=c.customer_Id
join prod_cat_info as p on p.prod_cat_code=t.prod_cat_code
AND P.prod_sub_cat_code=T.prod_subcat_code
where prod_cat in('electronics','books')
group by prod_cat
order by amount desc

--7.7. How many customers have >10 transactions with us, excluding returns?
select cust_id, count(transaction_id) as cust_count from Transactions
where Qty >0 
group by cust_id
having count(transaction_id)>10

--8. What is the combined revenue earned from the �Electronics� & �Clothing� categories from �Flagship stores�?


select sum(total_amt) as revenue from prod_cat_info as p
join Transactions as t on p.prod_cat_code=t.prod_cat_code
AND P.prod_sub_cat_code=T.prod_subcat_code
where prod_cat in ('electronics','clothing') and Store_type ='flagship store' and qty >0


--9. What is the total revenue generated from �Male� customers in �Electronics� category? Output should display total revenue by product sub-category.
select prod_subcat,sum(total_amt) as Revenue from prod_cat_info as p 
join Transactions as T on t.prod_subcat_code=p.prod_sub_cat_code
AND T.prod_cat_code=P.prod_cat_code
join Customer as c on c.customer_Id=t.cust_id
where Gender ='m' and prod_cat = 'ELECTRONICS' and Qty >0
GROUP BY prod_subcat 


--10. What is percentage of sales and returns by product sub-category; display only top 5 sub-categories in terms of sales?       ----unsolved---
select x.prod_subcat, revenue_percent,return_per from
 
( select top 5 prod_subcat,sum( total_amt)/(select sum(total_amt) from Transactions where total_amt >0)*100 as revenue_percent from prod_cat_info as P 
 join Transactions as T on t.prod_cat_code=p.prod_cat_code
 and t.prod_subcat_code=p.prod_sub_cat_code
 where total_amt >0 
 group by prod_subcat
 order by sum(total_amt) desc) as x join 

 (select  prod_subcat,sum( total_amt)/(select sum(total_amt) from Transactions where total_amt <0)*100  as return_per from prod_cat_info as P 
 join Transactions as T on t.prod_cat_code=p.prod_cat_code
 and t.prod_subcat_code=p.prod_sub_cat_code
 where total_amt <0
 group by prod_subcat
 ) as y on x.prod_subcat=y.prod_subcat










--11. For all customers aged between 25 to 35 years, what is the net total revenue generated by these consumers in last 30 days of transactions from max transaction date available in the data?









--12. Which product category has seen the maximum value of returns in the last 3 months of transactions?     [ UNSOLVED]

select prod_cat,sum(total_amt) as return_ from prod_cat_info as 
p join Transactions as t on p.prod_cat_code=t.prod_cat_code and
p.prod_sub_cat_code=t.prod_subcat_code
where total_amt <0 and tran_date>( select DATEDIFF(month,-3,CONVERT(date,tran_date,105)) from Transactions)
group by prod_cat
order by 
return_ asc


--13. Which store-type sells the maximum products; by value of sales amount and by quantity sold?

SELECT Store_type, ROUND(SUM(total_amt),2) AS AMOUNT,SUM(Qty) AS QUANTITY FROM Transactions
where total_amt >0
GROUP BY Store_type
ORDER BY AMOUNT DESC,QUANTITY DESC

--14. What are the categories for which average revenue is above the overall average?

SELECT prod_cat FROM Transactions AS T JOIN prod_cat_info AS P
ON P.prod_cat_code=T.prod_cat_code
where qty > 0
GROUP BY prod_cat
HAVING AVG(total_amt) >( SELECT AVG(total_amt)  FROM Transactions where qty >0)

--15. Find the average and total revenue by each subcategory for the categories which are among the top 5 categories in terms of quantity sold.
;WITH TOP_CATEGOTY
AS(
SELECT TOP 5 prod_subcat, SUM(Qty) AS QUANTITY FROM prod_cat_info AS P JOIN Transactions AS T ON 
P.prod_cat_code=T.prod_cat_code
where Qty >0
GROUP BY prod_subcat
ORDER BY QUANTITY DESC)


SELECT prod_subcat,SUM(total_amt) AS AMOUNT, AVG(total_amt) AS AVG_AMOUNT FROM Transactions AS T JOIN prod_cat_info AS P ON P.prod_cat_code=T.prod_cat_code
WHERE prod_subcat IN (SELECT prod_subcat FROM TOP_CATEGOTY) and Qty>0
GROUP BY prod_subcat








 









 select 
 --convert(date,
 year(tran_date)
 --,
--- 105)
 from Transactions