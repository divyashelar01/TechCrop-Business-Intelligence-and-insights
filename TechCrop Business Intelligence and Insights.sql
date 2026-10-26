create database Techcorp;
use techcorp;

select * from customers;
select * from departments;
select * from employees;
select * from orders;
select * from products;
select * from salary_grades;

#CREATE
#Q1.Create a new table called project_assignments to store which employee is assigned to which project, including the start date and role.
-- [Hint: Use PRIMARY KEY, NOT NULL, CHECK, REFERENCES constraints]

CREATE TABLE project_assignments (
    assignment_id  INT           PRIMARY KEY,
    emp_id         INT           NOT NULL REFERENCES employees(emp_id),
    project_name   VARCHAR(100)  NOT NULL,
    role           VARCHAR(50)   NOT NULL,
    start_date     DATE          NOT NULL,
    end_date       DATE,
    hours_per_week INT           CHECK (hours_per_week BETWEEN 1 AND 60)
);
select * from project_assignments;
#Q2.  Create a table called product_reviews to allow customers to rate products. Rating must be between 1 and 5.
-- [Hint: REFERENCES, CHECK, DEFAULT, NOT NULL]

CREATE TABLE product_reviews (
    review_id    INT          PRIMARY KEY,
    product_id   INT          NOT NULL REFERENCES products(product_id),
    customer_id  INT          NOT NULL REFERENCES customers(customer_id),
    rating       INT          NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text  VARCHAR(500),
    review_date  DATE         DEFAULT (CURRENT_DATE)
);
select * from product_reviews;

#ALTER
#Q3.  Add a column called linkedin_url (VARCHAR 200) to the employees table.
-- [Hint: ALTER TABLE ... ADD COLUMN]

ALTER TABLE employees ADD COLUMN linkedin_url VARCHAR(200);

#Q4.  Change the data type of the phone column in customers from VARCHAR(15) to VARCHAR(20).
-- [Hint: ALTER TABLE ... MODIFY (Oracle) or ALTER COLUMN (SQL Server / PostgreSQL)]
ALTER TABLE customers MODIFY phone VARCHAR(20);

#Q5.  Drop the linkedin_url column you just added to the employees table.
-- [Hint: ALTER TABLE ... DROP COLUMN]
ALTER TABLE employees DROP COLUMN linkedin_url;

#Q6.  Rename the column notes in orders to order_remarks.
-- [Hint: ALTER TABLE ... RENAME COLUMN]
ALTER TABLE orders RENAME COLUMN notes TO order_remarks;

#DROP & TRUNCATE
#Q7.  Remove the product_reviews table from the database entirely.
-- [Hint: DROP TABLE]
DROP TABLE IF EXISTS product_reviews;

#Q8.  Delete all rows from the product_reviews table without removing the table structure.
-- [Hint: TRUNCATE vs DELETE]
TRUNCATE TABLE product_reviews;
-- TRUNCATE is faster than DELETE; cannot be rolled back in MySQL.
-- DELETE without WHERE also removes all rows but can be rolled back.

#CNSTRAINTS
#Q1.  Try to insert an employee with salary = 15000. What will happen and why?
-- [Hint: CHECK constraint]
INSERT INTO employees
  (emp_id, first_name, last_name, email, hire_date, job_title, salary, dept_id)
VALUES (201, 'Test', 'User', 'test@techcorp.com', '2024-01-01', 'Intern', 15000, 1);

-- Error Code: 3819. Check constraint 'employees_chk_1' is violated.	0.000 sec

#Q2.  What happens if you try to insert a department with the name 'Engineering' (which already exists)?
-- [Hint: UNIQUE constraint]
INSERT INTO departments VALUES (11, 'Engineering', 'Pune', 3000000, CURRENT_DATE);

-- 	Error Code: 1062. Duplicate entry 'Engineering' for key 'departments.dept_name'	0.016 sec

#Q3.  Add a UNIQUE constraint to the phone column of the employees table (ALTER TABLE).
-- [Hint: ALTER TABLE ... ADD CONSTRAINT]
ALTER TABLE employees
ADD CONSTRAINT uq_emp_phone UNIQUE (phone);

#Q4.  Add a CHECK constraint on the orders table to ensure total_amount > 0.
-- [Hint: ALTER TABLE ... ADD CHECK]
ALTER TABLE orders
ADD CONSTRAINT chk_total_positive CHECK (total_amount > 0);

#Q5.  Drop the CHECK constraint you just added on total_amount.
-- [Hint: ALTER TABLE ... DROP CONSTRAINT]
ALTER TABLE orders DROP CHECK chk_total_positive;

#INSERT
#Q1.  Insert a new department called 'Cybersecurity' located in Bangalore with a budget of ₹40,00,000.
-- [Hint: INSERT INTO ... VALUES]
INSERT INTO departments (dept_id, dept_name, location, budget, created_at)
VALUES (11, 'Cybersecurity', 'Bangalore', 4000000.00, CURRENT_DATE);

#Q2.  Insert a new customer 'Infosys Ltd' from Pune, Maharashtra with a credit limit of ₹9,00,000.
-- [Hint: INSERT with specific columns]
INSERT INTO customers
  (customer_id, company_name, contact_name, city, state, country, credit_limit, joined_date, is_active)
VALUES
  (101, 'Infosys Ltd', 'Rajiv Sharma', 'Pune', 'Maharashtra', 'India', 900000.00, CURRENT_DATE, TRUE);
  
  #Q3.  Insert two new products in one single INSERT statement: 'Edge Computing Basic' at ₹8,999 and 'Edge Computing Pro' at ₹19,999, both in the 'IoT' category.
-- [Hint: Multi-row INSERT]
INSERT INTO products (product_id, product_name, category, unit_price, stock_qty, is_active)
VALUES
  (51, 'Edge Computing Basic', 'IoT', 8999.00, 100, TRUE),
  (52, 'Edge Computing Pro',   'IoT', 19999.00, 50, TRUE);
  
  #UPDATE
  #Q4.  Give all employees in the Engineering department (dept_id = 1) a 10% salary hike.
-- [Hint: UPDATE with WHERE clause]
UPDATE employees
SET  salary = salary * 1.10
 WHERE  dept_id = 1;


#Q5.  Mark all employees hired before 2019-01-01 who are in the 'HR' department as inactive.
-- [Hint: UPDATE with multiple conditions]
UPDATE employees
SET    is_active = FALSE
WHERE  dept_id = 4;

#Q6.  A product price change: increase the unit_price of all 'Support' category products by ₹500.
-- [Hint: UPDATE with category filter]
UPDATE products
SET    unit_price = unit_price + 500
WHERE  category = 'Support';

#Q7.  Set the status of all 'Pending' orders placed before '2023-06-01' to 'Cancelled' and add a note 'Auto-expired'.
-- [Hint: UPDATE multiple columns]
desc orders;
show columns from orders;

UPDATE orders
SET    status = 'Cancelled',
       order_remarks = 'Auto-expired'
WHERE  status = 'Pending'
AND    order_date < '2023-06-01';


#DELETE
#Q8.  Delete all orders that have been Cancelled and have a total_amount less than ₹5,000.
-- [Hint: DELETE with WHERE]
DELETE FROM orders
WHERE status = 'Cancelled'
AND   total_amount < 5000;

#Q9.  Remove all inactive customers (is_active = FALSE) from the customers table.
-- [Hint: DELETE with boolean filter]
DELETE FROM customers
WHERE is_active = FALSE;

#SELECT
#Q10.  Retrieve the first name, last name, job title and salary of all active employees.
-- [Hint: SELECT specific columns + WHERE]
SELECT first_name, last_name, job_title, salary
FROM   employees
WHERE  is_active = TRUE;

#Q11.  Get all unique job titles that exist in the employees table.
-- [Hint: SELECT DISTINCT]
SELECT DISTINCT job_title
FROM employees
ORDER BY job_title;

#TCL
#Q1.  A new employee is being hired. Write a transaction that inserts the employee, then commits. If anything fails, roll back.
-- [Hint: BEGIN, INSERT, COMMIT, ROLLBACK]
START TRANSACTION;

INSERT INTO employees (emp_id, first_name, last_name, email, hire_date,
                       job_title, salary, dept_id, is_active)
VALUES (151, 'Anil', 'Tiwari', 'anil.tiwari@techcorp.com',
        '2024-04-01', 'Engineer', 85000, 1, TRUE);

-- Verify before committing:
SELECT * FROM employees WHERE emp_id = 152;

COMMit;


#Q2.  You need to raise salaries of Engineering AND Finance together. Both must succeed or neither should be saved.
-- [Hint: Transaction spanning multiple UPDATEs]

START TRANSACTION;

UPDATE employees SET salary = salary * 1.08 WHERE dept_id = 1;  -- Engineering
UPDATE employees SET salary = salary * 1.08 WHERE dept_id = 5;  -- Finance

-- If both succeed:
COMMIT;

#Q3.  Use a SAVEPOINT during a batch of order insertions so you can roll back only the last insert if it fails, without losing the earlier ones.
-- [Hint: SAVEPOINT + partial ROLLBACK]
START TRANSACTION;

INSERT INTO orders (order_id, customer_id, product_id, emp_id, order_date,
                    quantity, unit_price, total_amount, status)
VALUES (201, 5, 3, 12, '2024-04-01', 2, 29999, 59998, 'Pending');

SAVEPOINT after_order_201;

INSERT INTO orders (order_id, customer_id, product_id, emp_id, order_date,
                    quantity, unit_price, total_amount, status)
VALUES (202, 6, 42, 7, '2024-04-01', 1, 49999, 49999, 'Pending');

#Q4.  What is the difference between ROLLBACK and ROLLBACK TO SAVEPOINT?
-- [Hint: Concept question]
-- ROLLBACK:   Undoes ALL uncommitted changes in the current transaction.
-- ROLLBACK TO SAVEPOINT <name>:  Undoes changes only AFTER that savepoint.
--   Earlier changes in the same transaction are preserved.
--   The transaction is still open after ROLLBACK TO SAVEPOINT

# WHERE Clause
#Q1.  List all employees who work in 'Bangalore' and have a salary greater than ₹1,00,000.
-- [Hint: WHERE with AND]
SELECT emp_id, first_name, last_name, job_title, salary
FROM   employees
WHERE  city = 'Bangalore'
AND    salary > 100000;

#Q2.  Find all orders where the status is 'Delivered' and payment_mode is 'Bank Transfer'.
-- [Hint: WHERE with two string conditions]
SELECT order_id, customer_id, order_date, total_amount, status, payment_mode
FROM   orders
WHERE  status = 'Delivered'
AND    payment_mode = 'Bank Transfer';


# ORDER BY Clause
#Q3.  List all employees sorted by salary in descending order. If salaries are equal, sort by last_name alphabetically.
-- [Hint: ORDER BY multiple columns]
SELECT emp_id, first_name, last_name, salary
FROM   employees
ORDER BY salary DESC, last_name ASC;

#Q4.  Show all products sorted by category (A-Z) and then by unit_price within each category (low to high).
-- [Hint: ORDER BY two columns]
SELECT product_name, category, unit_price
FROM   products
ORDER BY category ASC, unit_price ASC;


# GROUP BY Clause
#Q5.  Count the number of employees in each department.
-- [Hint: GROUP BY + COUNT]
SELECT dept_id, COUNT(*) AS employee_count
FROM   employees
GROUP BY dept_id
ORDER BY employee_count DESC;

#Q6.  Find the total salary paid by each department for active employees.
-- [Hint: GROUP BY + SUM with WHERE]
SELECT dept_id, SUM(salary) AS total_salary
FROM   employees
WHERE  is_active = TRUE
GROUP BY dept_id
ORDER BY total_salary DESC;

#Q7.  Find the number of orders placed for each product, along with the total revenue per product.
-- [Hint: GROUP BY + COUNT + SUM]
SELECT product_id,
       COUNT(*)           AS order_count,
       SUM(total_amount)  AS total_revenue
FROM   orders
GROUP BY product_id
ORDER BY total_revenue DESC;

#HAVING CLAUSES
#Q8.  Find departments that have more than 15 employees.
-- [Hint: HAVING + COUNT]
SELECT dept_id, COUNT(*) AS emp_count
FROM   employees
GROUP BY dept_id
HAVING COUNT(*) > 15;

#Q9.  Show product categories where the average unit_price is more than ₹15,000.
-- [Hint: HAVING + AVG]
SELECT category, AVG(unit_price) AS avg_price
FROM   products
GROUP BY category
HAVING AVG(unit_price) > 15000
ORDER BY avg_price DESC;

#Q10.  Find cities from which more than 10 active employees are working.
-- [Hint: HAVING with WHERE combined]
SELECT city, COUNT(*) AS emp_count
FROM   employees
WHERE  is_active = TRUE
GROUP BY city
HAVING COUNT(*) > 10
ORDER BY emp_count DESC;

# LIMIT Clause
#Q11.  Show the top 5 highest-paid employees.
-- [Hint: ORDER BY + LIMIT]
SELECT emp_id, first_name, last_name, job_title, salary
FROM   employees
ORDER BY salary DESC
LIMIT 5;

#Q12.  Find all employees whose email ends with '@techcorp.com'.
-- [Hint: LIKE with leading %]
SELECT first_name, last_name, email
FROM   employees
WHERE  email LIKE '%@techcorp.com';

#Q13.  Find all employees whose last name is exactly 5 characters long.
-- [Hint: LIKE with _ wildcard]
SELECT first_name, last_name
FROM   employees
WHERE  last_name LIKE '_____';   -- five underscore characters

#IN Operator
#Q14.  Find all employees who work in departments 1, 3, or 10.
-- [Hint: IN with a list]
SELECT emp_id, first_name, dept_id
FROM   employees
WHERE  dept_id IN (1, 3, 10);

#Q15.  List all orders whose status is either 'Pending' or 'Processing' or 'Shipped'.
-- [Hint: IN for status filter]
SELECT order_id, order_date, status, total_amount
FROM   orders
WHERE  status IN ('Pending', 'Processing', 'Shipped')
ORDER BY order_date;

#Q16.  Find all products supplied by either 'SecureNet' or 'DevFlow'.
-- [Hint: IN with string list]
SELECT product_name, category, supplier, unit_price
FROM   products
WHERE  supplier IN ('SecureNet', 'DevFlow');

#Q17.  Using NOT IN, find all employees who do NOT work in the cities Mumbai, Delhi, or Chennai.
-- [Hint: NOT IN]
SELECT first_name, last_name, city
FROM   employees
WHERE  city NOT IN ('Mumbai', 'Delhi', 'Chennai');

#IS NULL / IS NOT NULL
#Q18.  Find all employees who do NOT have a manager (i.e., they are top-level executives).
-- [Hint: IS NULL]
SELECT emp_id, first_name, last_name, job_title
FROM   employees
WHERE  manager_id IS NULL;

#Q19.  Find all orders that have a note (notes column is not empty).
-- [Hint: IS NOT NULL]
SELECT order_id, customer_id, order_date, order_remarks
FROM   orders
WHERE order_remarks IS NOT NULL;

#Arithmetic Operators
#Q20.  Show each employee's annual Cost to Company (CTC) assuming 12 monthly salaries + ₹50,000 annual bonus.
-- [Hint: Arithmetic in SELECT]
SELECT first_name, last_name,
       salary                         AS monthly_salary,
       (salary * 12) + 50000          AS annual_ctc
FROM   employees
WHERE  is_active = TRUE
ORDER BY annual_ctc DESC;

#Q21.  Calculate the discount amount (in ₹) for every order that has a non-zero discount.
-- [Hint: Arithmetic: price × discount %]
SELECT order_id,
       unit_price,
       discount_pct,
       ROUND(unit_price * discount_pct / 100, 2) AS discount_amount
FROM   orders
WHERE  discount_pct > 0;

#Q22.  Show the remaining stock after assuming all current stock is at reorder risk (stock_qty - reorder_level).
-- [Hint: Subtraction in SELECT]
SELECT product_name,
       stock_qty,
       reorder_level,
       stock_qty - reorder_level AS stock_buffer
FROM   products
WHERE  is_active = TRUE
ORDER BY stock_buffer ASC;

#COMBINE QUESTIONS
#Q1.  Create a table emp_audit with columns: audit_id (PK), emp_id (FK to employees), change_type (CHECK: 'INSERT','UPDATE','DELETE'), changed_at (DEFAULT NOW()), changed_by VARCHAR(50).
-- [Hint: DDL + Constraints combined]
CREATE TABLE emp_audit (
    audit_id    INT         PRIMARY KEY,
    emp_id      INT         REFERENCES employees(emp_id),
    change_type VARCHAR(10) CHECK (change_type IN ('INSERT','UPDATE','DELETE')),
    changed_at  DATETIME    DEFAULT NOW(),
    changed_by  VARCHAR(50) NOT NULL
);

#Q2.  In one transaction: (a) Give a 5% raise to all Sales employees (dept_id=2), (b) set is_active=FALSE for Sales employees hired before 2019, (c) COMMIT if both succeed.
-- [Hint: TCL + multiple DML]
START TRANSACTION;

UPDATE employees
SET    salary = salary * 1.05
WHERE  dept_id = 2;

UPDATE employees
SET    is_active = FALSE
WHERE  dept_id = 2
AND    hire_date < '2019-01-01';
commit;

#Q3.  Find the department with the highest average salary among departments where at least 10 employees are active. Show dept_id, avg salary, and employee count.
-- [Hint: GROUP BY + HAVING + ORDER BY + LIMIT]
SELECT dept_id,
       COUNT(*)        AS emp_count,
       AVG(salary)     AS avg_salary
FROM   employees
WHERE  is_active = TRUE
GROUP BY dept_id
HAVING COUNT(*) >= 10
ORDER BY avg_salary DESC
LIMIT 1;

#Q4.  List all products in the 'Cloud Services' or 'AI Services' category priced above ₹20,000 that are still active.
-- [Hint: IN + AND + WHERE]
SELECT product_name, category, unit_price
FROM   products
WHERE  category IN ('Cloud Services', 'AI Services')
AND    unit_price > 20000
AND    is_active = TRUE
ORDER BY unit_price DESC;

#Q5.  Find all orders placed in 2023 where quantity is between 2 and 10 AND payment mode is Online AND total_amount > ₹25,000.
-- [Hint: BETWEEN + AND + comparison operators]
SELECT order_id, order_date, quantity, payment_mode, total_amount
FROM   orders
WHERE  order_date BETWEEN '2023-01-01' AND '2023-12-31'
AND    quantity    BETWEEN 2 AND 10
AND    payment_mode = 'Online'
AND    total_amount > 25000
ORDER BY total_amount DESC;

#Q6.  Show all employees whose first name contains the letter 'a' (case-insensitive), who are active, and whose salary is not between ₹60,000 and ₹80,000.
-- [Hint: LIKE + NOT BETWEEN + AND]
SELECT first_name, last_name, salary
FROM   employees
WHERE  (first_name LIKE '%a%' OR first_name LIKE '%A%')
AND    is_active = TRUE
AND    salary NOT BETWEEN 60000 AND 80000
ORDER BY first_name;


















