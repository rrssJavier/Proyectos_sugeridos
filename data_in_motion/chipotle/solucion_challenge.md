# Solucion Challenge 1: Chipotle Sales

## Limpieza de Datos
```SQL
-- Verifico que si hay valores faltantes
SELECT * 
FROM ventas 
WHERE choice_description = '' OR 
      item_name = '';

-- como la data viene de un archivo de texto NULL lo entiende como texto
UPDATE ventas
SET choice_description = NULL
WHERE choice_description = 'NULL';

-- verifico si hay item con nombre muy parecido (duplicidad)
SELECT DISTINCT 
    item_name
FROM ventas
ORDER BY item_name DESC;

-- Elimino la duplicidad encontrada
UPDATE ventas
SET item_name = 'Chips and Tomatillo Green Chili Salsa'
WHERE item_name = 'Chips and Tomatillo-Green Chili Salsa';

UPDATE ventas
SET item_name = 'Chips and Tomatillo Red Chili Salsa'
WHERE item_name = 'Chips and Tomatillo-Red Chili Salsa';

UPDATE ventas
SET item_name = 'Chips and Roasted Chili Corn Salsa'
WHERE item_name = 'Chips and Roasted Chili-Corn Salsa';
```

## Preguntas del Stakeholder
### Question 1: Which was the most-ordered item?
```SQL
SELECT TOP 1
    item_name,
    SUM(quantity) AS n_vendidos
FROM ventas
GROUP BY
    item_name
ORDER BY
    n_vendidos DESC;
```
### Question 2: For the most-ordered item, how many items were ordered?
    -- Respondida con la pregunta anterior

### Question 3: What was the most ordered item in the choice_description column?
Como la columna choice_description parece ser la lista de ingredientes del item vendido, entiendo que quieren cual es el ingrediente que mas se vende.
```SQL
WITH cte AS (
    SELECT 
        order_id,
        quantity,
        item_name,
        -- Quita los "[" y "]" de la lista de ingredientes
        REPLACE(REPLACE(choice_description, '[', ''), ']', '') AS lista_ingredientes
    FROM ventas
),

cte2 AS (
    SELECT 
        order_id,
        quantity,
        item_name,
        -- value es la salida de la funcion STRING_SPLIT que separa 
        -- los elementos de la lista
        value AS ingrediente
    FROM cte
    CROSS APPLY STRING_SPLIT(lista_ingredientes, ',')
)
-- suma las veces que se uso cada ingrediente y devuelve el mas usado
SELECT TOP 1
    ingrediente,
    SUM(quantity) AS veces_usado
FROM cte2
GROUP BY
    ingrediente
ORDER BY
    veces_usado DESC;
```
### Question 4: How many items were ordered in total?
```SQL
SELECT 
    SUM(quantity) AS total_items_ordered
FROM ventas;
```
### Question 5: Turn the item price into a float
```SQL 
ALTER TABLE ventas
ALTER COLUMN item_price FLOAT;
```
### Question 6: How much was the revenue for the period in the dataset?
```SQL
SELECT 
    SUM(item_price) AS total_revenue
FROM ventas;
```
### Question 7: How many orders were made in the period?
```SQL
SELECT 
    COUNT(order_id) AS n_orders
FROM ventas;
```
### Question 8: What is the average revenue amount per order?
```SQL
SELECT 
    AVG(item_price) AS average_amout_per_order
FROM ventas;
```
### Question 9: How many different items are sold?
```SQL
SELECT
    COUNT(DISTINCT item_name)
FROM ventas;

