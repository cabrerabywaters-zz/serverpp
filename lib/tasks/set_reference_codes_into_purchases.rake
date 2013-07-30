# Para todas las experiencias preexistentes, seteo la cantidad de códigos por canje.
#
task set_reference_codes_into_purchases: :environment do
  Purchase.all.each do |purchase|
    unless purchase.reference_codes.presence and purchase.reference_codes.any?
      purchase.reference_codes = [purchase.reference_code]
      purchase.save(validate: false)
    end
  end
end
