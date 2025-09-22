-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
--books
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

--customers
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

--orders
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

--get data from selected table
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY books FROM 'C:/sql project files/Books.csv' DELIMITER ',' CSV HEADER;

-- Import Data into Customers Table
COPY customers FROM 'C:/sql project files/Customers.csv' DELIMITER ',' CSV HEADER;

-- Import Data into Orders Table
COPY orders FROM 'C:/sql project files/Orders.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books 
WHERE genre= 'Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM BOOKS
WHERE published_year>1950;

-- 3) List all customers from the Canada:
SELECT * FROM customers
WHERE country= 'Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM orders
WHERE order_date 
BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) 
AS total_stock FROM BOOKS;

-- 6) Find the details of the most expensive book:
SELECT * FROM books 
ORDER BY price 
DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM orders 
WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM orders 
WHERE total_amount>20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM books
GROUP BY genre;

-- 10) Find the book with the lowest stock:
SELECT * FROM books 
ORDER BY stock 
ASC LIMIT 1;

--- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) 
AS total_revenue FROM orders;

-- 12) Retrieve all books written by "J.K. Rowling"
SELECT * FROM Books
WHERE Author = 'J.K. Rowling';

-- 13) List all customers sorted by city (A–Z)
SELECT * FROM Customers
ORDER BY City ASC;

-- 14) Find the total number of customers in the database
SELECT COUNT(*) AS total_customers FROM Customers;

-- 15) Show books with stock greater than 50
SELECT * FROM Books
WHERE Stock > 50;

-- 16) Retrieve orders made by customer with ID = 1
SELECT * FROM Orders
WHERE Customer_ID = 1;

-- 17) Find the average book price
SELECT AVG(Price) AS average_price FROM Books;

-- 18) List the top 3 most recent orders
SELECT * FROM Orders
ORDER BY Order_Date DESC
LIMIT 3;

-- 19) Show all books where price is between 20 and 50
SELECT * FROM Books
WHERE Price BETWEEN 20 AND 50;

-- 20) Retrieve customer names and emails only
SELECT Name, Email FROM Customers;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
SELECT b.Genre, SUM(o. Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT (Order_id) >=2;

-- 4) Find the most frequently ordered book:
SELECT o. Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o 
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;

-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;

-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o. customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;

-- 10) Show each customer’s name, the total number of books they ordered, and the total amount they spent
SELECT 
    c.Name AS customer_name,
    COUNT(o.Order_ID) AS total_orders,
    SUM(o.Quantity) AS total_books_ordered,
    SUM(o.Total_Amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Name
ORDER BY total_spent DESC;








