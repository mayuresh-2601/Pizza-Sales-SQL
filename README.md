# 🍕 Pizza Sales Data Analysis Using SQL

![Pizza Banner](https://github.com/mayuresh-2601/Pizza-Sales-SQL/blob/main/Pizza.png)

## 📌 Overview

This SQL project analyzes a complete pizza sales dataset to uncover meaningful insights.  
It focuses on understanding sales performance, top-selling pizzas, customer ordering patterns, revenue trends, and category-level performance.

The project demonstrates SQL skills including:
- Database schema design (DDL)
- Data exploration & cleaning
- Joins, aggregations, subqueries
- Window functions
- Views and stored procedures
- Analytical reporting

---

## 🎯 Objectives

✔ Identify best-selling pizzas  
✔ Analyze sales by category and size  
✔ Calculate total revenue and daily/monthly revenue trends  
✔ Compare weekday vs weekend performance  
✔ Find peak ordering times  
✔ Detect pizzas that never sold  
✔ Build views and stored procedures for reusable reporting  

---

## 📁 Dataset

This project uses the following CSV files:

- pizzas.csv  
- pizza_types.csv  
- orders.csv  
- order_details.csv  

These datasets include details about pizza prices, ingredients, categories, orders, and quantities.

---

## 🗂️ Schema Used

```sql
CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    ingredients TEXT
);

CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50),
    size CHAR(1),
    price DECIMAL(6,2),
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    order_time TIME
);

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT,
    pizza_id VARCHAR(50),
    quantity INT,
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(pizza_id) REFERENCES pizzas(pizza_id)
);
```

## 🔍 Business Questions & SQL Solutions

### ✅ Total Number of Orders

```sql
SELECT COUNT(order_id) AS total_orders
FROM orders;
```

### ✅ Top 5 Most Ordered Pizzas

```sql
SELECT pt.name, SUM(od.quantity) AS total_quantity
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;
```

### ✅ Total Revenue Generated

```sql
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;
```

### ✅ Identify Pizzas Never Sold

```sql
SELECT p.pizza_id
FROM pizzas p
LEFT JOIN order_details od ON p.pizza_id = od.pizza_id
WHERE od.pizza_id IS NULL;
```

### ✅ Peak Ordering Hour

```sql
SELECT HOUR(order_time) AS hour, COUNT(*) AS order_count
FROM orders
GROUP BY HOUR(order_time)
ORDER BY order_count DESC;
```

### ✅ Category-wise Revenue

```sql
SELECT pt.category, SUM(od.quantity * p.price) AS revenue
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY revenue DESC;
```

### ✅ Monthly Revenue Trend

```sql
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(od.quantity * p.price) AS revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON p.pizza_id = od.pizza_id
GROUP BY month
ORDER BY month;
```

## 📊 Key Findings & Insights

- The highest revenue comes from large-sized pizzas and strong-performing categories
- Weekends generate more revenue than weekdays
- Several pizzas never sold, indicating low popularity
- Lunch and evening hours show peak ordering patterns
- Certain pizzas consistently dominate overall sales
- Monthly cumulative revenue shows strong growth over time
- This demonstrates how SQL can transform raw sales data into valuable business intelligence

---

## 🚀 How to Run This Project

- Clone this repository
- Import the CSV files into MySQL
- Run the database schema file
- Run the analysis SQL file
- Explore insights from queries & views

---

## 👨‍💻 Author – Mayuresh Kasar

This project is part of my SQL Developer & Data Analytics portfolio.
Feel free to explore, fork the repo, and connect with me for collaboration or feedback!

---
