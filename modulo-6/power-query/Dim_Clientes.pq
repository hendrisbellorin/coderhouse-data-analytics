let
    Origen = Excel.Workbook(File.Contents(RutaExcel), null, true),
    HojaClientes = Origen{[Item = "clientes", Kind = "Sheet"]}[Data],
    EncabezadosPromovidos = Table.PromoteHeaders(HojaClientes, [PromoteAllScalars = true]),

    // Tipar antes de quitar duplicados: Excel puede entregar el mismo ID
    // como 1 (número) y "1" (texto), y Table.Distinct los trataría como
    // dos clientes distintos. Con Int64 los dos quedan iguales.
    TiposAsignados = Table.TransformColumnTypes(EncabezadosPromovidos, {
        {"id_cliente", Int64.Type},
        {"nombre_cliente", type text},
        {"email", type text},
        {"ciudad", type text},
        {"pais", type text},
        {"segmento", type text},
        {"fecha_registro", type date}
    }),

    // id_cliente es la clave primaria de la dimensión. Si se repite, la
    // relación con Fact_Ventas deja de ser 1:N y Power BI la rechaza o la
    // marca como N:N. Se deduplica solo por el ID, no por toda la fila:
    // si mañana el duplicado viene con un email distinto, igual tiene que
    // quedar uno solo. Table.Distinct conserva la primera aparición; acá
    // las dos filas del id 1 son idénticas, así que no se pierde nada.
    DuplicadosQuitadosPorId = Table.Distinct(TiposAsignados, {"id_cliente"}),

    // Valentina Paz (id 9) no tiene email, pero tiene 5 ventas por $3.316.
    // Borrarla dejaría esas ventas sin cliente en el modelo. El email no
    // participa de relaciones ni medidas: alcanza con marcarlo.
    EmailNuloReemplazado = Table.ReplaceValue(DuplicadosQuitadosPorId, null, "Sin dato", Replacer.ReplaceValue, {"email"}),

    // Roberto Díaz (id 11) no tiene ciudad y no se puede deducir: el país
    // (Argentina) tiene varias ciudades. Se marca "Sin dato" en vez de
    // borrarlo porque es un cliente registrado sin compras, justo el caso
    // que le interesa a CRM. Con el valor explícito, el segmentador de
    // ciudad muestra "Sin dato" en lugar de "(En blanco)".
    CiudadNulaReemplazada = Table.ReplaceValue(EmailNuloReemplazado, null, "Sin dato", Replacer.ReplaceValue, {"ciudad"})
in
    CiudadNulaReemplazada
