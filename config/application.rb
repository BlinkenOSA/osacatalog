require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Osacatalog
  class Application < Rails::Application
    config.autoload_paths += %W( #{config.root}/lib )
    config.eager_load_paths += %W( #{config.root}/lib )

    config.assets.paths << Rails.root.join("vendor", "assets", "artificial", "artificial", "images")
    config.assets.paths << Rails.root.join("vendor", "assets", "artificial", "artificial", "fonts")

    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.assets.precompile += %w(*.eot *.svg *.ttf *.woff *.woff2)
    config.assets.precompile += %w(*.xsl)
    config.assets.precompile += %w(*.json)

    config.assets.precompile += %w(artificial.css artificial.js artificial/*)
    config.assets.precompile += %w(datatables.css datatables.js datatables/*)
    config.assets.precompile += %w(jstree.css jstree.js jstree/*)
    config.assets.precompile += %w(listnav.css listnav.js)
    config.assets.precompile += %w(multivio.css multivio.js multivio/*)
    config.assets.precompile += %w(stickyRows.css stickyRows.js stickyRows/*)

    config.assets.precompile += %w(app-tables.js)
    config.assets.precompile += %w(app-tree.js)
    config.assets.precompile += %w(app-tabs.js)
    config.assets.precompile += %w(app-panels.js)
    config.assets.precompile += %w(app-multivio.js)
    config.assets.precompile += %w(app-multivideo.js)
    config.assets.precompile += %w(app-timeline.js)
    config.assets.precompile += %w(osacatalog.js)

    config.assets.precompile += %w(timeline/*)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.application_name = "osacatalog"

    require 'constants'
    require 'holdings'
    require 'nearby_on_shelf'
    require 'fonds_structure'
    require 'fa_structure'
    require 'fa_structure_detailed'
    require 'record_origin_facets'
    require 'browse_list'
    require 'fa_lookup'
    require 'collections_structure'

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
