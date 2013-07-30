# encoding: utf-8

# Public: Controlador encargado manejar los wizzard de las experiencias de las ECO.
#
#
# @private String finish_wizard_path() Metodo que permite redefinir la url
#                                      de exito del wizzard.
#
# @private nil set_selected_menu() Selecciona el menú correcto para para todas
#                                  las acciones del controlador.
#
# @private Experience load_experience() Carga una experiencia segun los datos
#                                       almacenados en session
#
class PuntosPoint::ExperienceStepsController < PuntosPoint::PuntosPointApplicationController
  include Wicked::Wizard
  steps :step1, :step2, :step3

  before_filter :load_experience, except: :index
  before_filter :set_selected_menu

  # GET /eco/experience_steps
  #
  # @parametros:
  # Integer   experience_id   - (Opcional) Id de la experiencia a editar, en
  #                             caso de no existir parametro se asume el flujo
  #                             para crear una nueva experiencia.
  #
  # Ejemplos:
  #   /eco/experience_steps
  #   /eco/experience_steps?experience_id=1
  #
  def index
    if params[:experience_id].presence
      experience   = Experience.find(params[:experience_id])
      current_step = experience.state.to_sym if [:step1, :step2, :step3].include? experience.state.to_sym
      session[:experience_id] = experience.id
    else
      session[:experience_id] = nil
    end

    current_step = :step1 unless current_step.presence

    redirect_to wizard_path(current_step)
  end

  # GET /eco/experience_steps/:step
  def show
    # Si el estado no esta definido en el wizzard
    redirect_to(puntos_point_experiences_path) and return unless step == :step1 or step == :step2 or step == :step3 or step == :wicked_finish or step == 'wicked_finish'

    if step == :step2
      # Por defecto se seleccionan todas las efi.
      @experience.available_efi_ids = Efi.all.map(&:id) unless @experience.available_efi_ids.any?

      # Por defecto se muestra un input para subir una imagen valida para crear banners.
      @experience.valid_images.build unless @experience.valid_images.any?

      @experience.total_exclusivity_sales       = true if @experience.total_exclusivity_sales.nil?
      @experience.by_industry_exclusivity_sales = true if @experience.by_industry_exclusivity_sales.nil?
      @experience.without_exclusivity_sales     = true if @experience.without_exclusivity_sales.nil?
    end

    if step == :step3
      Industry.all.each do |industry|
        unless @experience.industry_experiences.map(&:industry_id).include? industry.id
          @experience.industry_experiences.build(industry_id: industry.id, percentage: industry.percentage)
        end
      end
    end

    render_wizard
  end

  # PUT /eco/experience_steps/:step
  def update
    params[:experience][:amount]              = params[:experience][:amount].gsub('.', '')               if params[:experience][:amount].presence
    params[:experience][:discounted_price]    = params[:experience][:discounted_price].gsub('.', '')     if params[:experience][:discounted_price].presence
    params[:experience][:discount_percentage] = params[:experience][:discount_percentage].gsub(',', '.') if params[:experience][:discount_percentage].presence
    params[:experience][:fee]                 = params[:experience][:fee].gsub(',', '.')                 if params[:experience][:fee].presence

    @experience.assign_attributes params[:experience], as: :puntos_point

    if @experience.in_state? [:step1, :step2, :step3, :pending]
      if step.to_sym == :step1
        @experience.state = 'step2'
      elsif step.to_sym == :step2
        @experience.state = 'step3'
      else # if step.to_sym == :step3
        if params[:only_save].presence
          @experience.state = 'pending'
        else
          @experience.state = 'published'
        end
      end
    end

    if @experience.save
      session[:experience_id] = @experience.id
    end

    render_wizard @experience
  end

  private
  # Internal: Metodo que permite redefinir la url de exito del wizzard.
  #
  # Retorna una String con la ruta a la lista de experiencias
  def finish_wizard_path
    flash[:notice] = nil
    puntos_point_experiences_path
  end

  # Internal: Selecciona el menú correcto para para todas las acciones del
  #           controlador.
  #
  # Retorna una String con la ruta al wizzard de experiencias (puntos_point_experience_steps_path)
  def set_selected_menu
    session[:selected_menu] = puntos_point_experience_steps_path
  end

  # Internal: Carga una experiencia segun los datos almacenados en session. #           Para esto utiliza el usuario logeado y el id de experiencia que
  #           puede estar presente o no.
  #
  # Retorna una Experience
  def load_experience
    # reviso si hay una experiencia que mostrar en el step indicado
    if session[:experience_id].presence
      # Reviso que la experiencia aun exista, en caso que fuera eliminada y la session se mantenga
      if Experience.exists?(session[:experience_id])
        @experience = Experience.find(session[:experience_id])

        unless @experience.in_state? [:step1, :step2, :step3, :pending]
          # redirect_to puntos_point_experiences_path, notice: t('notices.error.not_editable', model: Experience.model_name.human) and return
          flash[:notice] = t('notices.not_editable', model: Experience.model_name.human)
        end
      end
    end

    # reviso si se cargo la experience desde los datos almacenados en session
    unless defined? @experience
      session[:experience_id] = nil
      @experience = Experience.new

      # Si es una experiencia nueva, no me puedo saltar el step1
      unless step.to_sym == :step1 or step.to_sym == :wicked_finish
        redirect_to(wizard_path(:step1)) and return
      end
    end

    @experience
  end
end
