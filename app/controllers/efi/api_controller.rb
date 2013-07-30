class Efi::ApiController < Efi::EfiApplicationController


  def index
  end

  def generate
    @efi = current_user_efi.efi
    username = @efi.search_name
    password = SecureRandom.hex
    @efi.update_attributes(api_username: username, api_password: password)
    respond_to do |format|
      format.html { redirect_to efi_api_index_path, notice: t(:api_credentials, scope: [:notices, :success, :female])}
    end
  end

end