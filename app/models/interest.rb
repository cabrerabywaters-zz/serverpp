# encoding: utf-8

# Public: Clase para manejar los intereses de una experiencia lo que finalmemte
#         permiten segregar o tagear las experiencias.
#
class Interest < ActiveRecord::Base
  attr_accessible :name

  has_many :interest_experiences, dependent: :destroy
  # Las Experiences que comparten este Interest
  has_many :experiences, through: :interest_experiences

  # Valida la presencia y la unicidad de la columna :name
  validates :name, presence: true, uniqueness: true
end
