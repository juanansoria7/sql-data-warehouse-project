/*
============================================================
Creación de las capas del data warehouse (MySQL)
============================================================

Propósito
    Crea una base de datos por capa: bronze, silver y gold.
    En MySQL, base de datos y esquema son lo mismo, así que
    cada una hace el papel de los esquemas del curso
    (SQL Server).

Advertencia
    Si alguna ya existe, se borra con todas sus tablas y
    datos. Haz una copia antes si necesitas conservarlos.
*/

DROP DATABASE IF EXISTS datawarehouse;  -- quita la versión anterior

DROP DATABASE IF EXISTS bronze;
DROP DATABASE IF EXISTS silver;
DROP DATABASE IF EXISTS gold;

CREATE DATABASE bronze;
CREATE DATABASE silver;
CREATE DATABASE gold;
