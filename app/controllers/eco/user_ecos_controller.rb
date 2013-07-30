# encoding: utf-8

# Public: Controlador encargado manejar los datos del perfil del usuario logeado.
#
# @private UserEco load_user_eco() Carga el usuario logeado en la variable @user_eco.
#
class Eco::UserEcosController < Eco::EcoApplicationController
  before_filter :load_user_eco
  authorize_resource

  # GET /eco/user_ecos/1/edit
  def edit
  end

  # PUT /eco/user_ecos/1
  def update
    respond_to do |format|
      if params[:user_eco][:password].blank?
        successful_update = @user_eco.update_without_password(params[:user_eco])
      else
        successful_update = @user_eco.update_attributes(params[:user_eco])
      end

      if successful_update
        format.html { redirect_to edit_eco_user_eco_path(current_user_eco), notice: t('notices.success.male.update', model: UserEco.model_name.human) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  private
  # Internal: UserEco load_user_eco() Carga el usuario logeado en la variable @user_eco.
  #
  # Retorna el UserEco logeado
  def load_user_eco
    @user_eco = current_user_eco
  end
end
