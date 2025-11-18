-- DROP if exists (so you can run repeatedly while developing)
DROP DATABASE IF EXISTS grocery_db;
CREATE DATABASE grocery_db;
USE grocery_db;

-- -------------------------
-- Create tables
-- -------------------------
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(60),
  city VARCHAR(50)
);

CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(80),
  price DECIMAL(10,2),
  category VARCHAR(40)
);

CREATE TABLE employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(60)
);

CREATE TABLE sales (
  sale_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  emp_id INT,
  quantity INT,
  total_price DECIMAL(10,2),
  sale_date DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- -------------------------
-- Insert 20 customers
-- -------------------------
INSERT INTO customers VALUES
(1,'Rahul Kumar','Hyderabad'),
(2,'Aisha Khan','Mumbai'),
(3,'John Doe','Chennai'),
(4,'Sneha Reddy','Hyderabad'),
(5,'Vikram Patel','Delhi'),
(6,'Meera Iyer','Bangalore'),
(7,'Arjun Sen','Kolkata'),
(8,'Priya Sharma','Pune'),
(9,'Sameer Verma','Jaipur'),
(10,'Nina Roy','Kochi'),
(11,'Ramesh Gupta','Lucknow'),
(12,'Anita Das','Guwahati'),
(13,'Karthik N','Madurai'),
(14,'Sonal Agarwal','Noida'),
(15,'Rita Menon','Thiruvananthapuram'),
(16,'Imran Sheikh','Surat'),
(17,'Tanya Bhat','Bengaluru'),
(18,'Rohan Joshi','Indore'),
(19,'Deepa L','Vishakhapatnam'),
(20,'Manish Trivedi','Bikaner');

-- -------------------------
-- Insert 20 products
-- -------------------------
INSERT INTO products VALUES
(1,'Whole Milk 1L',45.00,'Dairy'),
(2,'White Bread Loaf',30.00,'Bakery'),
(3,'Eggs (12pcs)',80.00,'Poultry'),
(4,'Orange Juice 1L',95.00,'Beverages'),
(5,'Potato Chips 150g',45.00,'Snacks'),
(6,'Rice 5kg',250.00,'Grains'),
(7,'Atta (Wheat Flour) 5kg',220.00,'Grains'),
(8,'Sugar 1kg',45.00,'Grocery'),
(9,'Tea Powder 250g',150.00,'Beverages'),
(10,'Cooking Oil 1L',160.00,'Grocery'),
(11,'Paneer 250g',120.00,'Dairy'),
(12,'Butter 200g',110.00,'Dairy'),
(13,'Bananas (1kg)',50.00,'Produce'),
(14,'Tomatoes (1kg)',40.00,'Produce'),
(15,'Apples (1kg)',180.00,'Produce'),
(16,'Soya Chunks 500g',90.00,'Protein'),
(17,'Instant Noodles 70g',20.00,'Convenience'),
(18,'Coffee Powder 100g',220.00,'Beverages'),
(19,'Salt 1kg',25.00,'Grocery'),
(20,'Biscuits 200g',60.00,'Bakery');

-- -------------------------
-- Insert 20 employees
-- -------------------------
INSERT INTO employees VALUES
(1,'Kiran Sharma'),
(2,'Sita R'),
(3,'Manoj Kumar'),
(4,'Deepak Singh'),
(5,'Lakshmi N'),
(6,'Aravind P'),
(7,'Gauri P'),
(8,'Nitin B'),
(9,'Pooja K'),
(10,'Vikas L'),
(11,'Reena M'),
(12,'Suresh T'),
(13,'Anu C'),
(14,'Ravi D'),
(15,'Megha S'),
(16,'Vijay R'),
(17,'Kavita H'),
(18,'Nilesh G'),
(19,'Bina J'),
(20,'Harish O');

-- -------------------------
-- Insert 20 sales (ensure IDs reference 1..20)
-- total_price = product price * quantity (set explicitly)
-- -------------------------
INSERT INTO sales VALUES
(1, 1, 1, 1, 2, 90.00, '2024-01-02'),
(2, 2, 2, 2, 1, 30.00, '2024-01-02'),
(3, 3, 3, 3, 1, 80.00, '2024-01-03'),
(4, 4, 4, 4, 2, 190.00, '2024-01-04'),
(5, 5, 5, 5, 3, 135.00, '2024-01-05'),
(6, 6, 6, 6, 1, 250.00, '2024-01-05'),
(7, 7, 7, 7, 1, 220.00, '2024-01-06'),
(8, 8, 8, 8, 2, 90.00, '2024-01-07'),
(9, 9, 9, 9, 1, 150.00, '2024-01-07'),
(10,10,10,10,1,160.00, '2024-01-08'),
(11,11,11,11,2,240.00, '2024-01-09'),
(12,12,12,12,1,110.00, '2024-01-09'),
(13,13,13,13,3,150.00, '2024-01-10'),  -- bananas price 50 *3
(14,14,14,14,2,80.00, '2024-01-10'),
(15,15,15,15,1,180.00, '2024-01-11'),
(16,16,16,16,2,180.00, '2024-01-11'),
(17,17,17,17,5,100.00, '2024-01-12'),
(18,18,18,18,1,220.00, '2024-01-12'),
(19,19,19,19,4,100.00, '2024-01-13'),
(20,20,20,20,2,120.00, '2024-01-13');

-- 1.2 Products priced above 100 ordered by price descending
SELECT product_id, product_name, price, category
FROM products
WHERE price > 100
ORDER BY price DESC;

-- 2.1 Total revenue and units sold per product
SELECT p.product_id, p.product_name,
       SUM(s.quantity) AS total_units,
       SUM(s.total_price) AS total_revenue
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;

-- 2.2 Total revenue per city (via customers)
SELECT c.city, SUM(s.total_price) AS city_revenue
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY city_revenue DESC;

-- 3.1 INNER JOIN: sales with product & customer info
SELECT s.sale_id, s.sale_date, c.name AS customer, p.product_name, s.quantity, s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY s.sale_date, s.sale_id;

-- 3.2 LEFT JOIN: show all products and any sales (products never sold appear with NULLs)
SELECT p.product_id, p.product_name, COALESCE(SUM(s.quantity),0) AS units_sold
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC;

-- 3.3 RIGHT JOIN equivalent (MySQL supports RIGHT JOIN). Show all salespersons and their sales (include employees with zero sales)
SELECT e.emp_id, e.emp_name, COALESCE(SUM(s.total_price),0) AS emp_revenue
FROM employees e
LEFT JOIN sales s ON e.emp_id = s.emp_id
GROUP BY e.emp_id, e.emp_name
ORDER BY emp_revenue DESC;
-- 4.1 Non-correlated: products priced above average price
SELECT product_id, product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

DROP VIEW IF EXISTS vw_transaction_summary;

CREATE VIEW vw_transaction_summary AS
SELECT 
    s.sale_id,
    s.sale_date,
    c.customer_id,
    c.name AS customer_name,
    e.emp_id,
    e.emp_name AS employee_name,
    p.product_id,
    p.product_name,
    s.quantity,
    s.total_price
FROM sales s
LEFT JOIN customers c ON s.customer_id = c.customer_id
LEFT JOIN employees e ON s.emp_id = e.emp_id
LEFT JOIN products p ON s.product_id = p.product_id;

-- 7.1 Create basic indexes for common join columns
CREATE INDEX idx_sales_product ON sales(product_id);
CREATE INDEX idx_sales_customer ON sales(customer_id);
CREATE INDEX idx_sales_emp ON sales(emp_id);

-- Check indexes (MySQL)
SHOW INDEX FROM sales;


