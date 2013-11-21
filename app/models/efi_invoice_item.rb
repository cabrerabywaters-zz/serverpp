class EfiInvoiceItem < ActiveRecord::Base
  belongs_to :efi_invoice
  belongs_to :experience
  attr_accessible :comision, :price, :stock, :total
end
