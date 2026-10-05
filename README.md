# Data Analytics — Coderhouse

Proyecto final del curso de Data Analytics de Coderhouse.

**Alumno:** Hendris Bellorín

## Entregas

| Módulo | Entrega | Archivo |
| --- | --- | --- |
| 3 | Checkpoint: Script SQL de Ingeniería de Datos | [`modulo-3/ventas_tech_db.sql`](modulo-3/ventas_tech_db.sql) |

## Módulo 3 — `Ventas_Tech_DB`

Script de SQL Server que crea la base `Ventas_Tech_DB` del caso TechStore:

```
categorias (1) ──── (N) productos (1) ──── (N) ventas (N) ──── (1) clientes
```

- Tres tablas de dimensión (`categorias`, `clientes`, `productos`) y una de hechos (`ventas`).
- El script tiene cuatro secciones: **DROP**, **CREATE**, **INSERT** y **VALIDACIÓN**.
- Es repetible: crea la base solo si no existe y borra las tablas en orden inverso a las dependencias.
- Carga 25 registros. Las consultas de validación devuelven 4, 5, 6 y 10 filas.

### Cómo correrlo

1. Abrir `modulo-3/ventas_tech_db.sql` en SQL Server Management Studio (SSMS).
2. Ejecutar el script completo (F5). Crea la base, la selecciona y carga los datos.
