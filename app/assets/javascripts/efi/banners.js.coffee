$ ->
  $('#banner_event_id').on 'change', (event) ->
    $('.valid_images_container > .well').addClass('dn')

    if $('.valid_images_container > .valid_images_' + $(this).val()).children().length > 2
      $('.valid_images_container > .valid_images_' + $(this).val()).removeClass('dn')

  $('#banner_event_id').change()