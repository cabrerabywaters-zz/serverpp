# encoding: utf-8

# Public: Controlador encargado manejar los wizzard de las experiencias de los
#         usuarios de una ECO chica.
#
#
# @private nil redirect_to_finish_wizard() Metodo que permite redefinir la url
#                                          de exito del wizzard.
#
# @private nil set_selected_menu() Selecciona el menú correcto para para todas
#                                  las acciones del controlador.
#
# @private Experience load_experience() Carga una experiencia segun los datos
#                                       almacenados en session
#
class Eco::ExperienceStepsController < Eco::EcoApplicationController
  include Wicked::Wizard
  steps :step1, :step2

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
    authorize! :create, Experience

    if params[:experience_id].presence
      experience   = current_user_eco.experiences.find(params[:experience_id])
      current_step = experience.state.to_sym if [:step1, :step2].include? experience.state.to_sym
      session[:experience_id] = experience.id
    else
      session[:experience_id] = nil
    end

    current_step = :step1 unless current_step.presence

    redirect_to wizard_path(current_step)
  end

  # GET /eco/experience_steps/:step
  def show
    authorize! :create, Experience

    # Si el estado no esta definido en el wizzard
    redirect_to(eco_experiences_path) and return unless step == :step1 or step == :step2 or step == :wicked_finish or step == 'wicked_finish'

    if step == :step2
      # Por defecto se seleccionan todas las efi.
      @experience.available_efi_ids = Efi.all.map(&:id) unless @experience.available_efi_ids.any?

      # Por defecto se muestra un input para subir una imagen valida para crear banners.
      @experience.valid_images.build unless @experience.valid_images.any?

      @experience.total_exclusivity_sales       = true if @experience.total_exclusivity_sales.nil?
      @experience.by_industry_exclusivity_sales = true if @experience.by_industry_exclusivity_sales.nil?
      @experience.without_exclusivity_sales     = true if @experience.without_exclusivity_sales.nil?
    end

    render_wizard
  end

  # PUT /eco/experience_steps/:step
  def update
    authorize! :create, Experience

    params[:experience][:amount]              = params[:experience][:amount].gsub('.', '')               if params[:experience][:amount].presence
    params[:experience][:discounted_price]    = params[:experience][:discounted_price].gsub('.', '')     if params[:experience][:discounted_price].presence
    params[:experience][:discount_percentage] = params[:experience][:discount_percentage].gsub(',', '.') if params[:experience][:discount_percentage].presence

    unless current_user_eco.eco_bigger?
      params[:experience].delete(:total_exclusivity_sales)
      params[:experience].delete(:by_industry_exclusivity_sales)
      params[:experience].delete(:without_exclusivity_sales)
    end

    @experience.attributes = params[:experience]

    if step.to_sym == :step1
      @experience.state = 'draft'
    else # if step.to_sym == :step2
      @experience.state = 'draft'
    end

    if @experience.save
      session[:experience_id] = @experience.id
    end

    render_wizard @experience
  end

  private
  # Internal: Metodo que permite redefinir la url de exito del wizzard.
  #
  # Retorna una String con la ruta a lista de experiencias (eco_experiences_path)
  def finish_wizard_path
    flash[:notice] = nil
    eco_experiences_path
  end

  # Internal: Selecciona el menú correcto para para todas las acciones del
  #           controlador.
  #
  # Retorna una String con la ruta al wizzard de experiencias (eco_experience_steps_path)
  def set_selected_menu
    session[:selected_menu] = eco_experience_steps_path
  end

  # Internal: Carga una experiencia segun los datos almacenados en session. #           Para esto utiliza el usuario logeado y el id de experiencia que
  #           puede estar presente o no.
  #
  # Retorna una Experience
  def load_experience
    # reviso si hay una experiencia que mostrar en el step indicado
    if session[:experience_id].presence
      all_experiences = current_user_eco.experiences

      # Reviso que la experiencia aun exista, en caso que fuera eliminada y la session se mantenga
      if all_experiences.exists?(session[:experience_id])
        @experience = all_experiences.find(session[:experience_id])

        unless @experience.in_state? [:step1, :step2, :step3, :pending]
          redirect_to eco_experiences_path, notice: t('notices.error.not_editable', model: Experience.model_name.human) and return
        end
      end
    end

    # reviso si se cargo la experience desde los datos almacenados en session
    unless defined? @experience
      session[:experience_id] = nil
      @experience = current_user_eco.experiences.build

      # Si es una experiencia nueva, no me puedo saltar el step1
      unless step.to_sym == :step1 or step.to_sym == :wicked_finish
        redirect_to(wizard_path(:step1)) and return
      end
    end

    @experience
  end
end
