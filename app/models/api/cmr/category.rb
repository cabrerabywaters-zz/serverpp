module Api
  class Cmr::Category < WashOut::Type
    type_name 'category'

    map name: :integer, icon_url: :string
    def self.fetch category
      { name: category.name, icon_url: category.icon_url }
    end
  end
end