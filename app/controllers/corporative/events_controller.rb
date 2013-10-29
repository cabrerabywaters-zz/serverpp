# encoding: utf-8

# Public: Controlador encargado de mostrar las experiencias en las que esta
#         participando la EFI
#
# @private Array load_categories() Carga todas las categorías para ser usadas como filtro.
#
class Corporative::EventsController < Corporative::CorporativeApplicationController
  before_filter :load_categories

  # GET /empresa/1/events
  def index
    @events = @corporative.events.are_published.started

    if params[:category].presence
      @events = @events.where('experiences.category_id = ?', params[:category])
    elsif params[:region].presence
      @events = @events.where('chilean_cities_comunas.region_number = ?', params[:region])
    end
  end

  # GET /empresa/1/events/1
  def show
    all_events = @corporative.events.joins(:experience).are_published.started

    if all_events.exists?(params[:id])
      @event = all_events.find(params[:id])
    else
      redirect_to corporative_root_path(@corporative), notice: t('notices.error.not_available', model: Event.model_name.human)
    end
  end


  private
  # Internal: Carga todas las categorías para ser usadas como filtro.
  #
  # Retorna Array con todas las categorías
  def load_categories
    @categories = Category.all
  end
end