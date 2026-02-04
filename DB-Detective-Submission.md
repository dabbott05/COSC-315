# COSC 315 Database Detectives
Name: Daniel Abbott

Date: 2/4
## Task Results
### Task 2 - Inventory the Database
Link to Finalized DrawSQL ERD: 
https://drawsql.app/teams/danielll/diagrams/dbim-2


Enter your report here.

<bold> 1: 11 Tables exist

2: Core entities - Recording, Release, Creator, Client, Staff, Sale

Supporting / Join - Style, Format, Collection, SaleItem, CollectionItem

All Tables are simple nouns that clearly define the table (Staff, Sale) . The Primary Keys and Foreign Keys are named to directly reference each other .

</bold>

##

### Task 3 - Hypothesize and Test Relationships

### 1:

ReleaseId in the Recording table (links to Release)

CreatorId in the Release table (links to Creator)

ClientId in the Sale table (links to Client).

ManagerId in the Staff table (Self-referencing link to Staff)

AccountRepId in the Client table (links to Staff)


##

### 2 and 3:

#### One to Many

#### Client to Sale

- A client can have many invoices but an invoice can only have 1 client

#### Many to Many
 
 - Collection -> <- CollectionItem -> <- Recording
 
- A playlist can have  many tracks and a track can be on many playlists

##

### 4:

- Joining between Core Tables works perfectly fine (Ex: Sale and Item)

- Joins between Tables like Recording and SaleItem are trickier because not every recording has been sold

##

### 5:

- In the Recording table I looked for Songs that arent assigned to an album (looking for singles)

```
SELECT * FROM Recording WHERE ReleaseId IS NULL
```

```
RETURNS --> EMPTY SET
```

##

### 6:

- When joining Sale and SaleItem the row count increases alot . An invoice could contain multiple songs which explains this anomaly .

##

### Task 4 - Aggregation & Uniqueness Analysis

- I want to know what percent revenue is driven by the top 10% of buyers

- the total number of clients can be found by running,
```
SELECT COUNT(*) AS TotalClients FROM Client;
```

- The we can run the following SQL to find the top 10% of buyers

```
SELECT
    c.FirstName,
    c.LastName,
    SUM(s.SaleTotal) AS TotalSpent
FROM Client c
JOIN Sale s ON c.ClientId = s.ClientId
GROUP BY c.ClientId
ORDER BY TotalSpent DESC
LIMIT 6;
```

this returns the top 10 clients who have driven the most revenue

```
+-----------+------------+------------+
| FirstName | LastName   | TotalSpent |
+-----------+------------+------------+
| Helena    | Holý       |      49.62 |
| Richard   | Cunningham |      47.62 |
| Luis      | Rojas      |      46.62 |
| Ladislav  | Kovács     |      45.62 |
| Hugh      | O'Reilly   |      45.62 |
| Julia     | Barnett    |      43.62 |
+-----------+------------+------------+
```

##

### Task 5 - Anomalies & Design Issues

### Design Issues

- In the Client Table, the State field has no NOT NULL constraint which can create inconsistencies

    PROOF:

        The State column contains inconsistent data for international clients . Some have abbreviations "CA" , others have full names, and many are NULL

     ```
    SELECT Country, Count(*) FROM Client WHERE State IS NULL GROUP BY Country
    ```

- To fix this , I would rename the State field to State/Province . I would also implement a strict standard where instead of marking the State field as NULL, it would have a constraint of NOT NULL and one would simply put N/A instead of NULL

##

### Task 6 - Explore the Data

### Fact 1:

- The genre "Rock" Dominates the amount of ItemsSold

```
SELECT
    s.Name AS Genre,
    COUNT(si.SaleItemId) AS ItemsSold,
    SUM(si.ItemPrice * si.Quantity) AS TotalRevenue
FROM Style s
JOIN Recording r ON s.StyleId = r.StyleId
JOIN SaleItem si ON r.RecordingId = si.RecordingId
GROUP BY s.Name
ORDER BY TotalRevenue DESC
LIMIT 5;
```

```
+--------------------+-----------+--------------+
| Genre              | ItemsSold | TotalRevenue |
+--------------------+-----------+--------------+
| Rock               |       835 |       826.65 |
| Latin              |       386 |       382.14 |
| Metal              |       264 |       261.36 |
| Alternative & Punk |       244 |       241.56 |
| TV Shows           |        47 |        93.53 |
+--------------------+-----------+--------------+
```

- This presents risk because the majority of the companies revenue comes from "Rock" music

### Fact 2:

- The USA is the major revenue driver

```
SELECT
    BillCountry AS Country,
    SUM(SaleTotal) AS TotalRevenue,
    COUNT(SaleId) AS TransactionCount
FROM Sale
GROUP BY BillCountry
ORDER BY TotalRevenue DESC
LIMIT 5;
```

```
+---------+--------------+------------------+
| Country | TotalRevenue | TransactionCount |
+---------+--------------+------------------+
| USA     |       523.06 |               91 |
| Canada  |       303.96 |               56 |
| France  |       195.10 |               35 |
| Brazil  |       190.10 |               35 |
| Germany |       156.48 |               28 |
+---------+--------------+------------------+
```

- This presents risks because if sudden restrictions and regulations get enforced in the USA this company does not have a reliable backup market

### Fact3:

- Who in the staff, are responsible for the most sales ?

```
SELECT
    st.FirstName,
    st.LastName,
    SUM(s.SaleTotal) AS TotalRevenueGenerated,
    COUNT(s.SaleId) AS TotalSalesClosed
FROM Staff st
JOIN Client c ON st.StaffId = c.AccountRepId
JOIN Sale s ON c.ClientId = s.ClientId
GROUP BY st.FirstName, st.LastName
ORDER BY TotalRevenueGenerated DESC;
```

```
+-----------+----------+-----------------------+------------------+
| FirstName | LastName | TotalRevenueGenerated | TotalSalesClosed |
+-----------+----------+-----------------------+------------------+
| Jane      | Peacock  |                833.04 |              146 |
| Margaret  | Park     |                775.40 |              140 |
| Steve     | Johnson  |                720.16 |              126 |
+-----------+----------+-----------------------+------------------+
```

- It is a fact that Jane, Margaret and Steve are responsible for the most sales

##

### AI Traceability Log
AI Used: Grok 4.1 <3, Gemini PRO 
```
- Asked the AI to generate specific SQL tests to verify Foreign Key relationships and determine cardinality (One-to-Many vs. Many-to-Many), specifically focusing on the CollectionItem table

- Requested an aggregation strategy to analyze entity magnitude and attribute uniqueness, specifically asking how to detect distribution anomalies in the Recording and Client tables

- Asked the AI to inspect the schema for design anomalies

- Requested assistance in formulating exploratory SQL queries to uncover non-obvious business insights

- Asked for the most efficient SQL method to identify the top 10% of customers

- Asked for a list of prompts and explanations for AI log

"What is the best way to find the to find the total count of all clients"

"What does the SQL look like to calculate the top 10% of clients driving revenue"

"Look for Redundant data, Repeating groups, Inconsistent values, Columns that encode multiple facts"

- Gave Gemini and Grok the full Create Table statements

AI thorughout this project was very helpful . I used Grok 4.1 and Gemini PRO , I preffered Gemini Pro over Grok for this assignment but I suspect I would have preffered Grok if I had a premium subscription . Everyone makes fun of me for mainly using grok ... I like how its trained on and can access twitter data . Overall using AI made this assignment alot easier . I found it helped best when i was working on this assignment while not on campus (I live off-campus) . It gave me how it thinks the database is setup/will act , and then I would go on campus and confirm or deny the AI's theories .
```
### SQL Log

```
USE COSC315DD;
USE COSC315DD
SHOW GRANTS FOR 'dabbott1'@'localhost';
GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'host';
GRANT ALL PRIVILEGES ON COSC315DD.* TO 'dabbott1'@'localhost';
quit
USE COSC315DD;
SHOW TABLES
SHOW TABLES;
SHOW COLUMNS FROM CLIENT;
Select * FROM Client
;
SHOW TABLE Client\134G;
SHOW CREATE TABLE Client\134G;
SHOW CREATE TABLE Collection\134G;
SHOW CREATE TABLE CollectionItem\134G;
SHOW CREATE TABLE Creator\134G;
SHOW CREATE TABLE Format\134G;
SHOW CREATE TABLE Recording\134G;
SHOW CREATE TABLE Release\134G;
SHOW TABLE Release;
SHOW CREATE TABLE Sale\134G;
SHOW CREATE TABLE SaleItem\134G;
SHOW CREATE TABLE ~Release~\134G;
SHOW CREATE TABLE `Release`\134G;
SHOW CREATE TABLE Staff\134G;
SHOW CREATE TABLE Style\134G;
SELECT * FROM Client JOIN Staff ON Client.AccountRepId = Staff.StaffId
;
SELECT * FROM Client WHERE AccountRepId NOT IN (SELECT StaffId FROM Staff);
SELECT * FROM Recording JOIN Release ON Recording.ReleaseId = Release.ReleaseId
;
SELECT * FROM Recording JOIN Release ON Recording.ReleaseId = Release.ReleaseId;
SELECT * FROM Recording WHERE ReleaseId IS NULL
;
SELECT * FROM Recording WHERE ReleaseId IS NULL;
SELECT ReleaseId  FROM Recording WHERE ReleaseId IS NULL
;
SELECT * FROM Recording WHERE ReleaseID IS NULL;
COUNT(ReleaseId) = 0;
SHOW TABLES;
USE COSC315DD;
SELECT COUNT(*) AS TotalClients FROM Client;
SELECT 
    c.FirstName, 
    c.LastName, 
    SUM(s.SaleTotal) AS TotalSpent
FROM Client c
JOIN Sale s ON c.ClientId = s.ClientId
GROUP BY c.ClientId
ORDER BY TotalSpent DESC
LIMIT 6;
SELECT      c.FirstName,      c.LastName,      SUM(s.SaleTotal) AS TotalSpent FROM Client c JOIN Sale s ON c.ClientId = s.ClientId GROUP BY c.ClientId ORDER BY TotalSpent DESC LIMIT 6;
SELECT 
    s.Name AS Genre, 
    COUNT(si.SaleItemId) AS ItemsSold,
    SUM(si.ItemPrice * si.Quantity) AS TotalRevenue
FROM Style s
JOIN Recording r ON s.StyleId = r.StyleId
JOIN SaleItem si ON r.RecordingId = si.RecordingId
GROUP BY s.Name
ORDER BY TotalRevenue DESC
LIMIT 5;
SELECT      s.Name AS Genre,      COUNT(si.SaleItemId) AS ItemsSold,     SUM(si.ItemPrice * si.Quantity) AS TotalRevenue FROM Style s JOIN Recording r ON s.StyleId = r.StyleId JOIN SaleItem si ON r.RecordingId = si.RecordingId GROUP BY s.Name ORDER BY TotalRevenue DESC LIMIT 5;
SELECT 
    BillingCountry AS Country, 
    SUM(SaleTotal) AS TotalRevenue, 
    COUNT(SaleId) AS TransactionCount
FROM Sale
GROUP BY BillingCountry
ORDER BY TotalRevenue DESC
LIMIT 5;
SELECT      BillingCountry AS Country,      SUM(SaleTotal) AS TotalRevenue,      COUNT(SaleId) AS TransactionCount FROM Sale GROUP BY BillingCountry ORDER BY TotalRevenue DESC LIMIT 5;
SELECT 
    BillingCountry AS Country, 
    SUM(SaleTotal) AS TotalRevenue, 
    COUNT(SaleId) AS TransactionCount
FROM Sale
GROUP BY BillingCountry
ORDER BY TotalRevenue DESC
LIMIT 5;
SELECT      BillingCountry AS Country,      SUM(SaleTotal) AS TotalRevenue,      COUNT(SaleId) AS TransactionCount FROM Sale GROUP BY BillingCountry ORDER BY TotalRevenue DESC LIMIT 5;
SELECT 
    BillCountry AS Country, 
    SUM(SaleTotal) AS TotalRevenue, 
    COUNT(SaleId) AS TransactionCount
FROM Sale
GROUP BY BillCountry
ORDER BY TotalRevenue DESC
LIMIT 5;
SELECT      BillCountry AS Country,      SUM(SaleTotal) AS TotalRevenue,      COUNT(SaleId) AS TransactionCount FROM Sale GROUP BY BillCountry ORDER BY TotalRevenue DESC LIMIT 5;
SELECT 
    st.FirstName, 
    st.LastName, 
    SUM(s.SaleTotal) AS TotalRevenueGenerated,
    COUNT(s.SaleId) AS TotalSalesClosed
FROM Staff st
JOIN Client c ON st.StaffId = c.AccountRepId
JOIN Sale s ON c.ClientId = s.ClientId
GROUP BY st.FirstName, st.LastName
ORDER BY TotalRevenueGenerated DESC;
SELECT      st.FirstName,      st.LastName,      SUM(s.SaleTotal) AS TotalRevenueGenerated,     COUNT(s.SaleId) AS TotalSalesClosed FROM Staff st JOIN Client c ON st.StaffId = c.AccountRepId JOIN Sale s ON c.ClientId = s.ClientId GROUP BY st.FirstName, st.LastName ORDER BY TotalRevenueGenerated DESC;
SELECT * FROM Recording WHERE ReleaseId IS NULL
SELECT COUNT(*) AS TotalClients FROM Client;
```