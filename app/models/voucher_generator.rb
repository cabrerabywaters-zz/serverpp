# class VoucherGenerator < AbstractController::Base
class VoucherGenerator < ApplicationController
  # include AbstractController::Logger
  # include AbstractController::Rendering
  # include AbstractController::Layouts
  # include AbstractController::Helpers
  # include AbstractController::Translation
  # include AbstractController::AssetPaths
  # include AbstractController::UrlFor
  # include Rails.application.routes.url_helpers
  # helper ApplicationHelper
  # self.view_paths = "app/views"
  # include PdfHelper

  # attr_accessor :purchase, :experience, :event, :exchange

  def generate(opts={})
    @purchase = opts[:purchase]
    @experience = opts[:experience]
    @event = opts[:event]
    @exchange = opts[:exchange]
    pdf_content = render_to_string pdf: 'voucher',
               layout:    'voucher.html',
               template:  'corporative/purchases/voucher.html',
               margin:    {top: 0, left: 0, bottom: 0, right: 0},
               page_size: 'Letter'

   # voucher_html = render_to_string layout: 'voucher.html', template: 'corporative/purchases/voucher.html'

   # File.open(Rails.root.join('pdfs','voucher_html.html'), 'w') { |file| file << voucher_html }
   # File.open(Rails.root.join('pdfs','voucher_html.pdf'), 'wb') { |file| file << WickedPdf.new.pdf_from_string(voucher_html, margin: {top: 0, left: 0, bottom: 0, right: 0}, page_size: 'Letter') }
   #
   # File.open(Rails.root.join('pdfs','voucher_test.pdf'), 'wb') { |file| file << pdf_content }
  end
end