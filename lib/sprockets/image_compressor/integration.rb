module Sprockets
  module ImageCompressor
    class Integration
      def self.setup env
        env.register_mime_type 'image/png', '.png'
        env.register_postprocessor 'image/png', :png_compressor do |context, data|
          PngCompressor.new.compress data
        end

        env.register_mime_type 'image/jpeg', '.jpg'
        env.register_postprocessor 'image/jpeg', :jpg_compressor do |context, data|
          JpgCompressor.new.compress data
        end
      end
    end
  end
end
