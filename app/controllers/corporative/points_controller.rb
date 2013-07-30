# encoding: utf-8

# Public: Controlador encargado consultar la cantidad de puntos de una cuenta de
#         un usuario de la EFI
#
class Corporative::PointsController < Corporative::CorporativeApplicationController
  include ActionView::Helpers::NumberHelper
  respond_to :js

  # POST /empresa/1/points.js
  def create
    @rut = Run.remove_format(params[:rut]).presence

    if @rut
      if Run.valid? @rut
        @points = @corporative.get_connector(rut: @rut).get_points
        @valid_run = true

        # Guardo en session los datos del usuario
        session[:points] = number_to_currency @points, unit: ''
        session[:rut]    = Run.format @rut
      else
        @valid_run = false
      end
    end

    respond_to do |format|
      format.js # create.js.erb
    end
  end
end