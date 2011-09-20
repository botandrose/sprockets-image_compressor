module Sprockets
  module ImageCompressor
    class Railtie < Rails::Engine
      initializer :setup_png_compressor do |app|
        if app.config.assets.compress
          app.assets.register_mime_type 'image/png', '.png'
          app.assets.register_postprocessor 'image/png', :png_compressor do |context, data|
            PngCompressor.new.compress data
          end
        end
      end
    end
  end
end
