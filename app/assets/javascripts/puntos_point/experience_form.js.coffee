$.widget "pp.exclusivity",
  options:
    daysContainer: null

  _init: ->
    self = @
    @daysContainerEl = $(@options.daysContainer)
    if @element.is(':checked')
      @show()
    @element.on 'change', ->
      if $(@).is(':checked')
        self.show()
      else
        self.hide()

  show: ->
    @daysContainerEl.show()

  hide: ->
    @daysContainerEl.hide()
    @daysContainerEl.find('input').val('').trigger('focusout')

$ ->
  # Experience exclusivity
  $('#experience_total_exclusivity_sales').exclusivity
    daysContainer: '#total_exclusivity_days'

  $('#experience_by_industry_exclusivity_sales').exclusivity
    daysContainer: '#by_industry_exclusivity_days'

  # Experience validation
  $('form.edit_experience').validate
    onfocusout: (element) ->
      @element(element)
    rules:
      "experience[swaps]":
        number: true
        min: 1
      "experience[amount]":
        number: true
        min: 1
      "experience[discounted_price]":
        number: true
        min: 1
      "experience[discount_percentage]":
        number: true
        min: 0
        max: 100
      "experience[codes_by_purchase]":
        number: true
        min: 1
      "experience[total_exclusivity_days]":
        number: true
        min: 0
      "experience[by_industry_exclusivity_days]":
        number: true
        min: 0
      "experience[fee]":
        digits: true
        min: 1
        max: 100
