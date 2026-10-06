let
    Origen = Excel.Workbook(File.Contents(RutaExcel), null, true),
    HojaVentas = Origen{[Item = "ventas", Kind = "Sheet"]}[Data],
    EncabezadosPromovidos = Table.PromoteHeaders(HojaVentas, [PromoteAllScalars = true]),

    // fecha_venta como Fecha (no Fecha/Hora): Excel la trae con hora
    // 00:00, y con hora no se relaciona con la tabla calendario de M8.
    // Importes en Número decimal: descuento es un porcentaje (0,05 = 5%)
    // y total_venta tiene centavos (427,50), así que como entero se
    // redondearían.
    TiposAsignados = Table.TransformColumnTypes(EncabezadosPromovidos, {
        {"id_venta", Int64.Type},
        {"fecha_venta", type date},
        {"id_cliente", Int64.Type},
        {"id_producto", Int64.Type},
        {"cantidad", Int64.Type},
        {"precio_unitario", type number},
        {"descuento", type number},
        {"total_venta", type number},
        {"canal", type text}
    }),

    // Merge con Dim_Productos (ya deduplicada y con los nulos resueltos)
    // para traer el nombre y la categoría de cada producto. Externa
    // izquierda: si una venta tuviera un id_producto que no existe en el
    // catálogo, la venta se conserva con nombre vacío en vez de perderse.
    // Las 50 filas tienen que seguir siendo 50.
    ProductosCombinados = Table.NestedJoin(TiposAsignados, {"id_producto"}, Dim_Productos, {"id_producto"}, "Dim_Productos", JoinKind.LeftOuter),
    ProductosExpandidos = Table.ExpandTableColumn(ProductosCombinados, "Dim_Productos", {"nombre_producto", "categoria"}, {"nombre_producto", "categoria"}),

    OrdenadoPorIdVenta = Table.Sort(ProductosExpandidos, {{"id_venta", Order.Ascending}})
in
    OrdenadoPorIdVenta
