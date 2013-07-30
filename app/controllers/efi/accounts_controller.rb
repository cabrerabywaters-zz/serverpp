# encoding: utf-8

# Public: Controlador encargado manejar las cuentas de los usuarios de una EFI.
#
# @private Account|Array load_efi_accounts() Carga la(s) cuenta(s) de usuario(s) de la EFI.
#
class Efi::AccountsController < Efi::EfiApplicationController
  before_filter :load_efi_accounts
  load_and_authorize_resource

  # GET /efi/accounts
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /efi/accounts/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /efi/accounts/new
  def new
    @transaction = @account.transactions.build

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /efi/accounts/1/edit
  def edit
    @transaction = @account.transactions.build
  end

  # POST /efi/accounts
  def create
    @account = @current_user_efi.efi.accounts.build(params[:account])

    respond_to do |format|
      if @account.save
        format.html { redirect_to efi_accounts_path, notice: t('notices.success.female.create', model: Account.model_name.human) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /efi/accounts/1
  def update
    respond_to do |format|
      params[:account].delete(:password) if params[:account][:password].blank?

      if @account.update_attributes(params[:account])
        format.html { redirect_to efi_accounts_path, notice: t('notices.success.female.update', model: Account.model_name.human) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /efi/accounts/1
  def destroy
    @account.destroy

    respond_to do |format|
      format.html { redirect_to efi_accounts_url }
    end
  end

  private
  # Internal: Carga la(s) cuenta(s) de usuario(s) de la EFI, salvo en caso que
  #           la EFI no pueda acceder al modulo para manejar cuentas, en cuyo
  #           caso es redirigido al home.
  #
  # Retorna la(s) las cuentas del usuario EFI logeado
  def load_efi_accounts
    redirect_to efi_root_path unless current_user_efi.mod_client?

    if params[:id].presence
      @account  = current_user_efi.efi.accounts.find(params[:id])
    else
      @accounts = current_user_efi.efi.accounts
    end
  end
end