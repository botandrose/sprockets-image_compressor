module Sprockets
  module ImageCompressor
    class Railtie < ::Rails.version < '4.0' ? ::Rails::Engine : ::Rails::Railtie
      initializer :setup_image_compressors do |app|
        Integration.setup app.assets if app.config.assets.compress
      end
    end
  end
end
