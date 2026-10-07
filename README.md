# 📊 RetailPro — Análisis de Ventas y Rentabilidad

Proyecto final del curso de **Data Analytics de Coderhouse**, desarrollado sobre el caso ficticio **RetailPro**, una distribuidora de tecnología.

**Alumno:** Hendris Bellorín

El objetivo del proyecto es analizar el desempeño comercial de la empresa y responder una pregunta central:

> **¿Por qué RetailPro vende lo mismo, pero gana menos?**

El análisis busca identificar posibles causas relacionadas con **descuentos**, **mix de productos** y **costos**. Se usa SQL Server para modelar y consultar los datos, Power Query para el proceso ETL y Power BI/DAX para el análisis y la visualización.

## 🎯 Objetivo del proyecto

La dirección de RetailPro plantea una hipótesis: el volumen de ventas se mantiene, pero la rentabilidad disminuye. El proyecto construye un flujo de análisis para comprobarla o descartarla:

* Analizar la evolución mensual de las ventas.
* Identificar los productos que más facturan y su peso sobre el total.
* Detectar clientes recurrentes y la concentración de la facturación.
* Comparar el desempeño de cada mes contra el promedio.
* Analizar las relaciones entre clientes, productos, categorías y regiones.
* Preparar un modelo de datos para Power BI y crear métricas con DAX.

## ⚠️ Limitaciones de los datos

Antes de leer cualquier resultado conviene tener en cuenta lo siguiente:

* **La base SQL (`Ventas_Tech_DB`) es un caso de práctica.** Tiene 10 ventas, todas de marzo de 2024, sin descuentos y sin costo de producto. Sirve para practicar las consultas, pero con ella no se puede medir el margen ni comparar períodos.
* **El modelo de Power BI (módulos 6 y 8) usa otra fuente:** el Excel `Pipeline_ETL_Dataset.xlsx` que provee el curso, con ventas de 2023 y 2024. Ese archivo no está en el repositorio.
* Para responder la pregunta central hacen falta datos que todavía no están en la base SQL: costo por venta, precio de lista y descuento.

## 🗄️ Base de datos

Base `Ventas_Tech_DB` en SQL Server, con 5 tablas:

* **Dimensiones:** `categorias`, `regiones`, `clientes`, `productos`
* **Hechos:** `ventas`

```
categorias (1) ──── (N) productos (1) ──── (N) ventas (N) ──── (1) clientes (N) ──── (1) regiones
```

La región cuelga del cliente, no de la venta.

## 🛠️ Herramientas utilizadas

* **SQL Server 2022** y **SQL Server Management Studio (SSMS)**: creación y consulta de la base.
* **Power Query (M)**: proceso ETL.
* **Power BI Desktop** y **DAX**: modelo, medidas y visualización. Power BI Desktop funciona solo en Windows.
* **Git** y **GitHub**: control de versiones y documentación.
* **ChatGPT (versión gratuita)**: revisión de la consulta base, borrador de hallazgos y de este README (módulo 9). Todo lo que generó fue revisado y validado contra los datos antes de usarlo.

## 📁 Estructura del repositorio

```
/
├── modulo-3/ventas_tech_db.sql          Crea la base, las tablas y carga los datos
├── modulo-4/m4_consultas_negocio.sql    4 consultas de negocio y 3 hallazgos
├── modulo-5/m5_consultas_joins.sql      Vista base (INNER JOIN), LEFT JOIN y UNION ALL
├── modulo-6/power-query/                Código M: Dim_Clientes.pq, Dim_Productos.pq,
│                                        Dim_Categorias.pq, Fact_Ventas.pq, RutaExcel.pq
├── modulo-7/                            Boceto del dashboard: Boceto_Dashboard_RetailPro.png / .pdf
├── modulo-8/dax/Modelo_M8.dax           Tabla calendario y medidas DAX
├── modulo-9/vw_ventas_base.sql          Vista base revisada con IA (LEFT JOIN + control)
└── GUIA_WINDOWS_M6_M8.md                Cómo armar los .pbix de M6 y M8 en Power BI Desktop
```

## 📌 Descripción de los módulos

### Módulo 3 — Creación de la base de datos

`modulo-3/ventas_tech_db.sql` crea y carga `Ventas_Tech_DB` en cuatro secciones: **DROP**, **CREATE**, **INSERT** y **VALIDACIÓN**. Es repetible: se puede correr varias veces y siempre deja la base en el mismo estado. Carga 32 registros, y las consultas de validación devuelven 4, 5, 6, 7 y 10 filas.

### Módulo 4 — Consultas de negocio

`modulo-4/m4_consultas_negocio.sql`: resumen mensual, top 5 de productos por facturación, clientes recurrentes y comparación de cada mes contra el promedio. Al final del archivo están los 3 hallazgos.

### Módulo 5 — JOINs

`modulo-5/m5_consultas_joins.sql`: vista base con INNER JOIN, clientes y productos sin ventas (LEFT JOIN + `IS NULL`) y un consolidado por período con UNION ALL.

### Módulo 6 — ETL con Power Query

`modulo-6/power-query/`: código M de las tablas `Dim_Clientes`, `Dim_Productos`, `Dim_Categorias` y `Fact_Ventas`, más el parámetro `RutaExcel`, que indica dónde está el Excel de origen.

### Módulo 7 — Diseño del dashboard

`modulo-7/`: boceto de la página 1 del dashboard. Tiene 4 KPIs (ventas, margen bruto %, descuento promedio % y ticket promedio), ventas contra margen por mes, ventas y margen % por categoría o país, y una tabla de detalle de transacciones.

### Módulo 8 — DAX

`modulo-8/dax/Modelo_M8.dax`: tabla calendario `Dim_Fechas` y 5 medidas: Total Ventas, Ventas Online, Ventas YTD, Ventas LY y % Crecimiento Anual.

### Módulo 9 — IA en el flujo del proyecto

`modulo-9/vw_ventas_base.sql`: la vista base de M5 revisada con IA. Pasa a LEFT JOIN para no perder ventas con claves nulas, no tiene ORDER BY y muestra 'Sin dato' en lugar de NULL. Incluye una consulta de control que compara filas y total contra la tabla `ventas`.

## ▶️ Cómo ejecutar el proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/hendrisbellorin/coderhouse-data-analytics.git
cd coderhouse-data-analytics
```

### 2. Scripts SQL (en este orden)

Abrir cada archivo en SSMS y ejecutarlo completo (F5):

1. `modulo-3/ventas_tech_db.sql`: crea la base `Ventas_Tech_DB` y la deja seleccionada.
2. `modulo-4/m4_consultas_negocio.sql`
3. `modulo-5/m5_consultas_joins.sql`
4. `modulo-9/vw_ventas_base.sql`: crea la vista `dbo.vw_ventas_base`. La consulta de control debe devolver 10 filas y $6.444 tanto en la tabla como en la vista.

Si se modificaron datos, conviene volver a correr el paso 1 antes de los demás: los resultados esperados que figuran en los comentarios de cada archivo suponen la carga original.

### 3. Power BI (requiere Windows)

1. Conseguir el Excel `Pipeline_ETL_Dataset.xlsx` del curso. No está en el repositorio.
2. En Power BI Desktop, crear el parámetro `RutaExcel` con la ruta de ese archivo y pegar las consultas de `modulo-6/power-query/`.
3. Crear la tabla calendario y las medidas de `modulo-8/dax/Modelo_M8.dax`.

El paso a paso está en [`GUIA_WINDOWS_M6_M8.md`](GUIA_WINDOWS_M6_M8.md).

## 📈 Flujo del proyecto

```
SQL Server (M3–M5, M9)                       Power BI (M6–M8)
──────────────────────                       ────────────────
ventas_tech_db.sql                           Pipeline_ETL_Dataset.xlsx
  → consultas de negocio (M4)                  → Power Query (M6)
  → JOINs / vista base (M5, M9)                → modelo + DAX (M8)
                                               → dashboard (boceto M7)
```

Hoy son dos caminos con datos distintos: Power BI no lee la base SQL. Unirlos es el paso pendiente para el proyecto final.

## 👤 Autor

**Hendris Bellorín** — Proyecto final, Data Analytics | Coderhouse
