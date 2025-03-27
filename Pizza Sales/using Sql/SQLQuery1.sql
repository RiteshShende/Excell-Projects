Use [Pizza Sales Analysis]
Select * from dbo.pizza_sales$

--KPI's
--1.ToTal Revenue
Select Round(SUM(total_price),2) as Total_Revenue from dbo.pizza_sales$;

--2. Average Order Value
Select  Round(sum(total_price)/Count(Distinct order_id),2) as Average_order_Value from dbo.pizza_sales$;

--3. Total Pizza Sold
Select SUM(quantity) as Total_Pizza_Sold from dbo.pizza_sales$

--4.Total Order
Select Count(DISTINCT(order_id)) as Total_Orders from dbo.pizza_sales$

--5.Average Pizza Per Order
Select Round((SUM(quantity)/COUNT(distinct order_id)),0) as Average_pizza_per_Order from dbo.pizza_sales$     
===========================
Alter table dbo.pizza_sales$ add  month_name text;
alter table dbo.pizza_sales$ drop column month_name
Update dbo.pizza_sales$  set month_name = datename(Month,order_date)

Alter table dbo.pizza_sales$ add  Order_date_new Date;
Alter table dbo.pizza_sales$ add  Order_Time_new Time;
update dbo.pizza_sales$ set Order_date_new= cast(order_date as Date)
update dbo.pizza_sales$ set order_Time_new= cast(order_time as Time)

Alter table dbo.pizza_sales$ drop column order_time,order_date
Select * from dbo.pizza_sales$
Alter table dbo.pizza_sales$  Order_date_new Date;
Exec sp_rename 'dbo.pizza_sales$.order_Time_new','order_time', 'column'
Exec sp_rename 'dbo.pizza_sales$.Order_date_new','order_date', 'column'

Alter table dbo.pizza_sales$ add hours numeric
update dbo.pizza_sales$ set hours = DATEPART(hour,order_time)

================================

--6. Daily trend for total orders
Select Datename(Weekday,order_date) day_name, count(distinct order_id) order_count from dbo.pizza_sales$ group by 
Datename(Weekday,order_date) order by
Case Datename(Weekday,order_date) when 'Monday' then 1 when 'Tuesday' then 2 when 'Wednesday' then 3
when 'Thursday' then 4 when 'Friday' then 5 when 'Saturday' then 6 when 'Sunday' then 7 end;

--7. hourly orders trends
select hours,COUNT(distinct order_id) as order_count from dbo.pizza_sales$ group by hours order by 1

--8. percentage of sales by pizza category
select pizza_category,round(SUM(total_price),2) as Revenue, Round(SUM(total_price)*100/(Select SUM(total_price)
from dbo.pizza_sales$),2) as PCT from dbo.pizza_sales$ group by pizza_category order by 2 desc;

--9.percentage of sales by pizza size
select pizza_size,round(SUM(total_price),2) as Revenue, Round(SUM(total_price)*100/(Select SUM(total_price)
from dbo.pizza_sales$),2) as PCT from dbo.pizza_sales$ group by pizza_size order by 2 desc;

--10. Pizza sold by pizza_category
Select pizza_category, SUM(quantity) As pizza_sold from dbo.pizza_sales$ group by pizza_category order by 2 desc

--11.Top 5 best seller by total pizza sold
Select Top 5 pizza_name, SUM(quantity) as pizza_sold from dbo.pizza_sales$ group by pizza_name order by 2 desc;

--12.Bottom 5 best seller by total pizza sold
Select Top 5 pizza_name, SUM(quantity) as pizza_sold from dbo.pizza_sales$ group by pizza_name order by 2 asc;