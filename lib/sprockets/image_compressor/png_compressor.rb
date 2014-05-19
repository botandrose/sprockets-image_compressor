require "sprockets/image_compressor/base"

module Sprockets
  module ImageCompressor
    class PngCompressor < Base
      def initialize
        @name = "pngcrush"
      end

      def compress(content)
        compressed_png_data = ""
        Tempfile.open ["in_file", ".png"] do |in_file|
          in_file.binmode
          out_file_path = in_file.path + ".optimized.png"
          in_file.write content
          in_file.close

          out = `#{binary_path} #{in_file.path} #{out_file_path} 2>&1`
          compressed_png_data = IO.binread(out_file_path)
          File.unlink out_file_path
        end
        compressed_png_data

      rescue Errno::ENOENT => e
        # error during compression so out_file not found
        # return original content as a fallback
        warn "sprockets-image_compressor: PNG compression failed... returning original."
        content
      end
    end
  end
end
