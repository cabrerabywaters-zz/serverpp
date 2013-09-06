# encoding: utf-8

# Public: Experiencias.
#
# @public String translate_state() Permite obtener el estado en que se encuentra
#                                  la experiencia.
#
# @public Boolean in_state?([]) Helper para saber si la experiencia se encuentra
#                               en alguno de los estado dados.
#
# @public Integer number_of_validations() Número de validaciones realizadas por
#                                         la eco en la experiencia en cuestion.
#
# @public Integer stock_sold() Entrega el stock que se vendio.
#
# @public Integer number_of_issued() Número de compras realizadas por los usuario finales.
#
# @public Boolean get_discount_percentage() Entrega el porcentaje de descuento
#                                           aplicado a la experiencia.
#
# @public Boolean available_total_exclusivity?() Indica si la exclusividad total
#                                                esta disponible para la experiencia
#                                                en cuestión.
#
# @public Boolean available_exclusivity_by_industry?(efi) Indica si la exclusividad
#                                                         por industria esta disponible
#                                                         para la experiencia en
#                                                         cuestión, en base a las
#                                                         industrias de la efi dada.
#
# @public Boolean available_without_exclusivity?() Indica si sin exclusividad esta
#                                                 disponible para la experiencia
#                                                 en cuestión.
#
# @public Integer industry_swaps(efi) Entrega la cantidad de canjes a reservar
#                                     para exclusividades por industria.
#
# @public Integer minimum_without_swaps() Entrega la cantidad de canjes a reservar
#                                         para sin exclusividad.
#
# @private Date|NilClass set_starting_at() Callback para setea por defecto un valor
#                                          en la columna :starting_at.
#
# @private Date|NilClass set_ending_at() Callback para setea por defecto un valor
#                                        en la columna :set_ending_at.
#
# @private Date|NilClass set_validity_starting_at() Callback para setea por defecto un valor
#                                                   en la columna :validity_starting_at.
#
# @private Date|NilClass set_validity_ending_at() Callback para setea por defecto un valor
#                                                 en la columna :validity_ending_at.
#
# @private Integer|NilClass set_discounted_price() Callback para setea por defecto
#                                                  un valor en la columna discounted_price
#
class Experience < ActiveRecord::Base
  # Attributos que no estan persistidos en la base de datos, pero que pueden ser
  # seleccionados en algun formulario de experiencias, y que además puedes ser
  # validados, traducidos entre otras cosas.
  attr_accessor :discount_percentage,
                :file_codes


  # Utilizado por el administrador de PuntosPoint
  # Mas información en: http://guides.rubyonrails.org/security.html#countermeasures
  attr_accessible :amount,
                  :available_efi_ids,
                  :category_id,
                  :details,
                  :eco_id,
                  :ending_at,
                  :interest_ids,
                  :image,
                  :name,
                  :place,
                  :starting_at,
                  :summary,
                  :swaps,
                  :validity_ending_at,
                  :validity_starting_at,
                  :discounted_price,
                  :discount_percentage,
                  :file_codes,
                  :chilean_cities_comuna_id,
                  :industry_experiences_attributes,
                  :exchange_mechanism,
                  :conditions,
                  :valid_images_attributes,
                  :codes_by_purchase,
                  as: :puntos_point

  belongs_to :category

  belongs_to :eco

  belongs_to :comuna, class_name: ChileanCities::Comuna, foreign_key: :chilean_cities_comuna_id

  # Serializa la columna codes y almacena los códigos subidos por la ECO en formato
  # YAML, pero para ser accedido se puede usar un Array
  serialize :codes, Array

  has_many :experience_efis, dependent: :destroy
  has_many :available_efis,  through: :experience_efis, source: :efi

  has_many :experience_advertisings, dependent: :destroy
  has_many :advertisings,  through: :experience_advertisings

  # Acepta atributos nesteados para medios de comunicación,
  # rechazando individualmente cada uno si los datos estan vacios.
  accepts_nested_attributes_for :experience_advertisings, reject_if: :all_blank

  has_many :interest_experiences, dependent: :destroy
  has_many :interests, through: :interest_experiences

  has_many :events,       dependent: :destroy

  has_many :valid_images, dependent: :destroy
  # Acepta atributos nesteados para valid_images,
  # rechazando individualmente cada valid_images si los datos estan vacios,
  # ademas se permite que se puedan eliminar.
  accepts_nested_attributes_for :valid_images,
                                reject_if: :all_blank,
                                allow_destroy: true

  has_many :industry_experiences, dependent: :destroy
  # Acepta atributos nesteados para valid_images,
  # rechazando individualmente cada valid_images si los datos estan vacios.
  accepts_nested_attributes_for :industry_experiences, reject_if: :all_blank

  has_many   :purchases, through: :events

  # Documento adjunto, cuando se sube la imagen se redimenciona a la resolución
  # indicada.
  # Mas información en: https://github.com/thoughtbot/paperclip
  #                     http://www.imagemagick.org
  #                     http://www.imagemagick.org/script/command-line-processing.php#geometry
  has_attached_file :image,
                    styles: {original: "470x350!", medium: "270x220!", small: "180x245!", thumb: "100x100!"}

  # Búsqueda predefinida que permite filtrar/buscar experiencia que fueron publicadas.
  scope :was_published,          where(state: ['published', 'on_sale', 'closed', 'expired', 'billed', 'paid'])

  # Búsqueda predefinida que permite filtrar/buscar experiencia publicadas o en venta.
  scope :are_published,          where(state: ['published', 'on_sale'])

  # Búsqueda predefinida que permite filtrar/buscar experiencia facturadas.
  scope :are_billed,             where(state: 'billed')

  # Búsqueda predefinida que permite filtrar/buscar experiencia cerradas.
  scope :are_closed,             where(state: 'closed')

  # Búsqueda predefinida que permite filtrar/buscar experiencia expiradas, facturads o pagadas.
  scope :expired_billed_or_paid,              where(state: ['expired', 'billed', 'paid'])

  # Búsqueda predefinida que permite filtrar/buscar experiencia publicadas, o en venta.
  scope :published_or_on_sale,                where(state: ['published', 'on_sale'])

  # Búsqueda predefinida que permite filtrar/buscar experiencia en venta o cerradas.
  scope :on_sale_or_closed,                   where(state: ['on_sale', 'closed'])

  # Búsqueda predefinida que permite filtrar/buscar experiencia en pendientes, publicadas, en venta o cerradas.
  scope :pending_published_on_sale_or_closed, where(state: ['pending', 'published', 'on_sale', 'closed'])

  # Búsqueda predefinida que permite filtrar/buscar experiencia que aun no estan cerradas.
  scope :started, lambda { where('starting_at <= :now', now: Date.current) }

  # Definición de una maquina de estados para la experiencia, para lo cual se usa
  # la columna :state
  # Mas información en: https://github.com/pluginaweek/state_machine
  state_machine :initial => :step1 do
    event :sell! do
      transition published: :on_sale
    end

    event :close! do
      transition pending:   :closed
      transition published: :closed
      transition on_sale:   :closed
    end

    event :expire! do
      transition closed: :expired
    end

    event :bill! do
      transition expired: :billed
    end

    event :pay! do
      transition billed: :paid
    end

    event :step2! do
      transition step1: :step2
    end

    state :step1 do
      attr_accessible :eco_id,
                      :name,
                      :validity_ending_at,
                      :validity_starting_at,
                      :swaps,
                      :place,
                      :chilean_cities_comuna_id,
                      :image,
                      :details,
                      :exchange_mechanism,
                      :conditions

      # La diferencia con la definición anterior es que
      # estos se usan por el administrador de PuntosPoint
      # Mas información en: http://guides.rubyonrails.org/security.html#countermeasures
      attr_accessible :eco_id,
                      :name,
                      :validity_ending_at,
                      :validity_starting_at,
                      :swaps,
                      :place,
                      :chilean_cities_comuna_id,
                      :image,
                      :details,
                      :exchange_mechanism,
                      :conditions,
                      as: :puntos_point
    end

    state :step2 do
      attr_accessible :amount,
                      :discounted_price,
                      :discount_percentage,
                      :available_efi_ids,
                      :valid_images_attributes,
                      :summary,
                      :file_codes,
                      :codes_by_purchase,
                      :total_exclusivity_sales,
                      :by_industry_exclusivity_sales,
                      :without_exclusivity_sales,
                      :advertising_ids

      # La diferencia con la definición anterior es que
      # estos se usan por el administrador de PuntosPoint
      # Mas información en: http://guides.rubyonrails.org/security.html#countermeasures
      attr_accessible :amount,
                      :discounted_price,
                      :discount_percentage,
                      :available_efi_ids,
                      :valid_images_attributes,
                      :summary,
                      :file_codes,
                      :codes_by_purchase,
                      :total_exclusivity_sales,
                      :by_industry_exclusivity_sales,
                      :without_exclusivity_sales,
                      :total_exclusivity_days,
                      :by_industry_exclusivity_days,
                      :advertising_ids,
                      as: :puntos_point


      validates_presence_of   :name
    end

    state :step3 do
      # Utilizado por el administrador de PuntosPoint
      # Mas información en: http://guides.rubyonrails.org/security.html#countermeasures
      attr_accessible :category_id,
                      :interest_ids,
                      :starting_at,
                      :ending_at,
                      :industry_experiences_attributes,
                      :fee,
                      as: :puntos_point

      validates_presence_of   :name
    end

    state :pending do
      validates_presence_of   :name

    end

    state :published do
      validates_presence_of   :name

      validates_presence_of :amount,
                            :category_id,
                            :details,
                            :eco_id,
                            :ending_at,
                            :place,
                            :starting_at,
                            :summary,
                            :swaps,
                            :validity_ending_at,
                            :validity_starting_at,
                            :discounted_price,
                            :chilean_cities_comuna_id,
                            :conditions,
                            :exchange_mechanism

      # Validaciones de rangos de fechas.
      # Mas información en: https://github.com/codegram/date_validator
      validates :starting_at,          date: { after_or_equal_to: Proc.new {|item| item.new_record? ? Date.current : item.created_at.to_date} }
      validates :validity_starting_at, date: { after_or_equal_to: Proc.new {|item| item.starting_at} }
      validates :ending_at,            date: { after_or_equal_to: Proc.new {|item| item.validity_starting_at} }
      validates :validity_ending_at,   date: { after_or_equal_to: Proc.new {|item| item.ending_at} }
    end

    state :on_sale do
    end

    state :closed do
    end

    state :expired do
    end

    state :billed do
    end

    state :paid do
    end

    state :step2, :step3, :pending, :published, :on_sale, :closed, :expired, :billed, :paid do
      # Validador personalizado encargado de validar una experiencia
      # impidiendo que experiencias con el mismo nombre no puedan estar disponibles a mismo tiempo
      # Mas información en: lib/experience_name_validator.rb
      validates_with ExperienceNameValidator
    end

    state :step3, :pending, :published, :on_sale, :closed, :expired, :billed, :paid do
      # Valida que se lecciones al menos un tipo de exclusividad
      validate  {
        if self.eco.presence and self.eco.bigger?
          self.errors[:base] << I18n.t('errors.messages.exclusivity_required') unless self.total_exclusivity_sales or self.by_industry_exclusivity_sales or self.without_exclusivity_sales
        end
      }
    end

    state :step1, :step2, :step3, :pending, :published do
      attr_accessor   :validated
      attr_accessible :validated, as: :puntos_point

      # Setear para state, permite setear el estado en pendiento o publicado
      # segun sea el caso, de esta forma los usuarios no pueden setar directamente
      # el estado de la experiencia
      def validated= val
        if self.pending? or self.published?
          if val == 'true' or val == '1' or val == true
            self.state = 'published'
          else
            self.state = 'pending'
          end
        end
      end

      # Valida la experiencia en términos de descuentos
      # Mas información en: http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-methods
      validate  {|e| e.send :valid_discount }

      # Válida la experiencia en términos de codigos por canje
      # Mas información en: http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-methods
      validate  {|e| e.send :valid_file_codes }
    end

    state :published, :on_sale, :closed, :expired, :billed, :paid do
      # Valida el porcentaje asignado a cada industria
      validate {|e|
        if self.industry_experiences.map(&:percentage).sum != 100.0
          self.errors[:industry_experiences] << I18n.t('errors.messages.invalid')
          self.industry_experiences.each do |industry_experience|
            industry_experience.errors[:percentage] << I18n.t('activerecord.errors.messages.sum_percentage_invalid')
          end
        end
      }

      validates_numericality_of :amount,            greater_than: 0, only_integer: true
      validates_numericality_of :swaps,             greater_than: 0, only_integer: true
      validates_attachment_presence :image

      # Valida la experiencia en términos de descuentos
      # Mas información en: http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-methods
      validate  {|e| e.send :valid_discount}

      # Válida la experiencia en términos de codigos por canje
      # Mas información en: http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-methods
      validate  {|e| e.send :valid_file_codes }

      validates_numericality_of :fee, greater_than_or_equal_to: Proc.new {|item| item.eco.presence ? [item.eco.fee, 0].max : 0}, less_than: 100

      validates_presence_of :total_exclusivity_days,       if: 'total_exclusivity_sales.presence and (by_industry_exclusivity_sales.presence or without_exclusivity_sales.presence)'
      validates_presence_of :by_industry_exclusivity_days, if: 'by_industry_exclusivity_sales.presence and without_exclusivity_sales.presence'

      validates_numericality_of :total_exclusivity_days,       greater_than_or_equal_to: 0, only_integer: true, if: 'total_exclusivity_days.presence or (total_exclusivity_sales.presence and by_industry_exclusivity_sales.presence) or (total_exclusivity_sales.presence and without_exclusivity_sales.presence)'
      validates_numericality_of :by_industry_exclusivity_days, greater_than_or_equal_to: 0, only_integer: true, if: 'by_industry_exclusivity_days.presence or (by_industry_exclusivity_sales.presence and without_exclusivity_sales.presence)'

      # Internal: Indica si una experiencia se puede tomar con exclusividad total
      #
      # Retorna Boolean.
      def total_exclusivity_enabled?
        self.total_exclusivity_sales.present?
      end

      # Internal: Indica si una experiencia se puede tomar con exclusividad por industria
      #
      # Retorna Boolean.
      def by_industry_exclusivity_enabled?
        if self.by_industry_exclusivity_sales.present?
          wait_days = self.total_exclusivity_sales.present? ? self.total_exclusivity_days : 0

          if wait_days > 0
            (self.starting_at + wait_days.days) <= Date.today
          else
            true
          end
        else
          false
        end
      end

      # Internal: Indica si una experiencia se puede tomar sin exclusividad
      #
      # Retorna Boolean.
      def without_exclusivity_enabled?
        if self.without_exclusivity_sales.present?
          wait_days = 0
          wait_days += self.total_exclusivity_sales.present?       ? self.total_exclusivity_days       : 0
          wait_days += self.by_industry_exclusivity_sales.present? ? self.by_industry_exclusivity_days : 0

          if wait_days > 0
            (self.starting_at + wait_days.days) <= Date.today
          else
            true
          end
        else
          false
        end
      end
    end
  end

  # Internal: Permite obtener el estado en que se encuentra la experiencia, en un
  #           formato más legible por el usuario final, para esto usa el archivo
  #           de traducciones I18n (http://guides.rubyonrails.org/i18n.html).
  #
  # Retorna un String con contiene el nombre del estado ya traducido.
  def translate_state
    translate = I18n.t('state_machine.experience.' + state)
    return translate unless translate.include?('translation missing:')

    return state
  end

  # Public: Helper para saber si la experiencia se encuentra en alguno de los
  #         estado dados.
  #
  # @parametros:
  # Array|String|Symbol states - estado(s) a consultar contra el estado de la experiencia
  #
  # Returns Boolean.
  def in_state?(states)
    if states.class == Array
      states.map{|item| item.to_s}.include? self.state
    elsif states.class == String or states.class == Symbol
      states.to_s == self.state
    else
      nil
    end
  end

  # Se delega el método :name a la Category asocida, permitiendo acceder al
  # método category_name()
  # el resultado es el mismo resultado que utilizar:
  #   self.category.name
  delegate :name,         to: :category, prefix: true, allow_nil: true

  # Se delega el método :name a la Category asocida, permitiendo acceder al
  # método category_texture_name()
  # el resultado es el mismo resultado que utilizar:
  #   self.category.texture_name
  delegate :texture_name, to: :category, prefix: true

  # Se delega el método :name a la Comuna asocida, permitiendo acceder al
  # método comuna_name()
  # el resultado es el mismo resultado que utilizar:
  #   self.comuna.name
  delegate :name,         to: :comuna,   prefix: true

  # Public: Número de validaciones realizadas por la eco en la experiencia en cuestion.
  #
  # Returns Integer.
  def number_of_validations
    self.purchases.where(state: 'validated').count
  end

  # Public: Entrega el stock que se vendio.
  #
  # Returns Integer.
  def stock_sold
    self.events.total_exclusivity.sum(:quantity) +
    self.events.exclusivity_by_industry.sum(:quantity) +
    self.events.without_exclusivity.joins(:purchases).count
  end

  # Public: Número de compras realizadas por los usuario finales.
  #
  # Returns Integer.
  def number_of_issued
    self.purchases.count
  end

  # Public: Entrega el porcentaje de descuento aplicado a la experiencia. Esto
  #         debido a que la experiencia no almacena el valor del porcentaje, este
  #         es usado desde el formulario solo para calcular el valor real del precio
  #         con el descuento aplicado.
  #
  # Returns Float.
  def get_discount_percentage
    if self.amount.presence and self.discounted_price.presence
      discount = self.amount - self.discounted_price
      discount.to_f * 100 / self.amount.to_f
    elsif self.discount_percentage.presence
      self.discount_percentage
    else
      nil
    end
  end

  # Public: Setear para códigos, permite leer el excel que suben con los códigos.
  #
  # @parametros:
  # File file - archivo excel a ser cargado
  #
  # Returns Array con los códigos leído del excel.
  def file_codes= file
    if file.original_filename.include? '.xlsx'
      spreadsheet = Roo::Excelx.new(file.path, nil, :ignore)
    else
      spreadsheet = Roo::Excel.new(file.path, nil, :ignore)
    end
    read_codes = []
    (spreadsheet.first_row..spreadsheet.last_row).each do |i|
      code = spreadsheet.cell('A', i)
      read_codes << code if code.presence and not read_codes.include?(code)
    end
    self.codes = read_codes
  end

  # Public: Indica si la exclusividad total esta disponible para la experiencia
  #         en cuestión.
  #
  # Returns Boolean.
  def available_total_exclusivity?
    events.empty?
  end

  # Public: Indica si la exclusividad por industria esta disponible para la
  #         experiencia en cuestión, en base a las industrias de la efi dada.
  #
  # @parametros:
  # Efi efi - Efi para consultar
  #
  # Returns Boolean.
  def available_exclusivity_by_industry?(efi)
    return false if self.events.total_exclusivity.any? # No se puede pedir si el evento ya tiene exclusividad total

    return true  if self.events.exclusivity_by_industry.empty? # Si aun no hay nadie con la exclusividad

    return false if (self.events.exclusivity_by_industry.map{|i| i.efi.industries}.flatten & efi.industries).any? # No se puede pedir el evento, si alguna de las EFI actuales tiene la misma industria

    return true
  end

  # Public: Indica si sin exclusividad esta disponible para la experiencia en
  #         cuestión.
  #
  # Returns Boolean.
  def available_without_exclusivity?
    events.total_exclusivity.empty?
  end

  # Public: Entrega la cantidad de canjes a reservar para exclusividades por industria.
  #         Para esto utiliza la efi dada, y en base a todas las industrias de la
  #         misma se calcula este porcentaje.
  #
  # @parametros:
  # Efi efi - Efi para consultar
  #
  # Returns Integer.
  def industry_swaps efi
    efi_percentage = 0.0
    efi.industries.each do |industry|
      if industry_experience = self.industry_experiences.find_by_industry_id(industry.id)
        efi_percentage += industry_experience.percentage
      end
    end

    [(efi_percentage * 0.01 * swaps).round, 0].max
  end

  # Public: Entrega la cantidad de canjes a reservar para sin exclusividad.
  #         Para esto utiliza el porcentaje definido globalmente.
  #
  # Returns Integer.
  def minimum_without_swaps
    (Settings.minimum_percentage_swap_without_exclusivity * swaps).round
  end

  # Public: Returns image absolute url.
  #
  # style - Style of the image.
  #
  # Returns image absolute url.
  def image_url style = :original
    "#{Rails.configuration.default_url_options[:host]}#{image.url(style, timestamp: false)}"
  end

  after_initialize  :set_starting_at
  after_initialize  :set_ending_at
  after_initialize  :set_validity_starting_at
  after_initialize  :set_validity_ending_at
  before_validation :set_discounted_price
  private
  # Internal: Callback para setea por defecto un valor en la columna starting_at,
  #           salvo en  casos que la columna ya tenga un valor
  #
  # Retorna un Date con el valor seteado en la columna (La fecha actual),
  #         o NilClass en caso de que no se modifique la columna :starting_at.
  def set_starting_at
    self.starting_at = Date.current unless self.starting_at.presence
  end

  # Internal: Callback para setea por defecto un valor en la columna ending_at,
  #           salvo en  casos que la columna ya tenga un valor
  #
  # Retorna un Date con el valor seteado en la columna (La fecha actual),
  #         o NilClass en caso de que no se modifique la columna :ending_at.
  def set_ending_at
    self.ending_at = Date.current unless self.ending_at.presence
  end

  # Internal: Callback para setea por defecto un valor en la columna validity_starting_at,
  #           salvo en  casos que la columna ya tenga un valor
  #
  # Retorna un Date con el valor seteado en la columna (La fecha actual),
  #         o NilClass en caso de que no se modifique la columna :validity_starting_at.
  def set_validity_starting_at
    self.validity_starting_at = Date.current unless self.validity_starting_at.presence
  end

  # Internal: Callback para setea por defecto un valor en la columna validity_ending_at,
  #           salvo en  casos que la columna ya tenga un valor
  #
  # Retorna un Date con el valor seteado en la columna (La fecha actual),
  #         o NilClass en caso de que no se modifique la columna :validity_ending_at.
  def set_validity_ending_at
    self.validity_ending_at = Date.current unless self.validity_ending_at.presence
  end

  # Internal: Callback para setea por defecto un valor en la columna discounted_price,
  #           salvo en casos que no exista un precio y un descuento, y que ademas
  #           la columna no ya tenga un valor previo.
  #
  # Retorna un Integer con el valor seteado en la columna,
  #         o NilClass en caso de que no se modifique la columna :discounted_price.
  def set_discounted_price
    if self.amount.presence and self.discount_percentage.presence
      percentage = 1 - (self.discount_percentage.to_f / 100)
      self.discounted_price = (self.amount * percentage).round unless self.discounted_price.presence
    end
  end

  # Internal: Callback verificar si una experiencia es válida en términos de
  #           descuento y precio. Esto permite que una ECO no pueda asignar
  #           un porcentaje de descuento inferior al asignado.
  #           http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-methods
  #
  # Retorna nil.
  def valid_discount
    if self.discounted_price.presence
      if self.amount.presence
        self.validates_numericality_of :discounted_price, greater_than: 0, less_than_or_equal_to: self.amount, only_integer: true
      else
        self.validates_numericality_of :discounted_price, greater_than: 0, only_integer: true
      end
    end

    if self.discount_percentage.presence
      if self.eco_id.presence
        self.validates_numericality_of :discount_percentage, greater_than_or_equal_to: self.eco.discount, less_than: 100
      else
        self.validates_numericality_of :discount_percentage, greater_than_or_equal_to: 0, less_than: 100
      end
    end
  end

  # Internal: Callback verificar si una experiencia es válida en términos de
  #           codigos por canje. Esto permite que la ECO suba la cantidad de
  #           codigos necesarios para todos los canjes a disponibles.
  #
  # Retorna nil.
  def valid_file_codes
    if self.codes.any?
      self.validates_numericality_of :codes_by_purchase, greater_than: 0, only_integer: true
    end

    if self.codes_by_purchase.presence
      self.errors[:file_codes] << I18n.t('errors.messages.blank') unless self.codes.any?
    end

    if self.codes_by_purchase.presence or self.codes.any?
      self.validates_presence_of :swaps, greater_than: 0, only_integer: true
    end

    if self.swaps.presence and self.codes_by_purchase.presence #and self.codes.any?
      expected_codes = self.swaps * self.codes_by_purchase
      self.errors[:file_codes] << I18n.t('errors.messages.length', count: expected_codes) unless self.codes.count == expected_codes
    end
  end
end
