# Tarea para agregar :conditions y :exchange_mechanism a las experiencias existentes
#
task add_conditions_and_exchange_mechanism_to_experiences: :environment do
  Experience.all.each do |experience|
    experience.conditions = '<p></p>' unless experience.conditions.presence

    unless experience.exchange_mechanism.presence
      experience.exchange_mechanism = '-'
    end

    experience.save
  end
end
