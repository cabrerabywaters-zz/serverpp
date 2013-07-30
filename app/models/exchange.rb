# encoding: utf-8

# Public: Clase para manejar las formas de canje que definen las EFI, al momento
#         de participar en una experiencia.
#
# @public String name() Permite obtener el nombre de la forma de canje.
#
class Exchange < ActiveRecord::Base
  # Permite convertir numeros en cadenas de texto con formato
  # Mas información en: http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html
  include ActionView::Helpers::NumberHelper

  attr_accessible :cash,
                  :points,
                  :event_id,
                  :event

  belongs_to :event

  has_many   :purchases, dependent: :destroy

  validates_presence_of :points

  validates_numericality_of :points, greater_than: 0, only_integer: true

  validates_presence_of :event_id, on: :update

  # Valida la numeralidad de la columna :cash solo en caso de que esta este presente
  validates_numericality_of :cash,
                            greater_than_or_equal_to: 0,
                            only_integer: true,
                            if: "cash.presence"

  # Internal: Permite obtener el nombre de la forma de canje. Para el nombre utiliza
  #           los datos ingresados por la efi.
  #
  # Retorna un String que contiene el nombre de la forma de canje
  def name
    if self.cash.presence
      number_to_currency(self.points, unit: '') + ' ' + event.efi.zona + ' más ' + number_to_currency(self.cash)
    else
      number_to_currency(self.points, unit: '') + ' ' + event.efi.zona
    end
  end
end
