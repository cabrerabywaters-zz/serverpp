# encoding: utf-8

# Public: Controlador encargado manejar los ingresos de una ECO.
#
class Eco::IncomesController < Eco::EcoApplicationController
  # GET /eco/incomes
  def index
    # reviso que tenga el permiso para ver :incomes
    authorize! :read, :incomes

    @experiences = current_user_eco.experiences.expired_billed_or_paid

    respond_to do |format|
      format.html
    end
  end
end
