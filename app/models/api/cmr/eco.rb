module Api
  class Cmr::Eco < WashOut::Type
    map fancy_name: :string, logo_original_url: :string, logo_thumb_url: :string,
        webpage: :string, address: :string

    def self.fetch eco
      {
        fancy_name: eco.fancy_name, logo_original_url: eco.logo_url(:original),
        logo_thumb_url: eco.logo_url(:thumb), webpage: eco.webpage, address: eco.address
      }
    end

  end
end