# Activate plugin and component for custom select/multiselect for @twitter bootstrap using button dropdown
#
$ ->
  $('.selectpicker').selectpicker()

  $('.selectpicker.regions').on 'change', (event) ->
    window.location = $(this).find('option:selected').data('url')