# encoding: utf-8

# Public: Controlador encargado mostrar las experiencias en las que puede
#         participar la EFI.
#
# @private Array find_available_experiences() Se encarga de cargar solo la(s) experiencia(s)
#                                             en las que puede participar la EFI.
#
class Efi::ExperiencesController < Efi::EfiApplicationController
  before_filter :find_available_experiences
  load_and_authorize_resource

  # GET /efi/experiences
  def index
    if params[:category].presence
      @experiences = @experiences.where(category_id: params[:category])
    elsif params[:exclusivity].presence
      # TODO - ver la forma de delegar mas pega a la Base de Datos
      if params[:exclusivity] == 'total'
        @experiences = @experiences.select{|item| item.available_total_exclusivity? }
      elsif params[:exclusivity] == 'by_industry'
        @experiences = @experiences.select{|item| item.available_exclusivity_by_industry?(current_user_efi.efi) }
      elsif params[:exclusivity] == 'without'
        @experiences = @experiences.select{|item| item.available_without_exclusivity? }
      end
    elsif params[:region].presence
      @experiences = @experiences.joins(:comuna).where('chilean_cities_comunas.region_number = ?', params[:region])
    end
  end

  # GET /efi/experiences/1
  def show
    if current_user_efi.events.where(experience_id: @experience.id).any?
      @event = current_user_efi.events.where(experience_id: @experience.id).last
      session[:selected_menu] = efi_events_path
    else
      @event = current_user_efi.events.build experience_id: @experience.id
      session[:selected_menu] = efi_experiences_path
    end

    @event.exchanges.build unless @event.exchanges.any?


    if session[:show_success_event_modal]
      session.delete(:show_success_event_modal)
      @show_modal = true
    end
  end

  private
  # Internal: Se encarga de cargar solo la(s) experiencia(s) en las que puede
  #           participar la EFI.
  #
  # Retorna la(s) experiencia(s) en las que puede participar la EFI.
  def find_available_experiences
    if params[:id].present?
      @experience  = current_user_efi.available_experiences.published_or_active.started.find(params[:id])
    else
      @experiences = current_user_efi.available_experiences.are_published.started
    end
  end
end