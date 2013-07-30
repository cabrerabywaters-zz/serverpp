# encoding: utf-8

# Public: Clase para manejar los porcentajes a reservar para "Exclusividades por Industria"
#         por cada industria del sistema.
#
class IndustryExperience < ActiveRecord::Base
  attr_accessible :percentage,
                  :industry_id,
                  :experience_id

  attr_accessible :percentage,
                  :industry_id,
                  :experience_id,
                  as: :puntos_point

  belongs_to :industry

  belongs_to :experience

  validates_presence_of :industry_id

  validates_presence_of :percentage

  validates_presence_of :experience_id, on: :update

  # Define una llave compuesta, de esta forma la industria puede esta asociada
  # de forma única a una experiencia, permitiendo un único porcentaje por industria
  # en el contexto de una experiencia.
  validates_uniqueness_of :experience_id, scope: :industry_id

  # Valida que el porcentaje sea un numero que se encuentre entre 0 y 100
  validates_numericality_of :percentage, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
end
