require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Koubata_lc
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Tokyo'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja

    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      class_attr_index = html_tag.index 'class="'

      if class_attr_index
        # target only p's and span's with class error already there
        #error_class = if html_tag =~ /^<(p|span).*error/
        #  'field_with_errors '
        #else
        #  'error '
        #end

        error_class = 'field_with_errors'
        html_tag.insert class_attr_index + 7, error_class
      else
        unless html_tag.index(' />').nil?
          html_tag.insert html_tag.index(' />'), ' class="field_with_errors"'
        else
          html_tag.insert html_tag.index('>'), ' class="field_with_errors"'
        end
      end
    }

    config.generators do |g|
      g.helper false
      g.assets false
      g.test_framewordk :rspec
      g.controller_specs false
      g.view_specs false
    end
  end
end
