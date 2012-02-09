Haml::Template.options[:format] = :html5
Haml::Template.options[:attr_wrapper] = '"'

Sass::Plugin.options[:style] = (RAILS_ENV == "production") ? :compressed : :expanded
