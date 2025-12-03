# 🍕 Pizza Sales Data Analysis Using SQL

![Pizza Banner]([assets/pizza.png](https://github.com/mayuresh-2601/Pizza-Sales-SQL/blob/main/Pizza.png))

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
