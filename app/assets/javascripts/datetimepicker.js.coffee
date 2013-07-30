# Activa el comportamiento de datetimepickers para los inputs de fechas con clase 'datetimepicker'
#
$ ->
  $('.datetimepicker').datetimepicker
    format: 'dd/MM/yyyy hh:mm:ss'
    language: 'es'