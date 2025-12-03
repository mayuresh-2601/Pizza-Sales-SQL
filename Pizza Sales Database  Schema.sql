
-- DATABASE

CREATE DATABASE IF NOT EXISTS Pizza_Sales;
USE Pizza_Sales;


-- TABLE: pizza_types
-- (Structure based on dataset columns)

CREATE TABLE IF NOT EXISTS pizza_types (
    pizza_type_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    ingredients TEXT NOT NULL,
    PRIMARY KEY (pizza_type_id)
);

-- TABLE: pizzas

CREATE TABLE IF NOT EXISTS pizzas (
    pizza_id VARCHAR(50) NOT NULL,
    pizza_type_id VARCHAR(50) NOT NULL,
    size CHAR(1) NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (pizza_id),
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);

-- TABLE: orders

CREATE TABLE IF NOT EXISTS orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

-- TABLE: order_details

CREATE TABLE IF NOT EXISTS order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id)
);
