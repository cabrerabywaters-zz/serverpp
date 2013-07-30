# Para todas las experiencias preexistentes, seteo la cantidad de códigos por canje.
#
task set_codes_by_purchase_into_experiences: :environment do
  Experience.all.each do |experience|
    unless experience.codes_by_purchase.presence
      experience.codes_by_purchase = 1
      experience.save(validate: false)
    end
  end
end
