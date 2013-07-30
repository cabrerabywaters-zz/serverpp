module Api
  class Cmr::Interests < WashOut::Type
    map name: :string

    def self.fetch experience
      experience.interests.map { |i| { name: i.name } }
    end
  end
end