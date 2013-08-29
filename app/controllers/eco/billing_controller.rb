# encoding: utf-8

# Public: Controlador encargado manejar la facturacion de una ECO.
#
class Eco::BillingController < Eco::EcoApplicationController
	def index
		@data = LazyHighCharts::HighChart.new('bar') do |f|
      f.title({text: 'Ingresos Mensuales'})
      f.options[:xAxis] = {categories: ["Marzo", "Abril", "Mayo", "Junio", "Julio"]}
      f.series(name: 'Ingresos', data: [150000, 350000, 250000, 210000, 280000])
      f.options[:chart][:defaultSeriesType] = "bar"
      f.legend({enabled: 'false'})
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
      f.options[:plotOptions] = {column: {borderWidth: 0, shadow: false}}
    end
  end

  def detail
  end
end
