module Sprockets
  module ImageCompressor
    class Railtie < Rails::Engine
      initializer :setup_image_compressors do |app|
        if app.config.assets.compress
          app.assets.register_mime_type 'image/png', '.png'
          app.assets.register_postprocessor 'image/png', :png_compressor do |context, data|
            PngCompressor.new.compress data
          end

          app.assets.register_mime_type 'image/jpeg', '.jpg'
          app.assets.register_postprocessor 'image/jpeg', :jpg_compressor do |context, data|
            JpgCompressor.new.compress data
          end
        end
      end
    end
  end
end
