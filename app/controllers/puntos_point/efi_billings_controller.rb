# encoding: utf-8

# Public: Controlador encargado manejar los ingresos de una EFI.
#
class PuntosPoint::EfiBillingsController < PuntosPoint::PuntosPointApplicationController
  authorize_resource :efi_invoice

  # GET /puntos_point/efi/:id/billings
  def index
    @efi = Efi.find(params[:id])
    @billing_manager = EfiBillingManager.new(@efi)
    @to_pay_invoices = @billing_manager.to_pay_invoices
    @paid_invoices =  @billing_manager.paid_invoices
    @to_pay_events = @billing_manager.to_pay_events

    # Pagado
    @paid_invoices_by_month = @billing_manager.paid_invoices_by_month(page: params[:page])
    @data = LazyHighCharts::HighChart.new('column') do |f|
      f.options[:xAxis] = {categories: get_months, labels: { enabled: true }}
      f.options[:yAxis] = {labels: {enabled: false}, gridLineWidth: 0, title: {text: ""}}
      invoices = @paid_invoices_by_month.collect(&:total)
      f.series(name: 'Total', data: chart_data)
      f.options[:chart][:defaultSeriesType] = "column"
      f.options[:chart][:height] = 150
      f.options[:colors] = ["#34495e"]
      f.legend({enabled: false})
      f.options[:tooltip][:valuePrefix] = "$ "
      f.options[:plotOptions] = {column: {borderWidth: 0, shadow: false}}
    end
  end

  # POST /puntos_point/efi/:id/billings
  def create
    @billing_manager = EfiBillingManager.new(Efi.find(params[:id]))
    respond_to do |format|
      if params[:experiences].present? && @billing_manager.make_invoice(params[:experiences], Time.now)
        format.html { redirect_to puntos_point_billings_path }
      else
        error_message = params[:experiences].present? ? 'Ha ocurido un error al crear la factura.' : 'Debes seleccionar al menos una experiencia para realizar la factura.'
        format.html { redirect_to puntos_point_billings_path, error: error_message }
      end
    end
  end

  def update
    @invoice = Efi.find(params[:efi_id]).invoices.find(params[:id])
    respond_to do |format|
      if @invoice.paid!
        format.html { redirect_to puntos_point_billings_path(anchor: 'paid') }
      else
        format.html { redirect_to puntos_point_billings_path(anchor: 'billed'), error: 'No se pudo declarar como pagada la factura.' }
      end
    end
  end

  private
  def get_months
    current_month = Date.current.month
    months = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
    12.times.collect { |n| months[(current_month + n) % 12] }
  end

  def chart_data
    data = @paid_invoices_by_month.group_by {|i| Time.parse(i.month).strftime('%b')}
    d = get_months.collect do |m|
      data[m].try(:first).try(:total) || 0
    end
  end
end