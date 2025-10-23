-- Drop Triggers if they exist --
DROP TRIGGER IF EXISTS after_order_insert ON Employee CASCADE;


-- Drop Tables if they exist
DROP TABLE IF EXISTS Restaurant CASCADE;
DROP TABLE IF EXISTS Employee CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Customer CASCADE;


-- Drop Sequences if they exist
DROP SEQUENCE IF EXISTS Employee_Seq CASCADE;
DROP SEQUENCE IF EXISTS Order_Seq CASCADE;
DROP SEQUENCE IF EXISTS Customer_Seq CASCADE;


-- Drop Schema if it exists---
DROP SCHEMA IF EXISTS Restaurant CASCADE;


CREATE SCHEMA Restaurant;

SET SEARCH_PATH TO Restaurant;

-------CREATE SEQUENCE---

CREATE SEQUENCE Employee_Seq
START WITH 101
INCREMENT BY 1;

CREATE SEQUENCE Order_Seq
START WITH 1001
INCREMENT BY 1;

CREATE SEQUENCE Customer_Seq
START WITH 7001
INCREMENT BY 1;


------CREATE TABLE-----
CREATE TABLE Restaurant (
    restaurant_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    location VARCHAR(255),
cuisine VARCHAR(255),
Hours VARCHAR(255)
);


CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY DEFAULT NEXTVAL('Employee_Seq'),
    Name VARCHAR(100),
    Role VARCHAR(50),
    Salary DECIMAL(10, 2),
    restaurant_id INT,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id)
);

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY DEFAULT NEXTVAL('Order_Seq'),
    Employee_ID INT,
    Order_Total DECIMAL(10, 2),
    Order_Table_Number INT,
    Order_Payment_Method VARCHAR(50),
    Order_Status VARCHAR(50),
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY DEFAULT NEXTVAL('Customer_Seq'),
    Order_ID INT,
    Customer_Contact BIGINT,
    Customer_email VARCHAR(50),
    Customer_name VARCHAR(50),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);

SELECT * from CUSTOMER
--------------CREATE TRIGGERS----------
CREATE OR REPLACE FUNCTION update_employee_salary()
RETURNS TRIGGER AS $$
DECLARE
commission DECIMAL(10, 2);
BEGIN
-- Calculate commission based on order total
commission := NEW.order_total * 0.05; -- Assuming a 5% commission

-- Update employee's salary
UPDATE employee
SET salary = salary + commission
WHERE employee_id = NEW.employee_id;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION update_employee_salary();
