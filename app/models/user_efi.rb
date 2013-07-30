# encoding: utf-8

# Public: Usuarios EFI.
#
# @private String full_name() Entrega el nombre completo del usuario EFI.
#
# Mas información en: https://github.com/ryanb/cancan
#
class UserEfi < ActiveRecord::Base
  # Modulo para manejar un rut con las reglas de validación chilenas
  # Mas información en: http://rubygems.org/gems/run_cl
  include RunCl::ActAsRun

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable
  # :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable,
          :recoverable,
          :rememberable,
          :trackable,
          :validatable

  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :first_lastname,
                  :names,
                  :nickname,
                  :rut,
                  :second_lastname,
                  :efi_attributes

  # La diferencia con la definición anterior es que
  # estos se usan por el administrador de PuntosPoint
  # Mas información en: http://guides.rubyonrails.org/security.html#countermeasures
  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :first_lastname,
                  :names,
                  :nickname,
                  :rut,
                  :second_lastname,
                  :efi_id,
                  :mod_client,
                  as: :puntos_point

  belongs_to :efi
  # Acepta atributos nesteados de la EFI asociada
  accepts_nested_attributes_for :efi

  validates_presence_of :first_lastname,
                        :names,
                        :efi_id,
                        :nickname

  validates_uniqueness_of :nickname

  # Valida la presencia y la unicidad de la columna :rut
  validates  :rut, presence: true, uniqueness: true

  # Valida el rut según reglas de validación chilenas,
  # validando tanto formato como unicidad.
  # Por otra parte, quita cualquier tipo de formato del rut,
  # de modo que se mantengan los datos consistentes.
  # Mas información en: http://rubygems.org/gems/run_cl
  has_run_cl :rut

  # Se delega el método :name a la EFI asocida,
  # permitiendo acceder al método efi_name()
  # el resultado es el mismo resultado que utilizar:
  #   self.efi.name
  delegate :name, to: :efi, prefix: true

  # Se delega el método :logo a la EFI asocida,
  # permitiendo acceder al método efi_logo()
  # el resultado es el mismo resultado que utilizar:
  #   self.efi.logo
  delegate :logo, to: :efi, prefix: true
  delegate :zona, to: :efi

  # Se delega el método :available_experiences a la EFI asociada,
  # permitiendo acceder al método available_experiences()
  # el resultado es el mismo resultado que utilizar:
  #   self.efi.available_experiences
  # available_experiences: Corresponde a las Experiences en las
  #                        que puede participar la EFI en cuestión.
  delegate :available_experiences, to: :efi

  # Se delega el método :events a la EFI asociada,
  # permitiendo acceder al método events()
  # el resultado es el mismo resultado que utilizar:
  #   self.efi.events
  # events: Corresponde a los Event's de las Experiences en
  #         las que esta participando la EFI en cuestión.
  delegate :events, to: :efi

  # Internal: Entrega el nombre completo del usuario EFI
  #           sin espacios en los extremos, ni espacios dobles.
  #
  # Ejemplo
  #   a) Para un usuario EFI con:
  #       - nombres: 'Pedro Pablo'
  #       - apellido paterno: 'Perez'
  #       - apellido materno: 'Pereira'
  #     full_name
  #     # => 'Pedro Pablo Perez Pereira'
  #
  # Retorna un String con contiene el nombre completo del usuario EFI.
  def full_name
    (names.strip + ' ' + first_lastname.strip + ' ' + second_lastname.strip).strip
  end
end
