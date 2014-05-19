require "sprockets/image_compressor/base"

module Sprockets
  module ImageCompressor
    class JpgCompressor < Base
      def initialize
        @name = "jpegoptim"
      end

      def compress(content)
        compressed_jpg_data = ""
        Tempfile.open ["file", ".jpg"] do |file|
          file.binmode
          file.write content
          file.close

          out = `#{binary_path} --strip-all #{file.path} 2>&1`
          compressed_jpg_data = IO.binread(file.path)
        end
        compressed_jpg_data
      end
    end
  end
end
