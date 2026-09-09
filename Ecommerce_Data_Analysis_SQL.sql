CREATE DATABASE ecommerce_project;

USE ecommerce_project;

CREATE TABLE customers(
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100),
email VARCHAR(100),
city VARCHAR(100),
phone VARCHAR(100)
);

CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
stock INT,
category VARCHAR(100),
price DECIMAL (10,2)
);

CREATE TABLE orders (
order_id INT PRIMARY KEY,
order_date DATE,
total_amount DECIMAL(10,2),
customer_id INT,
foreign key (customer_id) references customers(customer_id)
);

CREATE TABLE order_items(
order_item_id INT PRIMARY KEY,
quantity INT,
product_id INT,
order_id INT,
FOREIGN KEY (product_id) REFERENCES products(product_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id));

INSERT INTO customers
(customer_id,customer_name,email,city,phone)
VALUES
(101,"Aman Sharma","aman@gmail.com","Delhi","9876543210"),
(102,"Priya Singh","priya@gmail.com","Mumbai","9876543211"),
(103,"Rahul Verma","rahul@gmail.com","Jaipur","9876543212"),
(104,"Sneha Gupta","sneha@gmail.com","Pune","9876543213"),
(105,"Rohit Kumar","rohit@gmail.com","Lucknow","9876543214");

INSERT INTO products
(product_id,product_name,stock,category,price)
VALUES
(201,"Laptop",25,"Electronics",60000),
(202,"Mouse",80,"Electronics",3000),
(203,"Keyboard",45,"Fashion",5500),
(204,"Headphones",150,"Electronics",1200),
(205,"Mobile",50,"Electronics",21000),
(206,"T-Shirts",95,"Fashion",900),
(207,"Shoes",120,"Fashion",1500);

INSERT INTO orders
(order_id,order_date,total_amount,customer_id)
VALUES
(301,"2026-08-01",55700,101),
(302,"2026-08-02",2600,102),
(303,"2026-08-03",18800,103),
(304,"2026-08-04",1900,104),
(305,"2026-08-05",55900,105);

INSERT INTO order_items
(order_item_id,order_id,product_id,quantity)
VALUES
(1,301,201,1),
(2,302,202,1),
(3,302,202,1),
(4,303,203,1),
(5,303,204,1),
(6,303,205,1),
(7,304,205,1),
(8,305,206,1),
(9,305,207,1);

SELECT * FROM customers;

SELECT * FROM products;

SELECT * FROM orders;

SELECT * FROM order_items;

SELECT
c.customer_name,
o.order_id,
o.order_date,
o.total_amount
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id;

SELECT
o.order_id,
o.order_date,
c.customer_id,
c.customer_name,
o.total_amount
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
ORDER BY o.order_date;

SELECT 
o.order_id,
p.product_name,
p.price,
oi.quantity
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id 
JOIN products p 
ON p.product_id = oi.product_id;

SELECT 
p.product_name,
SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;
 
SELECT
o.order_id,
o.order_date,
c.customer_name,
p.product_name,
p.price,
oi.quantity,
(oi.quantity*p.price) AS product_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON p.product_id = oi.product_id 
ORDER BY o.order_id;



SELECT
c.customer_id,
c.customer_name,
COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY total_orders DESC;

SELECT
c.customer_id,
c.customer_name,
SUM(oi.quantity*p.price) AS total_spending
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY c.customer_id,c.customer_name
ORDER BY total_spending DESC;

SELECT
c.customer_id,
c.customer_name,
SUM(oi.quantity) AS total_products_purchased
FROM customers c
JOIN orders o
ON c.customer_id  = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id,c.customer_name
ORDER BY total_products_purchased DESC;

SELECT
c.customer_id,
c.customer_name,
MAX(o.order_date) AS last_purchase_date
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY last_purchase_date DESC;

SELECT
c.customer_id,
c.customer_name,
AVG(o.total_amount) AS total_order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.customer_name;



SELECT
p.product_id,
p.product_name,
SUM(oi.quantity) AS total_quantity_sold,
p.price,
SUM(oi.quantity*p.price) AS total_revenue
FROM  products p 
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id,p.product_name,p.price
ORDER BY total_revenue DESC;

SELECT
p.category,
SUM(oi.quantity) AS total_quantity_sold,
SUM(oi.quantity*p.price) AS total_revenue
FROM  products p 
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

SELECT
p.product_id,
p.product_name,
SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY  p.product_id,p.product_name
ORDER BY total_quantity_sold DESC;

SELECT
c.customer_id,
c.customer_name,
SUM(oi.quantity*p.price) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY c.customer_id,c.customer_name
ORDER BY total_revenue DESC;

SELECT
YEAR(o.order_date) AS sales_year,
MONTH(o.order_date) AS sales_month,
SUM(oi.quantity) AS total_quantity_sold,
SUM(oi.quantity*p.price) AS total_revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY YEAR(o.order_date),
MONTH(o.order_date)
ORDER BY sales_month,sales_year;



SELECT
c.customer_id,
c.customer_name,
SUM(o.total_amount) AS total_spending,
CASE
   WHEN 
      SUM(o.total_amount) >=10000
      THEN 'High Value'
   WHEN
      SUM(o.total_amount) >=5000
       THEN 'Medium Value'
	ELSE 'Low Value'
END AS spending_segment
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY total_spending DESC;

SELECT
c.city,
SUM(o.total_amount) AS total_sales
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_sales DESC;

SELECT
p.product_id,
p.product_name,
SUM(oi.quantity) AS total_quantity_sold,
SUM(oi.quantity*p.price) AS total_revenue,
ROUND(SUM(oi.quantity*p.price)/SUM(oi.quantity),2) AS average_selling_price
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id,p.product_name
ORDER BY average_selling_price DESC;

SELECT
p.category,
ROUND(AVG(o.total_amount),2) AS average_order_value
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
JOIN orders o
ON oi.order_id = o.order_id
GROUP BY p.category
ORDER BY average_order_value DESC;

 SELECT
 o.order_id,
 o.order_date,
 c.customer_name,
 o.total_amount
 FROM orders o 
 JOIN customers c
 ON o.customer_id = c.customer_id
 WHERE o.total_amount >= 10000
 ORDER BY o.total_amount DESC;
 
 SELECT
 p.product_id,
 p.product_name,
 p.category,
 p.stock,
 COALESCE(SUM(oi.quantity),0) AS quantity_sold,
 CASE
 WHEN p.stock <=10 THEN 'Low Stock'
 WHEN p.stock <=50 THEN 'Medium Stock'
 ELSE 'High Stock'
 END AS stock_status
 FROM products p
 LEFT JOIN order_items oi
 ON p.product_id = oi.product_id
 GROUP BY
 p.product_id,
 p.product_name,
 p.category,
 p.stock
 ORDER BY quantity_sold DESC;
