# Activa el comportamiento de datepickers para los inputs de fechas con clase 'datetimepicker'
#
$ ->
  $('.datepicker').datepicker
    format: 'dd/mm/yyyy'
    language: 'es'