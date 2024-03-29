require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Btcall
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.assets.precompile += ["fontawesome-webfont.ttf",
                             "fontawesome-webfont.eot",
                             "fontawesome-webfont.svg",
                             "fontawesome-webfont.woff"]

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]


    config.exceptions_app = self.routes
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Beijing'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
     config.i18n.default_locale = :'zh-cn'
  end


  def self.spider_logger
    @spider_logger ||= Logger.new(File.join(Rails.root, "log", "spider.log"))
  end
end
