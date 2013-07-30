# encoding: utf-8

# Public: Controlador encargado de actualizar de forma masiva los porcentajes
#         por defecto de cada industria en el sistema.
#
class PuntosPoint::PercentageIndustriesController < PuntosPoint::PuntosPointApplicationController
  authorize_resource :industry, parent: false

  # GET /puntos_point/industries/edit_percentages
  def edit
    @industries = Industry.all
  end

  # PUT /puntos_point/industries/percentages
  def update
    errors = false

    # Antes de realizar la actualización se verifica que los porcentajes sumen 100%
    Industry.transaction do
      partial_percentage     = 0
      @industries            = []
      industries_with_errors = []

      params['industries'].each do |industry|
        industry_id         = industry[0]
        industry_percentage = industry[1]['percentage'].to_f
        industry            = Industry.find(industry_id)
        industry.percentage = industry_percentage
        partial_percentage += industry_percentage
        @industries        << industry

        unless industry.save
          industries_with_errors << industry
        end
      end

      industries_with_errors.each do |industry|
        industry.save
      end

      errors = false

      unless @industries.sum(&:percentage) == 100.0 and Industry.sum(:percentage) == 100.0
        errors = true
        raise ActiveRecord::Rollback
      end
    end


    respond_to do |format|
      if not errors
        format.html { redirect_to puntos_point_industries_path }
      else
        format.html { render "edit" }
      end
    end
  end
end