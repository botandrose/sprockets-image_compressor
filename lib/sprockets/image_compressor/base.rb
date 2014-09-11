require "tempfile"

module Sprockets
  module ImageCompressor

    GEM_ROOT = File.expand_path File.join(File.dirname(__FILE__), "../../../")

    class Base
      def binary_path
        @binary_path ||= BinaryFinder.new(@name).to_s
      end
    end

  end
end
