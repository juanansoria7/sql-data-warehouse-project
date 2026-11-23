/*
============================================================
load_bronze.sql · Carga de la capa Bronze (MariaDB / MySQL)
============================================================

Equivale al procedimiento bronze.load_bronze del curso.
MySQL no permite LOAD DATA dentro de procedimientos, así
que la carga se hace con este script y se lanza entero.

Full load: vacía cada tabla y la vuelve a llenar desde
los CSV de CRM y ERP, tal cual vienen del origen.

Los mensajes de progreso se guardan en la tabla temporal
print_log y se muestran todos juntos, en orden, al final.
*/

USE datawherehouse;

-- Tabla temporal para los mensajes (solo existe durante esta ejecución)
DROP TEMPORARY TABLE IF EXISTS print_log;
CREATE TEMPORARY TABLE print_log (
    id  INT AUTO_INCREMENT PRIMARY KEY,
    msg VARCHAR(255)
);

SET @inicio = NOW(3);

INSERT INTO print_log (msg) VALUES
    ('================================================'),
    ('Cargando capa Bronze'),
    ('================================================');

-- ============================================================
-- CRM
-- ============================================================

INSERT INTO print_log (msg) VALUES
    ('------------------------------------------------'),
    ('Cargando tablas CRM'),
    ('------------------------------------------------');

-- CRM · Clientes
SET @t = NOW(3);
INSERT INTO print_log (msg) VALUES ('>> Vaciando tabla: bronze_crm_cust_info');
TRUNCATE TABLE bronze_crm_cust_info;
INSERT INTO print_log (msg) VALUES ('>> Insertando datos en: bronze_crm_cust_info');
LOAD DATA LOCAL INFILE 'C:/Users/juanan/Downloads/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE bronze_crm_cust_info
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES
(@cst_id, cst_key, cst_firstname, cst_lastname,
 cst_marital_status, cst_gndr, @cst_create_date)
SET
    cst_id          = NULLIF(@cst_id, ''),
    cst_create_date = NULLIF(TRIM(TRAILING '\r' FROM @cst_create_date), '');
SET @filas = ROW_COUNT();
INSERT INTO print_log (msg) VALUES
    (CONCAT('>> Filas cargadas: ', @filas)),
    (CONCAT('>> Duración: ', ROUND(TIMESTAMPDIFF(MICROSECOND, @t, NOW(3)) / 1000000, 2), ' segundos')),
    ('>> -------------');

-- CRM · Productos
SET @t = NOW(3);
INSERT INTO print_log (msg) VALUES ('>> Vaciando tabla: bronze_crm_prd_info');
TRUNCATE TABLE bronze_crm_prd_info;
INSERT INTO print_log (msg) VALUES ('>> Insertando datos en: bronze_crm_prd_info');
LOAD DATA LOCAL INFILE 'C:/Users/juanan/Downloads/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE bronze_crm_prd_info
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES
(@prd_id, prd_key, prd_nm, @prd_cost, prd_line, @prd_start_dt, @prd_end_dt)
SET
    prd_id       = NULLIF(@prd_id, ''),
    prd_cost     = NULLIF(@prd_cost, ''),
    prd_start_dt = NULLIF(@prd_start_dt, ''),
    prd_end_dt   = NULLIF(TRIM(TRAILING '\r' FROM @prd_end_dt), '');
SET @filas = ROW_COUNT();
INSERT INTO print_log (msg) VALUES
    (CONCAT('>> Filas cargadas: ', @filas)),
    (CONCAT('>> Duración: ', ROUND(TIMESTAMPDIFF(MICROSECOND, @t, NOW(3)) / 1000000, 2), ' segundos')),
    ('>> -------------');

-- CRM · Detalle de ventas
SET @t = NOW(3);
INSERT INTO print_log (msg) VALUES ('>> Vaciando tabla: bronze_crm_sales_details');
TRUNCATE TABLE bronze_crm_sales_details;
INSERT INTO print_log (msg) VALUES ('>> Insertando datos en: bronze_crm_sales_details');
LOAD DATA LOCAL INFILE 'C:/Users/juanan/Downloads/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE bronze_crm_sales_details
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES
(sls_ord_num, sls_prd_key, @sls_cust_id,
 @sls_order_dt, @sls_ship_dt, @sls_due_dt,
 @sls_sales, @sls_quantity, @sls_price)
SET
    sls_cust_id  = NULLIF(@sls_cust_id, ''),
    sls_order_dt = NULLIF(@sls_order_dt, ''),
    sls_ship_dt  = NULLIF(@sls_ship_dt, ''),
    sls_due_dt   = NULLIF(@sls_due_dt, ''),
    sls_sales    = NULLIF(@sls_sales, ''),
    sls_quantity = NULLIF(@sls_quantity, ''),
    sls_price    = NULLIF(TRIM(TRAILING '\r' FROM @sls_price), '');
SET @filas = ROW_COUNT();
INSERT INTO print_log (msg) VALUES
    (CONCAT('>> Filas cargadas: ', @filas)),
    (CONCAT('>> Duración: ', ROUND(TIMESTAMPDIFF(MICROSECOND, @t, NOW(3)) / 1000000, 2), ' segundos')),
    ('>> -------------');

-- ============================================================
-- ERP
-- ============================================================

INSERT INTO print_log (msg) VALUES
    ('------------------------------------------------'),
    ('Cargando tablas ERP'),
    ('------------------------------------------------');

-- ERP · Clientes
SET @t = NOW(3);
INSERT INTO print_log (msg) VALUES ('>> Vaciando tabla: bronze_erp_cust_az12');
TRUNCATE TABLE bronze_erp_cust_az12;
INSERT INTO print_log (msg) VALUES ('>> Insertando datos en: bronze_erp_cust_az12');
LOAD DATA LOCAL INFILE 'C:/Users/juanan/Downloads/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE bronze_erp_cust_az12
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES
(cid, @bdate, @gen)
SET
    bdate = NULLIF(@bdate, ''),
    gen   = TRIM(TRAILING '\r' FROM @gen);
SET @filas = ROW_COUNT();
INSERT INTO print_log (msg) VALUES
    (CONCAT('>> Filas cargadas: ', @filas)),
    (CONCAT('>> Duración: ', ROUND(TIMESTAMPDIFF(MICROSECOND, @t, NOW(3)) / 1000000, 2), ' segundos')),
    ('>> -------------');

-- ERP · Ubicación de clientes
SET @t = NOW(3);
INSERT INTO print_log (msg) VALUES ('>> Vaciando tabla: bronze_erp_loc_a101');
TRUNCATE TABLE bronze_erp_loc_a101;
INSERT INTO print_log (msg) VALUES ('>> Insertando datos en: bronze_erp_loc_a101');
LOAD DATA LOCAL INFILE 'C:/Users/juanan/Downloads/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
INTO TABLE bronze_erp_loc_a101
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES
(cid, @cntry)
SET
    cntry = TRIM(TRAILING '\r' FROM @cntry);
SET @filas = ROW_COUNT();
INSERT INTO print_log (msg) VALUES
    (CONCAT('>> Filas cargadas: ', @filas)),
    (CONCAT('>> Duración: ', ROUND(TIMESTAMPDIFF(MICROSECOND, @t, NOW(3)) / 1000000, 2), ' segundos')),
    ('>> -------------');

-- ERP · Categorías de producto
SET @t = NOW(3);
INSERT INTO print_log (msg) VALUES ('>> Vaciando tabla: bronze_erp_px_cat_g1v2');
TRUNCATE TABLE bronze_erp_px_cat_g1v2;
INSERT INTO print_log (msg) VALUES ('>> Insertando datos en: bronze_erp_px_cat_g1v2');
LOAD DATA LOCAL INFILE 'C:/Users/juanan/Downloads/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE bronze_erp_px_cat_g1v2
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES
(id, cat, subcat, @maintenance)
SET
    maintenance = TRIM(TRAILING '\r' FROM @maintenance);
SET @filas = ROW_COUNT();
INSERT INTO print_log (msg) VALUES
    (CONCAT('>> Filas cargadas: ', @filas)),
    (CONCAT('>> Duración: ', ROUND(TIMESTAMPDIFF(MICROSECOND, @t, NOW(3)) / 1000000, 2), ' segundos')),
    ('>> -------------');

-- ============================================================
-- Fin de la carga
-- ============================================================

INSERT INTO print_log (msg) VALUES
    ('================================================'),
    ('Carga de Bronze terminada'),
    (CONCAT('Duración total: ', ROUND(TIMESTAMPDIFF(MICROSECOND, @inicio, NOW(3)) / 1000000, 2), ' segundos')),
    ('================================================');

-- Mostrar todos los mensajes, en orden
SELECT msg AS log_carga FROM print_log ORDER BY id;
