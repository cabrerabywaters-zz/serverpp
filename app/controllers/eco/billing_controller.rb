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

  def detail
  end
end
