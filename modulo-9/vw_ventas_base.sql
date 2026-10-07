-- Motor utilizado: SQL Server (SSMS)
-- =====================================================================
-- Proyecto final — Data Analytics (Coderhouse)
-- Pre-entrega M9, Tarea 1: vista base revisada con IA
-- Base: Ventas_Tech_DB (correr antes modulo-3/ventas_tech_db.sql)
-- Alumno: Hendris Bellorín
--
-- Parte de la consulta 1 de M5. Cambios tras la revisión con ChatGPT:
--   * LEFT JOIN en lugar de INNER JOIN (sugerencia de la IA, aceptada):
--     id_cliente, id_producto e id_categoria admiten NULL, y con INNER
--     JOIN una venta incompleta desaparecía sin aviso. Probado: con una
--     venta sin cliente y otra con producto sin categoría, la versión
--     INNER devolvía 10 de 12 ventas y $6.444 de $7.744.
--   * Sin ORDER BY (aceptada): SQL Server rechaza el ORDER BY en una
--     vista (Msg 1033). El orden lo pone Power BI.
--   * Esquema dbo. explícito (aceptada).
--   * 'Sin dato' en lugar de NULL (cambio mío, no de la IA): es el mismo
--     criterio de nulos que usé en el ETL de M6, y en Power BI un NULL
--     sale como "(En blanco)" y se confunde con un filtro vacío.
--   * Índices: no se agregan (la IA tampoco los recomienda con 10 filas).
-- =====================================================================

USE Ventas_Tech_DB;
GO

CREATE OR ALTER VIEW dbo.vw_ventas_base AS
SELECT
    v.id_venta,
    v.fecha_venta,
    v.id_cliente,
    COALESCE(c.nombre, 'Sin dato')             AS nombre_cliente,
    COALESCE(c.ciudad, 'Sin dato')             AS ciudad,
    COALESCE(r.nombre_region, 'Sin dato')      AS nombre_region,
    v.id_producto,
    COALESCE(p.nombre_producto, 'Sin dato')    AS nombre_producto,
    COALESCE(cat.nombre_categoria, 'Sin dato') AS nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario             AS total_venta
FROM dbo.ventas AS v
LEFT JOIN dbo.clientes   AS c   ON c.id_cliente     = v.id_cliente
LEFT JOIN dbo.regiones   AS r   ON r.id_region      = c.id_region
LEFT JOIN dbo.productos  AS p   ON p.id_producto    = v.id_producto
LEFT JOIN dbo.categorias AS cat ON cat.id_categoria = p.id_categoria;
GO

-- Control (no lo propuso la IA): la vista tiene que tener las mismas
-- filas y el mismo total que la tabla ventas. Si difieren, se perdió
-- o se duplicó alguna venta en los JOIN.
SELECT 'tabla ventas' AS fuente, COUNT(*) AS filas, SUM(cantidad * precio_unitario) AS total
FROM dbo.ventas
UNION ALL
SELECT 'vw_ventas_base', COUNT(*), SUM(total_venta)
FROM dbo.vw_ventas_base;
-- Resultado esperado: 10 filas y $6.444 en las dos.
GO
