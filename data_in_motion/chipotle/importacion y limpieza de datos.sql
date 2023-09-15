-- Crear la tabla "ventas"
CREATE TABLE ventas (
    order_id INT,
    quantity INT,
    item_name VARCHAR(50),
    choice_description VARCHAR(250),
    item_price DECIMAL(5,2)
);

-- Cargar datos en la tabla desde un archivo TSV
BULK INSERT ventas
FROM 'C:\bulk\chipotle.tsv'
WITH (
    FIELDTERMINATOR = '\t', -- Delimitador de campo (tabulacion en este caso)
    ROWTERMINATOR = '0x0a', -- Delimitador salto de linea (no usar \n)
	FIRSTROW = 2			-- Omite la primera linea (nombres de columnas)
);

-- Seleccionar todos los datos de la tabla "ventas"
SELECT * FROM ventas;

-- Encontrar registros en "ventas" con order_id no numerico
SELECT order_id
FROM ventas
WHERE ISNUMERIC(order_id) = 0;

-- Encontrar registros con order_id que contiene caracteres no numericos
SELECT *
FROM ventas
WHERE PATINDEX('%[^0-9.,]%', order_id) > 0;

-- Encontrar valores de "item_price" que no tienen el formato correcto
SELECT *
FROM ventas
WHERE item_price NOT LIKE '$%';

-- Eliminar el simbolo "$" de los valores en la columna "item_price"
UPDATE ventas
SET item_price = REPLACE(item_price, '$', '');

-- Eliminar espacios en blanco alrededor de todas las columnas
UPDATE ventas
SET item_price = TRIM(item_price),
    order_id = TRIM(order_id),
    quantity = TRIM(quantity),
    item_name = TRIM(item_name),
    choice_description = TRIM(choice_description);

-- Crear una tabla temporal con los datos limpios
CREATE TABLE temporal (
    order_id INT,
    quantity INT,
    item_name VARCHAR(50),
    choice_description VARCHAR(250),
    item_price DECIMAL(5,2)
);


-- Insertar datos limpios en la tabla temporal desde "ventas"
INSERT INTO temporal (order_id, quantity, item_name, 
                    choice_description, item_price)
SELECT CAST(order_id AS INT),
       CAST(quantity AS INT),
       CAST(item_name AS VARCHAR(50)),
       CAST(choice_description AS VARCHAR(250)),
       CAST(item_price AS DECIMAL(5,2))
FROM ventas;

-- Mostrar los datos en la tabla temporal
SELECT * FROM temporal;

-- Eliminar la tabla "ventas" despues de usarla
DROP TABLE ventas;

-- Cambiar el nombre de la tabla temporal a "ventas"
sp_rename 'temporal', 'ventas';

-- Contar la cantidad de registros en la tabla "ventas"
SELECT COUNT(*) FROM ventas;