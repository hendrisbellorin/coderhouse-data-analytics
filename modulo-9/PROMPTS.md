# Pre-entrega 9 — Prompts para pegar en la IA

Usá **una sola herramienta gratuita** para las tres tareas (recomendado: Claude.ai o ChatGPT). Abrí una **conversación nueva por tarea**, así la respuesta de una no contamina a la otra.

Para cada tarea: copiá el bloque entero, pegalo tal cual y guardá la respuesta **completa y sin editar** en `respuestas/tareaN.md`. Anotá también la herramienta y la fecha. La consigna pide documentar el prompt exacto y la respuesta, así que no se corrige nada antes de guardarla.

---

## Tarea 1 — Optimización SQL

````text
Sos un analista de datos senior que revisa código SQL. Trabajo en SQL Server 2022.

Esta es la consulta base de mi proyecto: une 4 tablas (más una de regiones) y es la vista que después consume Power BI. Revisala y decime:
1. Si tiene errores o riesgos de resultados incorrectos.
2. Qué mejorarías en rendimiento, legibilidad o mantenimiento.
3. La versión mejorada completa.

Explicá el porqué de cada cambio.

Contexto del esquema (claves y nulabilidad):
- ventas(id_venta PK, id_cliente INT NULL FK→clientes, id_producto INT NULL FK→productos, cantidad INT NOT NULL, precio_unitario DECIMAL(10,2) NOT NULL, fecha_venta DATE NOT NULL)
- clientes(id_cliente PK, nombre, email NULL, ciudad NULL, fecha_registro, id_region INT NOT NULL FK→regiones)
- productos(id_producto PK, nombre_producto, id_categoria INT NULL FK→categorias, precio, stock, activo)
- categorias(id_categoria PK, nombre_categoria)
- regiones(id_region PK, nombre_region)
- No hay índices además de las claves primarias. Hoy hay 10 ventas; el proyecto es un caso de estudio.

```sql
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
```
````

---

## Tarea 2 — Generación de insights

````text
Sos analista comercial de RetailPro, una distribuidora de tecnología. La dirección pregunta: "¿por qué vendemos lo mismo pero ganamos menos?".

Abajo están los resultados de 4 consultas SQL sobre la tabla de ventas. Identificá los 3 hallazgos más importantes para el equipo comercial y, para cada uno, proponé una acción concreta. Usá solo los números de abajo; si algo no se puede concluir con estos datos, decilo.

Referencia de IDs: producto 1 = Laptop Pro 15 (Computación), 2 = Mouse Inalámbrico (Accesorios), 3 = Monitor 4K 27 (Computación), 4 = Auriculares BT Pro (Audio), 5 = SSD Externo 1TB (Almacenamiento), 6 = Teclado Mecánico (Accesorios). Cliente 1 = María López (Centro), 2 = Carlos Ruiz (Centro), 3 = Ana Gómez (Litoral), 4 = Pedro Sanz (Cuyo), 5 = Laura Torres (Norte).

Consulta 1 — Resumen mensual
anio | mes | total_facturado | cantidad_pedidos | ticket_promedio
2024 | 3   | 6444.00         | 10               | 644.40

Consulta 2 — Top 5 productos por facturación
id_producto | unidades_vendidas | total_facturado | porcentaje_del_total
1           | 3                 | 3600.00         | 55.87
3           | 3                 | 1350.00         | 20.95
5           | 3                 | 390.00          | 6.05
6           | 4                 | 380.00          | 5.90
2           | 13                | 364.00          | 5.65

Consulta 3 — Clientes con más de un pedido
id_cliente | cantidad_pedidos | total_gastado
1          | 2                | 2640.00
5          | 2                | 2100.00
3          | 2                | 674.00
2          | 2                | 520.00
4          | 2                | 510.00

Consulta 4 — Mes frente al promedio mensual
anio | mes | total_facturado | promedio_mensual | comparacion_vs_promedio
2024 | 3   | 6444.00         | 6444.00          | Igual al promedio
````

---

## Tarea 3 — README del repositorio

````text
Generá el README.md de mi repositorio de GitHub. Está en español y es el proyecto final de un curso de Data Analytics (Coderhouse).

Datos del proyecto:
- Caso: RetailPro, distribuidora de tecnología. Pregunta central: "¿por qué vende lo mismo pero gana menos?" (descuentos, mix de productos o costos).
- Base de datos: Ventas_Tech_DB en SQL Server, 5 tablas: categorias, regiones, clientes, productos (dimensiones) y ventas (hechos). Relaciones: categorias 1─N productos 1─N ventas N─1 clientes N─1 regiones.
- Estructura del repo, una carpeta por módulo:
  - modulo-3/ventas_tech_db.sql: crea la base y las tablas y carga los datos (secciones DROP, CREATE, INSERT, VALIDACIÓN). Es repetible.
  - modulo-4/m4_consultas_negocio.sql: 4 consultas de negocio (resumen mensual, top 5 productos, clientes recurrentes, mes vs promedio) y 3 hallazgos.
  - modulo-5/m5_consultas_joins.sql: vista base con INNER JOIN para Power BI, clientes y productos sin ventas (LEFT JOIN), consolidado con UNION ALL.
  - modulo-6/power-query/: código M del pipeline ETL (Dim_Clientes, Dim_Productos, Dim_Categorias, Fact_Ventas, parámetro RutaExcel).
  - modulo-7/: boceto del dashboard (PNG y PDF).
  - modulo-8/dax/Modelo_M8.dax: tabla calendario y 5 medidas DAX.
- Herramientas: SQL Server 2022, SQL Server Management Studio, Power Query (M), Power BI / DAX, Git y GitHub.

Incluí: descripción del proyecto, herramientas, estructura del repositorio y cómo ejecutar los scripts SQL paso a paso.
````
