# encoding: utf-8

# Public: Clase para manejar las EFI que pueden participar en una Experiencia.
#
class ExperienceEfi < ActiveRecord::Base
  attr_accessible :efi_id,
                  :experience_id

  belongs_to :experience

  belongs_to :efi

  validates_presence_of :experience_id, on: :update

  validates_presence_of :efi_id

  # Define una llave compuesta, de esta forma la efi puede esta asociada de forma
  # única a una experiencia
  validates_uniqueness_of :efi_id, scope: :experience_id
end
