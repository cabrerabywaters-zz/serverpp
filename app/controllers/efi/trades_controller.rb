# encoding: utf-8

# Public: Controlador encargado manejar reportes.
#
# @private nil set_selected_menu() Selecciona el menú correcto para para todas
#                                  las acciones del controlador.
#
class Efi::TradesController < Efi::EfiApplicationController
  before_filter :set_selected_menu

  # GET /efi/trades/category
  def category
    # Gráfico de canjes por Categoría
    categories      = Category.order(:name).map(&:name)
    purchases       =  []
    other_purchases =  []

    if params[:interest_ids].presence
      @interest_ids = params[:interest_ids].reject{|item| item.blank?}
    else
      @interest_ids = []
    end

    Category.order(:name).each do |c|
      if @interest_ids.any?
        ps = c.experiences.joins(:interest_experiences, events: {exchanges: :purchases}).where('events.efi_id' => current_user_efi.efi_id).where('interest_experiences.interest_id' => @interest_ids).select('DISTINCT(purchases.id)').count
        other_ps = c.experiences.joins(:interest_experiences, events: {exchanges: :purchases}).where('interest_experiences.interest_id' => @interest_ids).select('DISTINCT(purchases.id)').count
      else
        ps = c.experiences.joins(events: {exchanges: :purchases}).where('events.efi_id' => current_user_efi.efi_id).select('DISTINCT(purchases.id)').count
        other_ps = c.experiences.joins(events: {exchanges: :purchases}).select('DISTINCT(purchases.id)').count
      end

      purchases << ps
      other_purchases << (other_ps - ps)
    end

    @trades = LazyHighCharts::HighChart.new('column') do |f|
      f.title({text: t('trades.swaps_vs_category.title')})
      f.options[:xAxis] = {categories: categories}
      f.yAxis({title: {text: t('trades.swaps_vs_category.yAxis')}, labels: {} })
      f.series(name: t('trades.swaps_vs_category.other_xAxis'), data: other_purchases)
      f.series(name: t('trades.swaps_vs_category.xAxis'), data: purchases)
      f.options[:chart][:defaultSeriesType] = "column"
      f.plot_options({column: {stacking: "normal"}})

      f.legend({align: 'right', verticalAlign: 'top', floating: true, shadow: false})
    end
  end

  # GET /efi/trades/efi
  def efi
    # Gráfico de canjes por EFI
    redirect_to efi_root_path, notice: t('notices.error.cant_access') unless current_user_efi.efi.compared?

    categories      = Efi.are_compared.order(:name).map(&:name)
    purchases       =  []

    if params[:interest_ids].presence
      @interest_ids = params[:interest_ids].reject{|item| item.blank?}
    else
      @interest_ids = []
    end

    if params[:category_ids].presence
      @category_ids = params[:category_ids].reject{|item| item.blank?}
    else
      @category_ids = []
    end

    Efi.are_compared.order(:name).each do |efi|
      if @interest_ids.any? and @category_ids.any?
        ps = Experience.joins(:interest_experiences, events: {exchanges: :purchases}).where('events.efi_id' => efi.id).where('interest_experiences.interest_id' => @interest_ids).where('experiences.category_id' => @category_ids).select('DISTINCT(purchases.id)').count
      elsif @interest_ids.any?
        ps = Experience.joins(:interest_experiences, events: {exchanges: :purchases}).where('events.efi_id' => efi.id).where('interest_experiences.interest_id' => @interest_ids).select('DISTINCT(purchases.id)').count
      elsif @category_ids.any?
        ps = Experience.joins(events: {exchanges: :purchases}).where('events.efi_id' => efi.id).where('experiences.category_id' => @category_ids).select('DISTINCT(purchases.id)').count
      else
        ps = Experience.joins(events: {exchanges: :purchases}).where('events.efi_id' => efi.id).select('DISTINCT(purchases.id)').count
      end

      if efi == current_user_efi.efi
        purchases << {y: ps, color: '#ff0000'}
      else
        purchases << {y: ps}
      end
    end

    @trades = LazyHighCharts::HighChart.new('column') do |f|
      f.title({text: t('trades.swaps_vs_efi.title')})
      f.options[:xAxis] = {categories: categories}
      f.yAxis({title: {text: t('trades.swaps_vs_efi.yAxis')}, labels: {} })

      f.series(type: 'column', name: t('trades.swaps_vs_efi.xAxis'), data: purchases)

      f.options[:chart][:defaultSeriesType] = "column"
    end
  end

  private
  # Internal: Selecciona el menú correcto para para todas las acciones del
  #           controlador.
  #
  # Retorna una String con la ruta a lista de experiencias (eco_experiences_path)def set_selected_menu
  def set_selected_menu
    session[:selected_menu] = category_efi_trades_path
  end
end