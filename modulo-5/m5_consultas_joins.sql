-- Motor utilizado: SQL Server (SSMS)
-- =====================================================================
-- Proyecto final — Data Analytics (Coderhouse)
-- Pre-entrega M5: Consultas con JOINs para el proyecto
-- Base: Ventas_Tech_DB (creada en M3, ver modulo-3/ventas_tech_db.sql)
-- Alumno: Hendris Bellorín
--
-- Para esta entrega amplié el script de M3 con la tabla regiones, un
-- cliente sin compras (id 6) y un producto sin ventas (id 7). Antes de
-- correr este archivo hay que volver a correr el script de M3.
--
-- Modelo:
--   categorias (1) ──── (N) productos (1) ──── (N) ventas (N) ──── (1) clientes (N) ──── (1) regiones
-- =====================================================================

USE Ventas_Tech_DB;
GO


-- =====================================================================
-- === CONSULTA 1: Vista base del proyecto (INNER JOIN) ===
-- Una fila por venta con todo lo que necesita Power BI: quién compró,
-- dónde, qué producto, de qué categoría, cuánto y a qué precio.
--   * Para agrupar: nombre_region, nombre_categoria.
--   * Para filtrar: fecha_venta, ciudad, nombre_cliente.
-- INNER JOIN alcanza porque todas las FK de ventas tienen dato. Si una
-- venta no encontrara su cliente o su producto, se perdería de la vista.
-- =====================================================================
SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre                             AS nombre_cliente,
    c.ciudad,
    r.nombre_region,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario       AS total_venta
FROM ventas AS v
INNER JOIN clientes   AS c   ON c.id_cliente     = v.id_cliente
INNER JOIN regiones   AS r   ON r.id_region      = c.id_region
INNER JOIN productos  AS p   ON p.id_producto    = v.id_producto
INNER JOIN categorias AS cat ON cat.id_categoria = p.id_categoria
ORDER BY v.fecha_venta, v.id_venta;
-- Resultado esperado: 10 filas (una por venta), que suman $6.444.


-- =====================================================================
-- === CONSULTA 2: Clientes sin ventas (LEFT JOIN) ===
-- Parto de clientes para no perder a nadie. Los que no compraron quedan
-- con las columnas de ventas en NULL. Filtro por v.id_venta, que es la
-- PK de ventas: nunca es NULL en una venta real, así que NULL acá solo
-- puede significar "no hay venta".
-- =====================================================================
SELECT
    c.nombre,
    c.email,
    c.fecha_registro,
    c.ciudad
FROM clientes AS c
LEFT JOIN ventas AS v ON v.id_cliente = c.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro;
-- Resultado esperado: 1 fila, Jorge Díaz (Neuquén), registrado el
-- 2024-03-10. Es además el único cliente de la región Sur, así que
-- esa región todavía no tiene ventas.


-- =====================================================================
-- === CONSULTA 3: Productos sin ventas (LEFT JOIN) ===
-- Mismo criterio que la consulta 2, desde productos. La categoría va con
-- LEFT JOIN también: id_categoria admite NULL, y un producto sin
-- categoría igual tiene que aparecer si no se vendió.
-- =====================================================================
SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos AS p
LEFT JOIN categorias AS cat ON cat.id_categoria = p.id_categoria
LEFT JOIN ventas     AS v   ON v.id_producto    = p.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;
-- Resultado esperado: 1 fila, Webcam HD 1080p (Accesorios, $65,00),
-- con 25 unidades en stock sin movimiento.


-- =====================================================================
-- === CONSULTA 4: Consolidado por período (UNION ALL) ===
-- La columna periodo no existe en ninguna tabla: la creo como texto fijo
-- en cada SELECT. Todas las ventas son de marzo de 2024, así que separo
-- el mes en dos tramos: del 5 al 10 y del 11 al 15.
-- Los dos WHERE no se pisan y cubren todas las fechas (fecha_venta es
-- NOT NULL), así que cada venta entra una sola vez.
-- UNION ALL y no UNION: UNION descartaría dos ventas que coincidan en
-- fecha, total y período, y el total quedaría corto.
-- =====================================================================
SELECT
    periodo,
    COUNT(*)                             AS cantidad_ventas,
    SUM(total)                           AS total_periodo
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario       AS total,
        'Marzo 2024 - del 5 al 10'       AS periodo
    FROM ventas
    WHERE fecha_venta < '2024-03-11'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario       AS total,
        'Marzo 2024 - del 11 al 15'      AS periodo
    FROM ventas
    WHERE fecha_venta >= '2024-03-11'
) AS consolidado
GROUP BY periodo
ORDER BY MIN(fecha_venta);   -- por fecha: alfabéticamente 'del 11' sale antes que 'del 5'
-- Resultado esperado: 2 filas.
--   del 5 al 10:  5 ventas, $3.620
--   del 11 al 15: 5 ventas, $2.824
-- Las dos suman $6.444, el mismo total de M4: no se perdió ni se
-- duplicó ninguna venta.
GO
