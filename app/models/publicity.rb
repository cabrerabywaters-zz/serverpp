# encoding: utf-8

# Public: Clase para manejar los comunicados de las EFI's
#
# @public String  translate_state()     Permite obtener el estado en que se encuentra el evento
#
# @public String  file_representation() Entrega una imagen representativa del archivo
#
# @public Boolean is_image?()           Indica si el archivo es una imagen
#
# @public Boolean is_pdf?()             Indica si el archivo es un pdf
#
# @public Boolean is_office?()          Indica si el archivo es un archivo de ofice
#
# @public Boolean is_compressed_file?() Indica si el archivo es un archivo comprimido
#
class Publicity < ActiveRecord::Base
  belongs_to :event

  attr_accessible :image, :event_id, as: :efi
  attr_accessible :comment, as: :eco
  attr_accessible :comment, :image, :state, :event_id, as: :puntos_point

  # Documento adjunto
  # Mas información en: https://github.com/thoughtbot/paperclip
  has_attached_file :image

  validates_attachment_presence :image

  validates_presence_of :event_id

  # Definición de una maquina de estados para el evento, para lo cual se usa la
  # columna :state
  # Mas información en: https://github.com/pluginaweek/state_machine
  state_machine :initial => :pending do
    event :reject! do
      transition pending: :rejected
    end

    event :accept! do
      transition pending: :accepted
    end

    state :pending do
    end

    state :rejected do
      validates_presence_of :comment
    end

    state :accepted do
    end
  end

  # Internal: Permite obtener el estado en que se encuentra el evento, en un
  #           formato más legible por el usuario final, para esto usa el archivo
  #           de traducciones I18n (http://guides.rubyonrails.org/i18n.html).
  #
  # Retorna un String con contiene el nombre del estado ya traducido.
  def translate_state
    translate = I18n.t('state_machine.publicity.' + state)
    return translate unless translate.include?('translation missing:')

    return state
  end

  # Internal: Entrega una imagen representativa del archivo
  #
  # Retorna un String que contiene el nombre de una imagen.
  def file_representation
    if self.is_image?
      self.image.url
    elsif self.is_pdf?
      'publicities/pdf.png'
    elsif self.is_office?
      'publicities/office.png'
    elsif self.is_compressed_file?
      'publicities/zip.png'
    else
      'publicities/file.png'
    end
  end

  # Internal: Indica si el archivo es una imagen
  #
  # Retorna un Boolean.
  def is_image?
    ['jpg', 'jpeg', 'pjpeg', 'png', 'bmp', 'gif', 'x-png'].include? self.image_file_name.split('.').last
  end

  # Internal: Indica si el archivo es un pdf
  #
  # Retorna un Boolean.
  def is_pdf?
    self.image_file_name.split('.').last == 'pdf'
  end

  # Internal: Indica si el archivo es un archivo de ofice
  #
  # Retorna un Boolean.
  def is_office?
    ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'].include? self.image_file_name.split('.').last
  end

  # Internal: Indica si el archivo es un archivo comprimido
  #
  # Retorna un Boolean.
  def is_compressed_file?
    ['rar', 'zip', 'zipx', 'tar', 'bzip', 'bzip2', 'bz2', 'gz', 'tgz', '7z', 's7z'].include? self.image_file_name.split('.').last
  end
end
