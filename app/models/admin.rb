# encoding: utf-8

# Public: Administradores o Usuarios PuntosPoint.
#
# @private String full_name() Entrega el nombre completo del administrador.
#
# @private String name() Entrega el nombre del administrador.
#
# Mas información: en https://github.com/ryanb/cancan
#
class Admin < ActiveRecord::Base
  # Modulo para manejar un rut con las reglas de validación chilenas
  # Mas información en: http://rubygems.org/gems/run_cl
  include RunCl::ActAsRun

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable
  # :lockable, :timeoutable and :omniauthable
  # More information on https://github.com/plataformatec/devise
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
                  :second_lastname

  has_many :ecos, dependent: :nullify

  validates_presence_of :first_lastname,
                        :names,
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

  # Internal: Entrega el nombre completo del administrador
  #           sin espacios en los extremos, ni espacios dobles.
  #
  # Ejemplo
  #   a) Para un administrador con:
  #       - nombres: 'Pedro Pablo'
  #       - apellido paterno: 'Perez'
  #       - apellido materno: 'Pereira'
  #     full_name
  #     # => 'Pedro Pablo Perez Pereira'
  #
  # Retorna un String con contiene el nombre completo del administrador.
  def full_name
    (names.strip + ' ' + first_lastname.strip + ' ' + second_lastname.strip).strip
  end

  # Internal: Entrega el nombre del administrador.
  #
  # Retorna un String con contiene el nombre del administrador.
  def name
    full_name
  end
end
