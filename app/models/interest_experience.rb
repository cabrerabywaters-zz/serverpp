# encoding: utf-8

# Public: Clase para manejar los intereses de una Experiencia.
#
class InterestExperience < ActiveRecord::Base
  attr_accessible :interest_id,
                  :experience_id

  belongs_to :interest

  belongs_to :experience

  validates_presence_of :interest_id

  validates_presence_of :experience_id, on: :update

  # Define una llave compuesta, de esta forma la experiencia puede tener de forma
  # única a un interés.
  validates_uniqueness_of :experience_id, scope: :interest_id
end
