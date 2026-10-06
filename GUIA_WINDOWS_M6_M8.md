# M6 + M8 en una sola sesión de Power BI (Windows) — ~60 min

Todo el código ya está escrito. En Windows solo hay que pegarlo, sacar las
capturas y guardar dos `.pbix`. Llevá en un pendrive (o bajalo de GitHub):

- `Pipeline_ETL_Dataset.xlsx` (dataset del curso)
- la carpeta `modulo-6/power-query/` (código M)
- `modulo-8/dax/Modelo_M8.dax` (código DAX)

Las capturas se sacan con **Win + Shift + S** y se pegan en un documento
nuevo o se guardan; después se pegan en los `.docx` de entrega desde la Mac.

---

## Parte 1 — M6: pipeline ETL (25 min)

1. Copiá el Excel a **`C:\TechStore\Pipeline_ETL_Dataset.xlsx`** (esa ruta
   exacta: es la que usan las consultas).
2. Instalá Power BI Desktop si no está (Microsoft Store, gratis) y abrilo.
3. **Inicio → Obtener datos → Excel** → el archivo → tildá `clientes`,
   `productos`, `ventas`, `categorias` → **Transformar datos** (no "Cargar").
4. **Vista** → tildá Calidad de columnas, Distribución de columnas y Perfil de
   columna. Abajo a la izquierda, cambiá "Generación de perfiles de columna
   basada en las primeras 1000 filas" a **todo el conjunto de datos**.
5. **Parámetro:** Inicio → Administrar parámetros → Nuevo → Nombre `RutaExcel`,
   Tipo Texto, Valor actual `C:\TechStore\Pipeline_ETL_Dataset.xlsx` → Aceptar.
6. **Las cuatro consultas**, en este orden. Para cada una: doble clic en el
   nombre → renombrar → **Inicio → Editor avanzado** → borrar todo → pegar el
   `.pq` → Listo.

   | Original | Renombrar a | Pegar |
   | --- | --- | --- |
   | clientes | `Dim_Clientes` | `Dim_Clientes.pq` |
   | categorias | `Dim_Categorias` | `Dim_Categorias.pq` |
   | productos | `Dim_Productos` | `Dim_Productos.pq` |
   | ventas | `Fact_Ventas` | `Fact_Ventas.pq` |

   Si aparece un cartel de **niveles de privacidad**, elegí "Organizacional"
   para el archivo. Si alguna consulta muestra un error, sacale una captura.

7. 📸 **Capturas M6:** panel de Consultas (izquierda) · Pasos aplicados de
   `Fact_Ventas` · Pasos aplicados de `Dim_Productos`.
8. **Inicio → Cerrar y aplicar.** Esperá a que termine sin errores.
9. Vista de **tabla** (ícono de grilla, a la izquierda) → 📸 una captura por
   tabla, con el conteo abajo a la izquierda: Dim_Clientes **11**,
   Dim_Productos **12**, Fact_Ventas **50**, Dim_Categorias **4**.
10. **Archivo → Guardar como → `Pipeline_ETL_Bellorin_Hendris.pbix`.**

## Parte 2 — M8: modelo y medidas (30 min)

Seguí en el mismo archivo.

1. **Archivo → Opciones → Archivo actual → Carga de datos** → destildá
   **Fecha y hora automáticas** (evita tablas de fecha ocultas que compiten
   con Dim_Fechas).
2. **Calendario:** Inicio → **Nueva tabla** → pegá `Dim_Fechas = CALENDAR(...)`
   del archivo `.dax`. Con Dim_Fechas seleccionada, **Nueva columna** cinco
   veces: Año, Mes Número, Mes Nombre, Trimestre, Semana.
3. Seleccioná la columna **Mes Nombre** → Herramientas de columnas →
   **Ordenar por columna → Mes Número**.
4. Clic derecho en **Dim_Fechas** (panel Datos) → **Marcar como tabla de
   fechas** → columna `Date` → Aceptar.
5. **Relaciones:** vista de **Modelo** (tercer ícono a la izquierda). Arrastrá:

   | Desde (lado 1) | Hasta (lado N) |
   | --- | --- |
   | Dim_Clientes[id_cliente] | Fact_Ventas[id_cliente] |
   | Dim_Productos[id_producto] | Fact_Ventas[id_producto] |
   | Dim_Categorias[id_categoria] | Dim_Productos[id_categoria] |
   | Dim_Fechas[Date] | Fact_Ventas[fecha_venta] |

   Doble clic en cada línea y revisá: **Uno a varios (1:*)**, dirección
   **Única**, **Activa** tildada. Power BI puede crear alguna sola al cargar:
   revisala igual.
6. **Tabla de medidas:** Inicio → **Especificar datos** → nombre `_Medidas` →
   Cargar. Clic derecho en la columna "Columna1" → Eliminar.
7. **Medidas:** clic derecho en `_Medidas` → **Nueva medida** → pegá cada una
   del `.dax` (desde el nombre hasta el final de la fórmula). Formatos:
   `Total Ventas`, `Ventas Online`, `Ventas YTD`, `Ventas LY` → Moneda;
   `% Crecimiento Anual` → Porcentaje.
   Cuando `_Medidas` ya tiene medidas y no columnas, toma el ícono de
   calculadora (a veces aparece recién al guardar y reabrir).
8. **Página de validación:** pestaña de página nueva → renombrala
   `Validación` → visual **Matriz**: Filas `Mes Nombre`, Columnas `Año`,
   Valores las 4 medidas (Total Ventas, Ventas YTD, Ventas LY, % Crecimiento).
   Compará con la tabla de valores esperados del documento de M8.
9. 📸 **Capturas M8:** vista de Modelo con las 4 relaciones y Dim_Fechas ·
   panel Datos con `_Medidas` desplegada (las 5 medidas) · la matriz de
   Validación.
10. **Archivo → Guardar como → `Bellorin_Hendris_Checkpoint2.pbix`.**

## Al terminar

Traé los dos `.pbix` y las capturas a la Mac. Yo subo los `.pbix` a GitHub y
vos pegás las capturas en los recuadros amarillos de:

- `modulo-6/entrega/Pipeline_ETL_Bellorin_Hendris.docx` → PDF
- `modulo-8/entrega/Bellorin_Hendris_Checkpoint2.docx` → PDF
