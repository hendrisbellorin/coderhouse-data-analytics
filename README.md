# Data Analytics — Coderhouse

Proyecto final del curso de Data Analytics de Coderhouse.

**Alumno:** Hendris Bellorín

## Entregas

| Módulo | Entrega | Archivo |
| --- | --- | --- |
| 3 | Checkpoint: Script SQL de Ingeniería de Datos | [`modulo-3/ventas_tech_db.sql`](modulo-3/ventas_tech_db.sql) |
| 4 | Pre-entrega: Consultas SQL de negocio | [`modulo-4/m4_consultas_negocio.sql`](modulo-4/m4_consultas_negocio.sql) |
| 5 | Pre-entrega: Consultas con JOINs para el proyecto | [`modulo-5/m5_consultas_joins.sql`](modulo-5/m5_consultas_joins.sql) |
| 6 | Checkpoint: Pipeline ETL con Power Query y M | [`modulo-6/power-query/`](modulo-6/power-query/) |
| 8 | Checkpoint 2: Modelo de datos y medidas DAX | [`modulo-8/dax/Modelo_M8.dax`](modulo-8/dax/Modelo_M8.dax) |

## Módulo 3 — `Ventas_Tech_DB`

Script de SQL Server que crea la base `Ventas_Tech_DB` del caso TechStore:

```
categorias (1) ──── (N) productos (1) ──── (N) ventas (N) ──── (1) clientes (N) ──── (1) regiones
```

- Cuatro tablas de dimensión (`categorias`, `regiones`, `clientes`, `productos`) y una de hechos (`ventas`).
- En M5 se sumó la tabla `regiones`, un cliente sin compras y un producto sin ventas.
- El script tiene cuatro secciones: **DROP**, **CREATE**, **INSERT** y **VALIDACIÓN**.
- Es repetible: crea la base solo si no existe y borra las tablas en orden inverso a las dependencias.
- Carga 32 registros. Las consultas de validación devuelven 4, 5, 6, 7 y 10 filas.

### Cómo correrlo

1. Abrir `modulo-3/ventas_tech_db.sql` en SQL Server Management Studio (SSMS).
2. Ejecutar el script completo (F5). Crea la base, la selecciona y carga los datos.

## Módulo 4 — Consultas de negocio

Cuatro consultas sobre la tabla `ventas` de `Ventas_Tech_DB`, más tres hallazgos al final del archivo:

1. Resumen ejecutivo mensual: total facturado, pedidos y ticket promedio.
2. Top 5 de productos por facturación, con unidades y % del total.
3. Clientes recurrentes (más de un pedido) y su gasto total.
4. Facturación de cada mes frente al promedio mensual.

Se corre en SSMS después del script del módulo 3.

## Módulo 5 — Consultas con JOINs

1. Vista base para Power BI (INNER JOIN): cada venta con cliente, ciudad, región, producto y categoría.
2. Clientes sin compras (LEFT JOIN + `IS NULL`).
3. Productos sin ventas (LEFT JOIN + `IS NULL`).
4. Consolidado por período con UNION ALL y una columna creada como texto fijo.

Se corre en SSMS después del script del módulo 3.

## Módulos 6 y 8 — Power BI

- `modulo-6/power-query/`: código M de las consultas `Dim_Clientes`, `Dim_Productos`, `Dim_Categorias` y `Fact_Ventas`, y el parámetro `RutaExcel`.
- `modulo-8/dax/Modelo_M8.dax`: tabla calendario y las cinco medidas core.
- [`GUIA_WINDOWS_M6_M8.md`](GUIA_WINDOWS_M6_M8.md): cómo armar los dos `.pbix` en una sola sesión de Power BI Desktop.
