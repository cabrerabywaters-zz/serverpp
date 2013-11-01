$.widget 'pp.income',
  _init: ->
    self = @
    @radioButtons = @element.find('input[type="radio"]')
    @element.hide()
    @element.wrap('<div class="hide"/>').parent().parent().append(@buttonGroupHTML())
    @incomeButtons = $('.pp-income')
    @incomeButtons.find('.btn').on 'click', (e) ->
      e.preventDefault()
      $('.pp-income').find('.active').removeClass('active')
      $(@).addClass('active')
      $('input[value="' + $(@).text() + '"]').prop("checked", true)

    @byIndustry = $('#experience_by_industry_exclusivity_sales')
    @noExclusivity = $('#experience_without_exclusivity_sales')
    @byIndustry.on 'change', ->
      self.checkExclusivity()
    @noExclusivity.on 'change', ->
      self.checkExclusivity()
    @checkExclusivity()

  buttonGroupHTML: ->
    optionsHTML = '<div class="btn-group pp-income">'
    @radioButtons.each (i, radioItem) ->
      activeClass = if $(radioItem).is(':checked') then 'active' else ''
      optionsHTML += '<button class="btn ' + activeClass + '">' + $(radioItem).val() + '</button>'
    optionsHTML += '<div />'

  checkExclusivity: ->
    sellIncome = @incomeButtons.find('.btn:first')
    if @byIndustry.is(':checked') or @noExclusivity.is(':checked')
      sellIncome.hide()
      if $('input[value="Ventas"]').is(':checked')
        @incomeButtons.find('.btn:nth(1)').trigger 'click'
    else
      sellIncome.show()

$ ->
  # Collapsible sections
  $('.section-header').on 'click', (e) ->
    $(@).closest('.section').find('.section-content').slideToggle()
    $(@).find('.arrow').toggleClass 'down'

  newExperienceForm = $('form.new_experience')
  editExperienceForm = $('form.edit_experience')
  experienceForm = if newExperienceForm.length > 0 then newExperienceForm else editExperienceForm
  disableAutosave = mediaFilesChanged = false
  newExperience = if newExperienceForm.length > 0 then true else false

  if experienceForm.length > 0
    experienceForm.dirtyForms
      title: 'TITLE'
      message: 'Tienes cambios pendientes sin guardar. Estas seguro que quieres salir?'

    draftSubmitButton = experienceForm.find('input[name="save_draft"]').button()
    running = false
    draftSubmitButton.on 'click', (e) ->
      e.preventDefault()
      experienceForm.ajaxSubmit
        beforeSubmit: ->
          draftSubmitButton.button('loading')
          running = true
        success: (content, status, response) ->
          newExperience = false
          htmlContent = $(content)
          if mediaFilesChanged
            experienceFilesHTML = htmlContent.find('.experience-files')
            experienceForm.find('.experience-files').html experienceFilesHTML.html()
          experienceForm.dirtyForms('setClean')
          if experienceForm.find('input[name="_method"]').length == 0
            experienceForm.find('div:first').append('<input type="hidden" name="_method" value="put" />')
          experienceForm.attr('action', response.getResponseHeader('Location'))
        error: (response) ->
          if response.status == 503 or response.status == 401 or response.status == 403
            disableAutosave = true
        complete: ->
          running = false
          draftSubmitButton.button('reset')

    # Autosave draft experience
    setInterval ->
      if experienceForm.dirtyForms('isDirty') && !running && !disableAutosave
        draftSubmitButton.click()
    , 60000

    experienceForm.find('.relative input[type="file"]').on 'change', ->
      experienceForm.dirtyForms('setDirty')

    experienceForm.delegate '.experience-files input[type="file"]', 'change', ->
      mediaFilesChanged = true
      experienceForm.dirtyForms('setDirty')

  # Income logic
  $('.experience_income_type .controls').income()

  # text editors
  $('.wysihtml5').each (i, elem) ->
    $(elem).wysihtml5
      image: false
      lists: false
      locale: 'es-ES'
      events:
        'change:composer': ->
          experienceForm.dirtyForms('setDirty')