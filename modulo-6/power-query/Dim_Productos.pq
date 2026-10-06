let
    Origen = Excel.Workbook(File.Contents(RutaExcel), null, true),
    HojaProductos = Origen{[Item = "productos", Kind = "Sheet"]}[Data],
    EncabezadosPromovidos = Table.PromoteHeaders(HojaProductos, [PromoteAllScalars = true]),

    TiposAsignados = Table.TransformColumnTypes(EncabezadosPromovidos, {
        {"id_producto", Int64.Type},
        {"nombre_producto", type text},
        {"categoria", type text},
        {"subcategoria", type text},
        {"precio", type number},
        {"costo", type number},
        {"stock", Int64.Type},
        {"activo", Int64.Type}
    }),

    // El Monitor 4K (id 103) está cargado dos veces. Si quedara así, el
    // Merge de Fact_Ventas multiplicaría sus 5 ventas: Fact_Ventas pasaría
    // de 50 a 55 filas y la facturación del monitor aparecería duplicada.
    DuplicadosQuitadosPorId = Table.Distinct(TiposAsignados, {"id_producto"}),

    // --- Precio nulo (SSD Externo 1TB, id 109) ---------------------------
    // Sin precio no hay ingreso ni margen, pero borrar el producto dejaría
    // 5 ventas huérfanas. El dato existe en otra tabla: en ventas, el
    // precio_unitario coincide con el precio de lista en todas las líneas
    // del catálogo, y las 5 ventas del SSD son a $130. Se toma el precio
    // de la venta más reciente de cada producto (el último precio real
    // cobrado). Se lee la hoja ventas del Excel y no la consulta
    // Fact_Ventas, porque Fact_Ventas depende de esta consulta y se
    // formaría una referencia circular.
    HojaVentas = Table.PromoteHeaders(Origen{[Item = "ventas", Kind = "Sheet"]}[Data], [PromoteAllScalars = true]),
    VentasTipadas = Table.TransformColumnTypes(HojaVentas, {
        {"id_producto", Int64.Type},
        {"fecha_venta", type date},
        {"precio_unitario", type number}
    }),
    // Table.Max devuelve la fila de la venta más reciente dentro de cada
    // grupo. Ordenar y tomar la primera fila no sirve: Power Query no
    // garantiza que Table.Group respete un orden previo.
    UltimoPrecioVendido = Table.Group(VentasTipadas, {"id_producto"}, {
        {"ultimo_precio_vendido", each Table.Max(_, "fecha_venta")[precio_unitario], type number}
    }),
    PrecioVendidoCombinado = Table.NestedJoin(DuplicadosQuitadosPorId, {"id_producto"}, UltimoPrecioVendido, {"id_producto"}, "UltimoPrecio", JoinKind.LeftOuter),
    PrecioVendidoExpandido = Table.ExpandTableColumn(PrecioVendidoCombinado, "UltimoPrecio", {"ultimo_precio_vendido"}, {"ultimo_precio_vendido"}),
    // Solo se completan los precios nulos; los que ya tienen valor no se
    // tocan. Un producto sin precio y sin ventas quedaría en null: no
    // afecta ningún ingreso, y es mejor verlo vacío que con un precio inventado.
    PrecioNuloCompletadoDesdeVentas = Table.ReplaceValue(
        PrecioVendidoExpandido,
        each [precio],
        each if [precio] = null then [ultimo_precio_vendido] else [precio],
        Replacer.ReplaceValue,
        {"precio"}
    ),
    ColumnaAuxiliarPrecioQuitada = Table.RemoveColumns(PrecioNuloCompletadoDesdeVentas, {"ultimo_precio_vendido"}),

    // --- Categoría nula (Laptop Gaming Pro, id 111) -----------------------
    // La subcategoría sí está: "Laptops". En el catálogo cada subcategoría
    // pertenece a una sola categoría (Laptops -> Computación), así que la
    // categoría se deduce de la subcategoría. "Sin Categoría" sacaría de
    // Computación $15.840, el 33% de toda la facturación, y el gráfico por
    // categoría quedaría distorsionado.
    // El mapa se arma con los mismos datos: cada subcategoría con la
    // categoría que tiene en las filas completas.
    MapaSubcategoriaCategoria = Table.Distinct(
        Table.SelectColumns(
            Table.SelectRows(ColumnaAuxiliarPrecioQuitada, each [categoria] <> null),
            {"subcategoria", "categoria"}
        ),
        {"subcategoria"}
    ),
    CategoriaDeducidaCombinada = Table.NestedJoin(ColumnaAuxiliarPrecioQuitada, {"subcategoria"}, MapaSubcategoriaCategoria, {"subcategoria"}, "Mapa", JoinKind.LeftOuter),
    CategoriaDeducidaExpandida = Table.ExpandTableColumn(CategoriaDeducidaCombinada, "Mapa", {"categoria"}, {"categoria_por_subcategoria"}),
    // Si la subcategoría tampoco permite deducirla, recién ahí "Sin Categoría":
    // el producto queda visible en los reportes en vez de desaparecer.
    CategoriaNulaCompletada = Table.ReplaceValue(
        CategoriaDeducidaExpandida,
        each [categoria],
        each if [categoria] <> null then [categoria]
             else if [categoria_por_subcategoria] <> null then [categoria_por_subcategoria]
             else "Sin Categoría",
        Replacer.ReplaceValue,
        {"categoria"}
    ),
    ColumnaAuxiliarCategoriaQuitada = Table.RemoveColumns(CategoriaNulaCompletada, {"categoria_por_subcategoria"}),

    // --- id_categoria para la relación con Dim_Categorias ------------------
    // productos trae la categoría como texto y no tiene id_categoria. Sin
    // esa clave, en el modelo no se puede crear la relación 1:N
    // Dim_Categorias -> Dim_Productos (M8). Se toma el ID desde
    // Dim_Categorias cruzando por nombre. Va después de completar la
    // categoría nula, para que la Laptop Gaming Pro también reciba su ID.
    IdCategoriaCombinado = Table.NestedJoin(ColumnaAuxiliarCategoriaQuitada, {"categoria"}, Dim_Categorias, {"nombre_categoria"}, "Categorias", JoinKind.LeftOuter),
    IdCategoriaExpandido = Table.ExpandTableColumn(IdCategoriaCombinado, "Categorias", {"id_categoria"}, {"id_categoria"}),

    // Los Merge no conservan el orden de las filas: se reordena por ID para
    // que la Vista de datos se lea en el mismo orden que el Excel.
    OrdenadoPorId = Table.Sort(IdCategoriaExpandido, {{"id_producto", Order.Ascending}})
in
    OrdenadoPorId
