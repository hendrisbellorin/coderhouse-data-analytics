-- Motor utilizado: SQL Server (SSMS)
-- =====================================================================
-- Proyecto final — Data Analytics (Coderhouse)
-- Pre-entrega M4: Consultas SQL de negocio
-- Base: Ventas_Tech_DB (creada en M3, ver modulo-3/ventas_tech_db.sql)
-- Alumno: Hendris Bellorín
--
-- Todas las consultas trabajan solo sobre la tabla ventas, con IDs.
-- Los nombres de clientes y productos se van a traer con JOIN en M5.
--
-- Criterios usados en todo el archivo:
--   * Importe de una línea = cantidad * precio_unitario.
--   * Cada fila de ventas cuenta como un pedido. La tabla no tiene
--     número de factura, así que no hay forma de agrupar líneas en
--     un mismo pedido.
-- =====================================================================

USE Ventas_Tech_DB;
GO


-- =====================================================================
-- === CONSULTA 1: Resumen ejecutivo mensual ===
-- Total facturado, cantidad de pedidos y ticket promedio por mes.
-- Agrupo también por año: si solo agrupara por MONTH, marzo de 2024 y
-- marzo de 2025 terminarían sumados en la misma fila.
-- =====================================================================
SELECT
    YEAR(fecha_venta)                    AS anio,
    MONTH(fecha_venta)                   AS mes,
    SUM(cantidad * precio_unitario)      AS total_facturado,
    COUNT(*)                             AS cantidad_pedidos,
    CAST(AVG(cantidad * precio_unitario) AS DECIMAL(10,2)) AS ticket_promedio
FROM ventas
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY anio, mes;


-- =====================================================================
-- === CONSULTA 2: Ranking de productos ===
-- Top 5 de productos por total facturado, con las unidades vendidas.
-- Sumo el porcentaje sobre la facturación total para ver cuánto pesa
-- cada producto (lo uso en los hallazgos del final).
-- =====================================================================
SELECT TOP 5
    id_producto,
    SUM(cantidad)                        AS unidades_vendidas,
    SUM(cantidad * precio_unitario)      AS total_facturado,
    CAST(100.0 * SUM(cantidad * precio_unitario)
         / (SELECT SUM(cantidad * precio_unitario) FROM ventas)
         AS DECIMAL(5,2))                AS porcentaje_del_total
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- =====================================================================
-- === CONSULTA 3: Clientes recurrentes ===
-- Clientes con más de un pedido, con su cantidad de pedidos y el total
-- que gastaron. HAVING filtra después de agrupar; WHERE no serviría
-- porque COUNT(*) todavía no existe cuando se evalúa el WHERE.
-- =====================================================================
SELECT
    id_cliente,
    COUNT(*)                             AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)      AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- =====================================================================
-- === CONSULTA 4: Meses por encima / por debajo del promedio ===
-- Primero calculo el total de cada mes (CTE totales_mensuales). Después
-- comparo cada mes contra el promedio de esos totales.
-- Agrego el caso 'Igual al promedio': con un solo mes cargado, ese mes
-- ES el promedio, y etiquetarlo 'Por debajo' sería un error.
-- =====================================================================
WITH totales_mensuales AS (
    SELECT
        YEAR(fecha_venta)                AS anio,
        MONTH(fecha_venta)               AS mes,
        SUM(cantidad * precio_unitario)  AS total_facturado
    FROM ventas
    GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
)
SELECT
    anio,
    mes,
    total_facturado,
    CAST((SELECT AVG(total_facturado) FROM totales_mensuales)
         AS DECIMAL(10,2))              AS promedio_mensual,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM totales_mensuales)
            THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM totales_mensuales)
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END                                  AS comparacion_vs_promedio
FROM totales_mensuales
ORDER BY anio, mes;
GO


-- =====================================================================
-- === HALLAZGOS ===
--
-- 1. La facturación depende de un solo producto. El producto 1 (Laptop
--    Pro 15) generó $3.600 de un total de $6.444: el 55,87%. Con el
--    producto 3 (Monitor 4K 27) llegan a $4.950, el 76,8%, y los dos son
--    de la categoría Computación. En cambio el producto 2 (Mouse
--    Inalámbrico) es el que más unidades vendió (13) pero aporta solo
--    $364, el 5,65%: vender muchas unidades no es lo mismo que facturar.
--
-- 2. Los 5 clientes compraron exactamente 2 veces, así que todos salen
--    como recurrentes y la consulta 3 no los distingue. Lo que sí los
--    separa es el gasto: el cliente 1 gastó $2.640 (41% del total) y
--    junto con el cliente 5 ($2.100) explican el 73,6%. Los otros tres
--    gastaron entre $510 y $674 cada uno. Hay dependencia de pocos
--    clientes, que es la pregunta 4 del brief de M1.
--
-- 3. Todas las ventas son de marzo de 2024 ($6.444 en 10 pedidos, ticket
--    promedio de $644,40). Con un solo mes no se puede ver estacionalidad
--    ni comparar contra el año anterior: por eso la consulta 4 da
--    'Igual al promedio'. Además, en las 10 ventas el precio_unitario
--    coincide con el precio de lista del producto, o sea que no hubo
--    descuentos. Para la pregunta central de RetailPro (vende lo mismo
--    pero gana menos) faltan dos cosas en la base: más meses de historia
--    y el costo de cada producto, sin el cual no se puede calcular el
--    margen.
-- =====================================================================
