# Tarea para agregar :conditions y :exchange_mechanism a las experiencias existentes
#
task set_size_to_ecos: :environment do
  Eco.all.each do |eco|
    eco.bigger = false
    eco.save
  end
end
