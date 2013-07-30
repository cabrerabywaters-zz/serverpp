# encoding: utf-8

# Public: Clase para manejar las Industrias a las que pertenece cada EFI.
#
class IndustryEfi < ActiveRecord::Base
  attr_accessible :industry_id,
                  :efi_id

  belongs_to :industry

  belongs_to :efi

  validates_presence_of :industry_id

  validates_presence_of :efi_id, on: :update

  # Define una llave compuesta, de esta forma la efi puede esta asociada de forma
  # única a una industria
  validates_uniqueness_of :efi_id, scope: :industry_id
end
