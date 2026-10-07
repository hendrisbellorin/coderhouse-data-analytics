<!-- Herramienta: ChatGPT (versión gratuita). Fecha: 07/10/2026. El texto es el de la respuesta sin cambios; al copiarlo se perdió el formato Markdown (títulos, negritas, bloques) y se restituyó tal como se ve en el visor README.md de ChatGPT. Capturas: capturas/tarea3_*.png -->

Claro. Te dejo un README pensado para que funcione como presentación profesional del proyecto en GitHub, con foco en el problema de negocio y en el recorrido SQL → ETL → Power BI → DAX.

README.md

# 📊 RetailPro — Análisis de Ventas y Rentabilidad

Proyecto final del curso de **Data Analytics de Coderhouse**, desarrollado sobre el caso ficticio **RetailPro**, una distribuidora de tecnología.

El objetivo del proyecto es analizar el desempeño comercial de la empresa y responder una pregunta central:

> **¿Por qué RetailPro vende lo mismo, pero gana menos?**

El análisis busca identificar posibles causas relacionadas con **descuentos**, **mix de productos** y **costos**, utilizando SQL Server para la extracción y transformación de datos, Power Query para el proceso ETL y Power BI/DAX para el análisis y visualización.

## 🎯 Objetivo del proyecto

El proyecto parte de una problemática de negocio: el volumen de ventas se mantiene, pero la rentabilidad disminuye.

Para investigar esta situación se construyó un flujo completo de análisis de datos que permite:

* Analizar la evolución mensual de las ventas.
* Identificar los productos con mayor volumen de ventas.
* Detectar clientes recurrentes.
* Comparar el desempeño de cada mes contra el promedio.
* Analizar las relaciones entre clientes, productos, categorías y regiones.
* Preparar un modelo de datos para Power BI.
* Crear métricas mediante DAX.
* Generar información que ayude a identificar posibles causas de la pérdida de rentabilidad.

## 🗄️ Base de datos

El proyecto utiliza una base de datos desarrollada en SQL Server:

`Ventas_Tech_DB`

El modelo está compuesto por 5 tablas:

### Dimensiones

* `categorias`
* `productos`
* `clientes`
* `regiones`

### Tabla de hechos

* `ventas`

### Relaciones

```
categorias  1 ─── N  productos  1 ─── N  ventas
                                      │
                                      N
                                      │
                                   clientes
                                      N
                                      │
                                      1
                                   regiones
```

La estructura permite analizar las ventas desde diferentes dimensiones, como producto, categoría, cliente y región.

## 🛠️ Herramientas utilizadas

* **SQL Server 2022** — creación, almacenamiento y consulta de la base de datos.
* **SQL Server Management Studio (SSMS)** — ejecución y administración de scripts SQL.
* **Power Query (M)** — proceso ETL y preparación de los datos.
* **Power BI** — modelado y visualización.
* **DAX** — creación de medidas y tabla calendario.
* **Git** — control de versiones.
* **GitHub** — almacenamiento y documentación del proyecto.

## 📁 Estructura del repositorio

```
/
├── modulo-3/
│   └── ventas_tech_db.sql
│
├── modulo-4/
│   └── m4_consultas_negocio.sql
│
├── modulo-5/
│   └── m5_consultas_joins.sql
│
├── modulo-6/
│   └── power-query/
│       ├── Dim_Clientes
│       ├── Dim_Productos
│       ├── Dim_Categorias
│       ├── Fact_Ventas
│       └── RutaExcel
│
├── modulo-7/
│   ├── boceto_dashboard.png
│   └── boceto_dashboard.pdf
│
└── modulo-8/
    └── dax/
        └── Modelo_M8.dax
```

## 📌 Descripción de los módulos

### Módulo 3 — Creación de la base de datos

**Archivo:** `modulo-3/ventas_tech_db.sql`

Script completo para crear y poblar la base de datos `Ventas_Tech_DB`.

El script está organizado en las siguientes secciones:

1. `DROP` — eliminación de objetos existentes.
2. `CREATE` — creación de la base y tablas.
3. `INSERT` — carga de datos.
4. `VALIDACIÓN` — comprobaciones posteriores a la carga.

El script fue diseñado para ser **repetible**, permitiendo reconstruir la base de datos desde cero.

### Módulo 4 — Consultas de negocio

**Archivo:** `modulo-4/m4_consultas_negocio.sql`

Incluye cuatro consultas orientadas a responder preguntas de negocio:

1. **Resumen mensual de ventas**
2. **Top 5 productos**
3. **Clientes recurrentes**
4. **Comparación mensual contra el promedio**

A partir de estas consultas se identifican **3 hallazgos principales** para orientar el análisis comercial.

### Módulo 5 — JOINs y preparación para Power BI

**Archivo:** `modulo-5/m5_consultas_joins.sql`

Este módulo trabaja con diferentes tipos de `JOIN` para ampliar el análisis.

Incluye:

* **Vista base:** combinación de las tablas mediante `INNER JOIN`, preparada para su posterior consumo en Power BI.
* **Clientes sin ventas:** utilización de `LEFT JOIN` para detectar clientes que no registran operaciones.
* **Productos sin ventas:** identificación de productos que no presentan ventas.
* **Consolidado:** combinación de información mediante `UNION ALL`.

### Módulo 6 — ETL con Power Query

**Carpeta:** `modulo-6/power-query/`

Contiene el código M utilizado para preparar los datos mediante Power Query.

Se incluyen procesos para:

* `Dim_Clientes`
* `Dim_Productos`
* `Dim_Categorias`
* `Fact_Ventas`
* Parámetro `RutaExcel`

El objetivo es separar las dimensiones y la tabla de hechos para construir un modelo de datos adecuado para el análisis en Power BI.

### Módulo 7 — Diseño del dashboard

**Carpeta:** `modulo-7/`

Contiene el boceto inicial del dashboard en:

* PNG
* PDF

El diseño sirve como guía para la construcción de la visualización final, definiendo la distribución de los principales indicadores y gráficos.

### Módulo 8 — DAX y modelo analítico

**Archivo:** `modulo-8/dax/Modelo_M8.dax`

Incluye:

* Creación de una **tabla calendario**.
* **5 medidas DAX** para el análisis de los principales indicadores del negocio.

Estas medidas permiten complementar el modelo construido en Power BI y facilitar el análisis dinámico de las ventas.

## ▶️ Cómo ejecutar el proyecto

### 1. Clonar el repositorio

Desde una terminal:

```bash
git clone URL_DEL_REPOSITORIO
```

Luego ingresar a la carpeta del proyecto:

```bash
cd NOMBRE_DEL_REPOSITORIO
```

### 2. Crear la base de datos

Abrir **SQL Server Management Studio (SSMS)** y ejecutar:

```
modulo-3/ventas_tech_db.sql
```

El script se encarga de:

* Crear la base de datos.
* Crear las tablas.
* Definir las relaciones.
* Insertar los datos.
* Ejecutar validaciones.

Al finalizar, debería estar disponible la base:

```
Ventas_Tech_DB
```

### 3. Ejecutar las consultas de negocio

Con la base creada, abrir:

```
modulo-4/m4_consultas_negocio.sql
```

Ejecutar las consultas para obtener:

* Resumen mensual.
* Top 5 productos.
* Clientes recurrentes.
* Comparación mensual contra el promedio.

En este módulo también se encuentran los principales hallazgos obtenidos a partir del análisis.

### 4. Ejecutar las consultas con JOINs

Abrir:

```
modulo-5/m5_consultas_joins.sql
```

Ejecutar las consultas para:

* Construir la vista base.
* Analizar clientes sin ventas.
* Analizar productos sin ventas.
* Generar el consolidado mediante `UNION ALL`.

La vista base puede utilizarse posteriormente como fuente para Power BI.

### 5. Preparar los datos en Power Query

Utilizar los archivos disponibles en:

```
modulo-6/power-query/
```

Configurar el parámetro:

```
RutaExcel
```

y revisar las consultas:

```
Dim_Clientes
Dim_Productos
Dim_Categorias
Fact_Ventas
```

El objetivo es reproducir el pipeline ETL y preparar el modelo para Power BI.

### 6. Revisar el diseño del dashboard

Consultar los archivos de:

```
modulo-7/
```

El PNG y el PDF contienen el boceto utilizado como referencia para el diseño del dashboard.

### 7. Aplicar las medidas DAX

Abrir:

```
modulo-8/dax/Modelo_M8.dax
```

Crear en Power BI:

* La tabla calendario.
* Las cinco medidas DAX incluidas en el archivo.

Finalmente, relacionar las tablas y construir las visualizaciones a partir del modelo preparado.

## 🔎 Pregunta de negocio

Todo el proyecto está orientado a investigar una problemática comercial concreta:

> **¿Por qué RetailPro vende lo mismo pero gana menos?**

Para responderla, el análisis considera principalmente tres posibles factores:

### 💸 Descuentos

Determinar si una mayor utilización de descuentos puede estar reduciendo el margen obtenido sobre las ventas.

### 📦 Mix de productos

Analizar si cambió la composición de las ventas hacia productos o categorías con menor rentabilidad.

### 🚚 Costos

Evaluar si determinados productos, categorías, regiones o períodos presentan comportamientos que puedan estar asociados a mayores costos.

> **Importante:** las consultas incluidas en el proyecto permiten analizar el comportamiento de las ventas, pero una conclusión definitiva sobre rentabilidad requiere contar con información suficiente sobre costos y márgenes.

## 📈 Flujo del proyecto

```
SQL Server
    │
    ├── Creación de la base
    ├── Carga de datos
    └── Consultas de negocio
            │
            ▼
       JOINs / Vista base
            │
            ▼
       Power Query (ETL)
            │
            ▼
        Modelo Power BI
            │
            ├── Tabla calendario
            ├── Medidas DAX
            └── Visualizaciones
            │
            ▼
       Análisis comercial
```

## 📚 Contexto académico

Este repositorio corresponde al proyecto final del curso de **Data Analytics de Coderhouse** y reúne los diferentes módulos trabajados durante el desarrollo del proyecto.

El objetivo fue integrar distintas herramientas y conceptos de análisis de datos en un caso de negocio, desde la creación y consulta de una base de datos hasta la preparación, modelado y visualización de la información.

## 👤 Autor

**Hendris Bellorin**

Proyecto final — Data Analytics | Coderhouse

---

Si querés, también puedo hacerte una versión más "pro" para GitHub, con badges, tabla de contenidos, arquitectura del modelo y una sección de **Key Insights** para que quede más parecido a un portfolio de Data Analyst.
