# encoding: utf-8

# Public: Modulo que empaqueta las comuna, evitando que se pise con otras clases
#         del sistema
#
module ChileanCities

  # Public: Una tabla plana de las comunas chilenas
  #         tal como lo descrito por la subdere (http://www.subdere.gov.cl)
  #
  class Comuna < ActiveRecord::Base
    # Para ordenar alfabeticamente y por defecto las comunas.
    # More information on http://guides.rubyonrails.org/active_record_querying.html#applying-a-default-scope
    default_scope order(:name)

    self.table_name = 'chilean_cities_comunas'

    attr_accessible :name,
                    :code,
                    :provincia,
                    :region,
                    :region_number
  end
end