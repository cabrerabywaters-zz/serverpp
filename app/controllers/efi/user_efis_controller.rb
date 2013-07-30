# encoding: utf-8

# Public: Controlador encargado manejar los datos del perfil del usuario logeado.
#
class Efi::UserEfisController < Efi::EfiApplicationController
  load_and_authorize_resource

  # GET /efi/user_efis/1/edit
  def edit
  end

  # PUT /efi/user_efis/1
  def update
    respond_to do |format|
      if params[:user_efi][:password].blank?
        successful_update = @user_efi.update_without_password(params[:user_efi])
      else
        successful_update = @user_efi.update_attributes(params[:user_efi])
      end

      if successful_update
        format.html { redirect_to edit_efi_user_efi_path(current_user_efi), notice: t('notices.success.male.update', model: UserEfi.model_name.human) }
      else
        format.html { render action: "edit" }
      end
    end
  end
end
