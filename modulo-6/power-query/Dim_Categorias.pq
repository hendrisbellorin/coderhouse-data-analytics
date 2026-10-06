let
    Origen = Excel.Workbook(File.Contents(RutaExcel), null, true),
    HojaCategorias = Origen{[Item = "categorias", Kind = "Sheet"]}[Data],
    EncabezadosPromovidos = Table.PromoteHeaders(HojaCategorias, [PromoteAllScalars = true]),

    // La tabla viene limpia: solo se tipa. nombre_categoria tiene que ser
    // texto y escribirse igual que productos[categoria]: Dim_Productos
    // busca acá el id_categoria cruzando por ese nombre, y con ese ID se
    // arma la relación 1:N Dim_Categorias -> Dim_Productos en el modelo.
    TiposAsignados = Table.TransformColumnTypes(EncabezadosPromovidos, {
        {"id_categoria", Int64.Type},
        {"nombre_categoria", type text},
        {"descripcion", type text}
    })
in
    TiposAsignados
