use classicmodels;

select count(*) from customers where customerNumber=124;
select * from employees;
select * from offices;
select * from orderdetails where orderNumber in (10113,10135,10142,10182,10229,10271,10282,10312,10335,10357,10368,10371,10382,10385,10390,10396,10421);
select * from orders;-- where orderDate between now() - interval 254 month and now();
select * from payments;
select * from productlines;
select * from products;



-- Retrieve the first 10 rows from the customers table.
select * from customers limit 10;
-- List all employees whose first name starts with 'J'.
select * from employees where firstName like 'J%';
-- Find the total number of offices.
select count(*) from offices;
-- Retrieve the order details for orders placed on a specific date.
select * from orders where orderDate = '2003-03-24';
-- List all orders placed by a particular customer.
select * from customers where customerNumber = 103;
-- Find the total payments received by the company.
select sum(amount) from payments where companyNumber=124;

-- Get the product lines along with the number of products in each line.
select productLine, count(*) from products group by productLine;

-- Retrieve the names of the customers who have placed orders.
select c.customerName, count(*) as no_of_orders_placed from orders o join customers c on c.customerNumber = o.customerNumber group by o.customerNumber;

-- Find the employees who have not made any sales.
-- I don't see this relation in my tables so


show create table products;




-- Retrieve the top 10 customers based on their total purchase amount.
select c.customerNumber, c.customerName, total_ordered_amount from customers c join (
	select o.customerNumber, 
    sum(od.quantityOrdered * od.priceEach) as total_ordered_amount
    from orderdetails od  
    left join orders o 
    on o.orderNumber = od.orderNumber 
    group by o.customerNumber
    order by total_ordered_amount desc 
    limit 10
) as top_customers on c.customerNumber=top_customers.customerNumber;

-- Calculate the total quantity sold and total revenue generated for each product.
select 
p.productName,
od.productCode,
sum(od.quantityOrdered) as orderedQuantity,
sum(od.quantityOrdered * od.priceEach) as revenueOnProduct
from orderdetails od join products p
on p.productCode = od.productCode
group by od.productCode
order by revenueOnProduct desc;

-- Analyze the monthly sales trend by calculating the total sales amount for each month.
select MONTHNAME(orderDate) as month, count(*) as total_sales from orders group by MONTH(orderDate);



-- Identify customers who haven't made any purchases in the last year.
select c.customerName
from customers c
where 
c.customerNumber not in (
	select	o.customerNumber
	from orders o 
	where 
	o.orderDate between '2003-02-24' and '2003-02-25'
); 

-- Determine the average payment amount received per customer.
select 
c.customerName, 
(p.amount) avg_payment_amount 
from 
payments p join customers c 
on c.customerNumber = p.customerNumber
group by p.customerNumber 
order by avg_payment_amount desc;

-- Calculate the revenue share of each product line in the total sales revenue.
select 
od.orderLineNumber,
((sum(od.quantityOrdered * od.priceEach) / (select sum(os.quantityOrdered * os.priceEach) from orderdetails os)) * 100) as order_line_basis_share_in_revenue
from orderdetails od
group by od.orderLineNumber
order by order_line_basis_share_in_revenue desc;

-- Find the number of orders placed by each customer and identify the customers with the highest order frequency.
select 
customerNumber, 
count(*) as no_of_orders_placed 
from 
orders group by customerNumber
order by no_of_orders_placed 
desc limit 10; 



-- Customer Lifetime Value (CLV): Calculate the CLV for each customer, considering their total historical purchases and any additional factors you deem relevant.
-- Product Cohort Analysis: Perform a cohort analysis to understand the purchasing behavior of customers over time, grouping them based on their first purchase date and analyzing their subsequent purchases.
-- Sales Funnel Analysis: Analyze the sales funnel by tracking the conversion rates at each stage of the purchasing process (e.g., from viewing a product to completing a purchase).
-- Market Basket Analysis: Identify frequently co-purchased products to uncover patterns and associations among products bought together.
-- Time Series Forecasting: Use historical sales data to forecast future sales for each product or customer segment, employing techniques such as moving averages or exponential smoothing.
-- Customer Segmentation: Segment customers into distinct groups based on their purchasing behavior, demographics, or other characteristics, and analyze the characteristics and behaviors of each segment.
-- Churn Prediction: Build a model to predict customer churn based on factors such as order frequency, recency, and monetary value, using historical data to train and validate the model.
-- Geospatial Analysis: Analyze sales data spatially to identify regions with high or low sales volumes, and explore potential correlations with demographic or economic factors.
-- Cross-Selling and Upselling Recommendations: Develop recommendations for cross-selling or upselling based on customer purchase history and product relationships.
-- Dynamic Pricing Strategy: Implement a dynamic pricing strategy based on factors such as demand, seasonality, and competitor pricing, and analyze its impact on sales and revenue.

