# Tarea para agregar :conditions y :exchange_mechanism a las experiencias existentes
#
task set_attributes_into_eco: :environment do
  Eco.all.each do |eco|
    eco.fancy_name = eco.name if eco.fancy_name.nil?
    eco.address    = eco.name if eco.address.nil?
    eco.discount   = 1 if eco.discount.nil?
    eco.fee        = 1 if eco.fee.nil?
    eco.comuna     = ChileanCities::Comuna.first
    eco.admin      = Admin.first

    eco.save
  end
end
