# encoding: utf-8

# Public: Controlador encargado manejar la facturacion de una ECO.
#
class Eco::BillingController < Eco::EcoApplicationController
  def index
    @billing = EcoBillingManager.new current_user_eco.eco
    @data = LazyHighCharts::HighChart.new('column') do |f|
      # f.options[:xAxis] = {categories: ["Agosto","Septiembre","Octubre","Noviembre","Diciembre","Enero","Febrero","Marzo", "Abril", "Mayo", "Junio", "Julio"], labels: { enabled: true, rotation: -45, align: 'right'}}
      f.options[:xAxis] = {categories: get_months, labels: { enabled: true }}
      f.options[:yAxis] = {labels: {enabled: false}, gridLineWidth: 0, title: {text: ""}}
      invoices = @billing.historical.collect(&:to_pay)
      f.series(name: 'Total a Pagar', data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8000])
      f.options[:chart][:defaultSeriesType] = "column"
      f.options[:chart][:height] = 150
      f.options[:colors] = ["#34495e"]
      f.legend({enabled: false})
      f.options[:tooltip][:valuePrefix] = "$ "
      f.options[:plotOptions] = {column: {borderWidth: 0, shadow: false}}
    end
  end

  def index2
    @data = LazyHighCharts::HighChart.new('column') do |f|
      f.options[:xAxis] = {categories: ["Agosto","Septiembre","Octubre","Noviembre","Diciembre","Enero","Febrero","Marzo", "Abril", "Mayo", "Junio", "Julio"], labels: {enabled: false}}
      f.options[:yAxis] = {labels: {enabled: false}, gridLineWidth: 0, title: {text: ""}}
      f.series(name: 'Ingresos', data: [50000,70000,100000,120000,150000,200000,180000,280000, 350000, 250000, 210000, 280000])
      f.options[:chart][:defaultSeriesType] = "column"
      f.options[:chart][:height] = 150
      f.options[:colors] = ["#34495e"]
      f.legend({enabled: false})
      f.options[:tooltip][:valuePrefix] = "$ "
    end
  end

  def detail
    @billing = EcoBillingManager.new current_user_eco.eco
    @experiences = @billing.transactions_by_experience
  end
  
  private
  def get_months
    current_month = Date.current.month
    months = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
    12.times.collect { |n| months[(current_month + n - 1) % 12] }
  end
end
