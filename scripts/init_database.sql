DROP DATABASE IF EXISTS datawarehouse;
CREATE DATABASE datawarehouse;
USE datawarehouse;

CREATE TABLE bronze (
    id INT PRIMARY KEY
);

CREATE TABLE silver (
    id INT PRIMARY KEY
);

CREATE TABLE gold (
    cliente_id INT PRIMARY KEY
);
