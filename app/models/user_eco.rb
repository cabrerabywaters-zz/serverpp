# encoding: utf-8

# Public: Usuarios ECO.
#
# @private String full_name() Entrega el nombre completo del usuario ECO.
#
# Mas información en: https://github.com/ryanb/cancan
#
class UserEco < ActiveRecord::Base
  # Modulo para que un usuario tenga Grupos y Roles
  # Mas información en: http://rubygems.org/gems/burlesque
  include Burlesque::Admin

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

  attr_accessor :group

  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :first_lastname,
                  :names,
                  :nickname,
                  :rut,
                  :second_lastname,
                  :eco_attributes

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
                  :eco_id,
                  :group,
                  :group_ids,
                  as: :puntos_point

  belongs_to :eco
  # Acepta atributos nesteados de la ECO asociada
  accepts_nested_attributes_for :eco

  validates_presence_of :first_lastname,
                        :names,
                        :eco_id,
                        :nickname

  validates_uniqueness_of :nickname

  # Valida la presencia y la unicidad de la columna :rut
  validates  :rut, presence: true, uniqueness: true

  # Groups es una asociacion que agrega Burlesque al modelo
  # Mas información en: http://rubygems.org/gems/burlesque
  validates_presence_of :groups

  # Valida el rut según reglas de validación chilenas,
  # validando tanto formato como unicidad.
  # Por otra parte, quita cualquier tipo de formato del rut,
  # de modo que se mantengan los datos consistentes.
  # Mas información en: http://rubygems.org/gems/run_cl
  has_run_cl :rut

  # Se delega el método :name a la ECO asocida,
  # permitiendo acceder al método eco_name()
  # el resultado es el mismo resultado que utilizar:
  #   self.eco.name
  delegate :name,        to: :eco, prefix: true

  # Se delega el método :fancy_name a la ECO asocida,
  # permitiendo acceder al método eco_fancy_name()
  # el resultado es el mismo resultado que utilizar:
  #   self.eco.fancy_name
  delegate :fancy_name,  to: :eco, prefix: true

  # Se delega el método :logo a la ECO asocida,
  # permitiendo acceder al método eco_logo()
  # el resultado es el mismo resultado que utilizar:
  #   self.eco.logo
  delegate :logo,        to: :eco, prefix: true

  # Se delega el método :experiences a la ECO asocida,
  # permitiendo acceder al método experiences()
  # el resultado es el mismo resultado que utilizar:
  #   self.eco.experiences
  delegate :experiences, to: :eco

  # Se delega el método :bigger? a la ECO asocida,
  # permitiendo acceder al método eco_bigger?()
  # el resultado es el mismo resultado que utilizar:
  #   self.eco.bigger?
  delegate :bigger?, to: :eco, prefix: true

  # Internal: Entrega el nombre completo del usuario ECO
  #           sin espacios en los extremos, ni espacios dobles.
  #
  # Ejemplo
  #   a) Para un usuario ECO con:
  #       - nombres: 'Pedro Pablo'
  #       - apellido paterno: 'Perez'
  #       - apellido materno: 'Pereira'
  #     full_name
  #     # => 'Pedro Pablo Perez Pereira'
  #
  # Retorna un String con contiene el nombre completo del usuario ECO.
  def full_name
    (names.strip + ' ' + first_lastname.strip + ' ' + second_lastname.strip).strip
  end

  # Seter para columan group
  def group=(group_id)
    if group_id.presence
      g = Burlesque::Group.find(group_id)

      self.group_ids= [group_id] if [Settings.admin_eco, Settings.operator_eco].include?(g.name)
    end
  end
end
