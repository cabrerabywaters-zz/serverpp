# encoding: utf-8

# Public: Controlador encargado manejar los ingresos de una EFI.
#
class Efi::SummaryController < Efi::EfiApplicationController
  authorize_resource :experience, parent: false

  # GET /efi/summary
  def index
    @events = current_user_efi.events

    respond_to do |format|
      format.html
    end
  end
end
