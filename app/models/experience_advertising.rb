class ExperienceAdvertising < ActiveRecord::Base
  attr_accessible :advertising_id,
                  :experience_id

  belongs_to :advertising
  belongs_to :experience

  validates_presence_of :advertising_id

  validates_presence_of :experience_id, on: :update

  # Define una llave compuesta, de esta forma el medio de comunicacion esta asociado
  # de forma única a una experiencia
  validates_uniqueness_of :advertising_id, scope: :experience_id
end
