#  encoding: utf-8
# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
#
# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.acronym 'RESTful'
# end

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'categoria', 'categorias'
  inflect.irregular 'industria', 'industrias'
  inflect.irregular 'interes', 'intereses'
  inflect.irregular 'empresa de fidelización', 'empresas de fidelización'
  inflect.irregular 'empresa fidelización', 'empresas fidelización'
  inflect.irregular 'administrador', 'administradores'
  inflect.irregular 'usuario EFI', 'usuarios EFI'
  inflect.irregular 'empresa con capacidad ociosa', 'empresas con capacidad ociosa'
  inflect.irregular 'experiencia', 'experiencias'
  inflect.irregular 'forma de caje', 'formas de canje'
  inflect.irregular 'usuario ECO', 'usuarios ECO'
end