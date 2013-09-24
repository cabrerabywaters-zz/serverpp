# encoding: utf-8

# Modulo que permite la creación de documentos PDF
# Mas información en: https://github.com/Whoops/prawn-rails
require "prawn_rails"
require 'open-uri'

# Public: Clase para manejar el envios de correos, especificamente el envio de voucchers.
#
# @public Mail::Message voucher() Genera un mensaje para envira el voucher de compra al correo.
#
# @private nil make_pdf(purchase, experience) Crear un documento PDF con el voucher.
#
# @private nil stroke_axis(pdf) Dibuja los ejes X e Y en un documento PDF.
#
# Mas información en: http://guides.rubyonrails.org/action_mailer_basics.html
#
class PurchaseMailer < ActionMailer::Base
  default from: "entrada_canjeada@puntospoint.com"

  # Genera un mensaje para envira el voucher de compra al correo.
  #
  # Purchase purchase - la compra por la cual se quiere enviar voucher.
  #
  # Retorna una instancia de un Mail::Message
  def voucher purchase
    @purchase   = purchase
    @experience = @purchase.exchange.event.experience

    pdf = make_pdf @purchase, @experience
    attachments[@purchase.code + '.pdf']  = { :mime_type => 'application/pdf', :content => pdf.render }

    mail(to: @purchase.email, subject: I18n.t('mailers.purchase_mailer.subject'))
  end

  private

  # Internal: Crear un documento PDF con el voucher.
  #
  # @parametros:
  # Purchase   purchase   - la compra de la cual se quiere el voucher en PDF.
  # Experience experience - la experiencia asociada a la compra.
  #
  # Retorna nil.
  def make_pdf purchase, experience
    pdf = Prawn::Document.new :page_layout => :portrait

    # Para dibujar los ejes
    # pdf.fill_color "363636"
    # stroke_axis pdf

    # Header
    pdf.fill_color "363636"
    pdf.fill_rectangle [0, 720], 540, 40

    # Logo PuntosPoint
    pdf.image "/#{Rails.root}/app/assets/images/logo_grande.png", :at => [10, 670], width: 178, height: 70

    # Linea (como si fuera un hr)
    pdf.move_down 130
    pdf.stroke_horizontal_rule

    # Imagen de la experiencia
    p experience.image.url(:thumb)
    image = experience.image.url
    pdf.image open(image), :at => [10, 580], width: 184, height: 137

    y_coordinate = 0

    # Datos de la experiencia
    pdf.bounding_box([205, 580], :width => 320, :height => 330) do
      # Para dibujar contexto
      # pdf.stroke_bounds

      # Nombre Experiencia
      pdf.font_size 14
      pdf.font 'Helvetica', style: :bold
      pdf.text experience.name, :align => :justify

      # Enganche Experiencia
      pdf.font_size 10
      pdf.font 'Helvetica', style: :normal
      pdf.fill_color "006699"
      pdf.text experience.summary, :align => :justify

      # Detalles
      pdf.move_down 20
      pdf.fill_color "363636"
      pdf.text "<b>#{Experience.human_attribute_name(:place)}:</b> #{experience.place}", :inline_format => true, :leading => 5, :align => :justify
      pdf.text "<b>#{Experience.human_attribute_name(:comuna)}:</b> #{experience.comuna_name}", :inline_format => true, :leading => 5, :align => :justify
      pdf.text "<b>#{Experience.human_attribute_name(:validity_starting_at)}:</b> #{I18n.l experience.validity_starting_at, format: :long}", :inline_format => true, :leading => 5, :align => :justify
      pdf.text "<b>#{Experience.human_attribute_name(:validity_ending_at)}:</b> #{I18n.l experience.validity_ending_at, format: :long}", :inline_format => true, :leading => 5, :align => :justify

      # 580        : Posicion Y del bounding_box
      # 330        : Alto máximo del bounding_box
      # pdf.cursor : Espacio del bounding_box no utilizado
      # 430        : Alto mínimo
      y_coordinate = [580 - 330 + pdf.cursor, 430].min
    end

    # Dejo el cursor en la ultima linea donde se escribio en el bounding_box anterior
    pdf.move_cursor_to y_coordinate

    # Agrando la fuente para los códigos
    pdf.font_size 12

    alto  = 40
    ancho = 240

    # Código interno
    pdf.fill_color "DDDDDD"
    pdf.fill_rounded_rectangle [10, pdf.cursor], ancho, alto, 5
    pdf.fill_color "363636"
    pdf.bounding_box([20, pdf.cursor - (alto - pdf.font_size)/2], width: ancho, height: alto) do
      pdf.text "Ticket de Compra: <b>#{@purchase.code}</b>", :inline_format => true
    end

    # Códigos de validación
    pdf.fill_color "DDDDDD"
    pdf.fill_rounded_rectangle [10, pdf.cursor], ancho, alto + @purchase.reference_codes.count * (pdf.font_size + 2), 5
    pdf.fill_color "363636"

    pdf.bounding_box([20, pdf.cursor - (alto - pdf.font_size)/2], width: ancho - 20, height: pdf.font_size) do
      pdf.text "#{Purchase.human_attribute_name(:reference_codes)}:", :inline_format => true
    end

    pdf.bounding_box([20, pdf.cursor - (alto - pdf.font_size)/2 + pdf.font_size], width: ancho - 20, height: @purchase.reference_codes.count * (pdf.font_size + 2)) do
      @purchase.reference_codes.each_with_index do |rc, index|
        pdf.text "<b>#{rc}</b>", :inline_format => true, :align => :center
      end
    end

    # Forma de canje de la Experiencia
    pdf.font_size 10
    pdf.fill_color "DDDDDD"
    # NOTA: Para usar todo el alto disponible cambiar 150 => y_coordinate
    pdf.fill_rounded_rectangle [260, y_coordinate], 265, 150, 5
    pdf.fill_color "363636"
    # NOTA: Para usar todo el alto disponible usar height: y_coordinate - 20
    pdf.bounding_box([270, y_coordinate - 10], :width => 245, :height => 125) do
      # Para dibujar contexto
      # pdf.stroke_bounds

      # Título
      pdf.font_size 14
      pdf.text "<b>#{Experience.human_attribute_name(:exchange_mechanism)}</b>", :inline_format => true
      pdf.text "\n"
      pdf.font_size 10

      # Mas información en: http://www.w3schools.com/tags/ref_entities.asp
      irregular_words = [
                          [/&quot;/,   '"'],
                          [/&apos;/,   "'"],
                          [/&amp;/,    '&'],
                          [/&lt;/,     '<'],
                          [/&gt;/,     '>'],

                          [/&nbsp;/,   ' '],
                          [/&iexcl;/,  '¡'],
                          [/&cent;/,   '¢'],
                          [/&pound;/,  '£'],
                          [/&curren;/, '¤'],
                          [/&yen;/,    '¥'],
                          [/&brvbar;/, '¦'],
                          [/&sect;/,   '§'],
                          [/&uml;/,    '¨'],
                          [/&copy;/,   '©'],
                          [/&ordf;/,   'ª'],
                          [/&laquo;/,  '«'],
                          [/&not;/,    '¬'],
                          [/&shy;/,    ''],
                          [/&reg;/,    '®'],
                          [/&macr;/,   '¯'],
                          [/&deg;/,    '°'],
                          [/&plusmn;/, '±'],
                          [/&sup3;/,   '³'],
                          [/&acute;/,  '´'],
                          [/&micro;/,  'µ'],
                          [/&para;/,   '¶'],
                          [/&middot;/, '·'],
                          [/&cedil;/,  '¸'],
                          [/&sup1;/,   '¹'],
                          [/&ordm;/,   'º'],
                          [/&raquo;/,  '»'],
                          [/&frac14;/, '¼'],
                          [/&frac12;/, '½'],
                          [/&frac34;/, '¾'],
                          [/&iquest;/, '¿'],
                          [/&times;/,  '×'],
                          [/&divide;/, '÷'],

                          [/&Agrave;/, 'À'],
                          [/&Aacute;/, 'Á'],
                          [/&Acirc;/,  'Â'],
                          [/&Atilde;/, 'Ã'],
                          [/&Auml;/,   'Ä'],
                          [/&Aring;/,  'Å'],
                          [/&AElig;/,  'Æ'],
                          [/&AElig;/,  'Æ'],
                          [/&Ccedil;/, 'Ç'],
                          [/&Egrave;/, 'È'],
                          [/&Eacute;/, 'É'],
                          [/&Ecirc;/,  'Ê'],
                          [/&Euml;/,   'Ë'],
                          [/&Igrave;/, 'Ì'],
                          [/&Iacute;/, 'Í'],
                          [/&Icirc;/,  'Î'],
                          [/&Iuml;/,   'Ï'],
                          [/&ETH;/,    'Ð'],
                          [/&Ntilde;/, 'Ñ'],
                          [/&Ograve;/, 'Ò'],
                          [/&Oacute;/, 'Ó'],
                          [/&Ocirc;/,  'Ô'],
                          [/&Otilde;/, 'Õ'],
                          [/&Ouml;/,   'Ö'],
                          [/&Oslash;/, 'Ø'],
                          [/&Ugrave;/, 'Ù'],
                          [/&Uacute;/, 'Ú'],
                          [/&Ucirc;/,  'Û'],
                          [/&Uuml;/,   'Ü'],
                          [/&Yacute;/, 'Ý'],
                          [/&THORN;/,  'Þ'],
                          [/&szlig;/,  'ß'],

                          [/&agrave;/,  'à'],
                          [/&aacute;/,  'á'],
                          [/&acirc;/,   'â'],
                          [/&atilde;/,  'á'],
                          [/&auml;/,    'ä'],
                          [/&aring;/,   'å'],
                          [/&aelig;/,   'æ'],
                          [/&ccedil;/,  'ç'],
                          [/&egrave;/,  'è'],
                          [/&eacute;/,  'á'],
                          [/&ecirc;/,   'ê'],
                          [/&euml;/,    'ë'],
                          [/&igrave;/,  'ì'],
                          [/&iacute;/,  'í'],
                          [/&icirc;/,   'î'],
                          [/&iuml;/,    'ï'],
                          [/&eth;/,     'ð'],
                          [/&ntilde;/,  'ñ'],
                          [/&ograve;/,  'ò'],
                          [/&oacute;/,  'ó'],
                          [/&ocirc;/,   'ô'],
                          [/&otilde;/,  'õ'],
                          [/&ouml;/,    'ö'],
                          [/&oslash;/,  'ø'],
                          [/&ugrave;/,  'ù'],
                          [/&uacute;/,  'ú'],
                          [/&ucirc;/,   'û'],
                          [/&uuml;/,    'ü'],
                          [/&yacute;/,  'ý'],
                          [/&thorn;/,   'þ'],
                          [/&yuml;/,    'ÿ'],

                          [/&euro;/,   '€'],
                          [/&trade;/,  '™']
                        ]

      # Quito tags HTML que prawn no conoce
      exchange_mechanism = experience.exchange_mechanism.html_safe.gsub(/<\/?[^>]+>/, '')
      irregular_words.each do |irregular_word|
        exchange_mechanism = exchange_mechanism.gsub(irregular_word[0], irregular_word[1])
      end

      # NOTA: Para usar todo el alto disponible
      # pdf.text_box exchange_mechanism, at: [0, pdf.cursor], :width => ancho, :height => y_coordinate - (y_coordinate - pdf.cursor), :overflow => :truncate, :align => :justify
      pdf.text_box exchange_mechanism, at: [0, pdf.cursor], :width => ancho, :height => 100, :overflow => :truncate, :align => :justify
    end

    return pdf
  end

  # Internal: Dibuja los ejes X e Y en un documento PDF.
  #
  # @parametros:
  # Prawn::Document pdf - el documento pdf en donde se quiere dibujar los ejes.
  #
  # Retorna nil.
  def stroke_axis(pdf)
    options = { :height => (pdf.cursor - 20).to_i,
                :width => pdf.bounds.width.to_i
              }

    pdf.dash(1, :space => 4)
    pdf.stroke_horizontal_line(-21, options[:width], :at => 0)
    pdf.stroke_vertical_line(-21, options[:height], :at => 0)
    pdf.undash

    pdf.fill_circle [0, 0], 1

    (100..options[:width]).step(50) do |point|
      pdf.fill_circle [point, 0], 1
      pdf.draw_text point, :at => [point-5, -10], :size => 7
    end

    (100..options[:height]).step(50) do |point|
      pdf.fill_circle [0, point], 1
      pdf.draw_text point, :at => [-17, point-2], :size => 7
    end
  end
end
