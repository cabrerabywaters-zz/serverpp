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
  $('.experience_income_type .controls').income()