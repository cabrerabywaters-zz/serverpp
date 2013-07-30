# encoding: utf-8

# Public: Clase manejar los medios de comunicacion con los que se puede difundir una experiencia.
#
#
class Advertising < ActiveRecord::Base
  attr_accessible :image,
                  :name

  validates_presence_of   :name,
                          :image

  validates_uniqueness_of :name

  # Imagen representativa del medio de comunicacion en cuestion.
  # Mas información en: https://github.com/thoughtbot/paperclip
  #                     http://www.imagemagick.org
  #                     http://www.imagemagick.org/script/command-line-processing.php#geometry
  has_attached_file :image,
                    :styles => { :thumb => "x35" }
  validates_attachment_presence :image

  has_many :experience_advertisings, dependent: :destroy
  has_many :experiences, through: :experience_advertisings
end
