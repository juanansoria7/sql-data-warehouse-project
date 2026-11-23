/*
============================================================
Reinicio del Data Warehouse en MySQL
============================================================

Propósito
    Crea la base de datos `datawarehouse`. Si ya existe, la
    elimina y la vuelve a crear. A continuación, crea las
    tablas `bronze`, `silver` y `gold`

Advertencia
    Si `datawarehouse` ya existe, se eliminarán todas sus
    tablas y datos. Haz una copia de seguridad antes de
    ejecutar el script si necesitas conservarlos.
*/

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
