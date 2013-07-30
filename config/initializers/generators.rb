Rails.application.config.generators do |g|
  g.form_builder :simple_form_for
  g.template_engine :haml
  g.stylesheet_engine :scss
end