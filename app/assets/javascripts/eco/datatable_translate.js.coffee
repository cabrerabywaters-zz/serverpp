# Definición de la internacionalizacion datatable
#
$ ->
  $.extend $.fn.dataTable.defaults, {
    oLanguage:
      sProcessing:     "Procesando...",
      sLengthMenu:     "Mostrar _MENU_ registros",
      sZeroRecords:    "No se encontraron resultados",
      sEmptyTable:     "No hay datos disponibles",
      sInfo:           "Mostrando desde _START_ hasta _END_ de _TOTAL_ registros",
      sInfoEmpty:      "Mostrando desde 0 hasta 0 de 0 registros",
      sInfoFiltered:   "(filtrado de _MAX_ registros en total)",
      sInfoPostFix:    "",
      sSearch:         "Buscar:",
      sUrl: "",
      sInfoThousands:  ",",
      sLoadingRecord: "Cargando...",
      oPaginate: {
        sFirst:    "Primero",
        sLast:     "Último",
        sNext:     "Siguiente",
        sPrevious: "Anterior"
      },
      fnInfoCallback: null,
      oAria: {
        sSortAscending:  ": activar para Ordenar Ascendentemente",
        sSortDescending: ": activar para Ordendar Descendentemente"
      }
    }