# encoding: utf-8

# Public: Controlador encargado manejar las experiencias en las que esta
#         participando la EFI
#
class Efi::EventsController < Efi::EfiApplicationController
  authorize_resource

  # GET /efi/events
  def index
    @events = current_user_efi.events
  end

  # GET /efi/events/1
  def show
    @event      = current_user_efi.events.find(params[:id])
    @experience = @event.experience

    session[:selected_menu] = efi_events_path
  end

  # POST /efi/experiences/1/events
  def create
    @experience = current_user_efi.available_experiences.are_published.find(params[:experience_id])

    if current_user_efi.events.where(experience_id: @experience.id).any?
      @event = current_user_efi.events.where(experience_id: @experience.id).last
    else
      params[:event].merge!({experience_id: @experience.id})
      @event = current_user_efi.events.build params[:event]
    end

    respond_to do |format|
      if @event.save
        session[:show_success_event_modal] = true
        format.html { redirect_to efi_experience_path(@experience), notice: t('notices.success.male.create', model: Event.model_name.human) }
      else
        @event.exchanges.build unless @event.exchanges.any?
        format.html { render 'efi/experiences/show' }
      end
    end
  end

  # PUT /efi/events/1/publish
  def publish
    @event = current_user_efi.events.find(params[:id])

    # Acción para facturar una experiencia
    respond_to do |format|
      if @event.publish!
        format.html { redirect_to efi_event_path(@event) }
      else
        format.html { redirect_to efi_event_path(@event), notice: I18n.t('notices.error.male.cant_publish', model: Event.model_name.human) }
      end
    end
  end

  # PUT /efi/events/1/unpublish
  def unpublish
    @event = current_user_efi.events.find(params[:id])

    # Acción para facturar una experiencia
    respond_to do |format|
      if @event.unpublish!
        format.html { redirect_to efi_event_path(@event) }
      else
        format.html { redirect_to efi_event_path(@event), notice: I18n.t('notices.error.male.cant_unpublish', model: Event.model_name.human) }
      end
    end
  end
end