puts "Loading Categories ..."
load "#{Rails.root}/db/seeds/categories.rb"
puts "Categories done!!!\n\n"

puts "Loading Comunas ..."
# Load the chilean cities
load "#{Rails.root}/db/seeds/comunas.rb"
puts "Comunas done!!!\n\n"

puts "Loading Advertisings ..."
load "#{Rails.root}/db/seeds/advertisings.rb"
puts "Advertisings done!!!\n\n"

puts "Loading Groups and Roles ..."
load "#{Rails.root}/db/seeds/groups_and_roles.rb"
puts "Groups and Roles done!!!\n\n"
