module Api
  class Cmr::Interests < WashOut::Type
    type_name 'interests'

    map name: :string
    def self.fetch experience
      experience.interests.map { |i| { name: i.name } }
    end
  end
end