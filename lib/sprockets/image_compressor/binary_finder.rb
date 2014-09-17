module Sprockets
  module ImageCompressor
    class BinaryFinder
      def initialize binary_name
        @binary_name = binary_name
      end

      attr_reader :binary_name

      def path
        try_system_binary or try_vendored_binaries or raise NotFound
      end

      class NotFound < StandardError
        def message
          """
            Can't find an installed version of #{binary_name}, and none of the vendored binaries seem to work.
            Please install #{binary_name}, or open an issue on the project page at https://github.com/botandrose/sprockets-image_compressor
          """
        end
      end

      private

      def try_system_binary
        which(binary_name)
      end

      def try_vendored_binaries
        # use the first vendored binary that doesn't shit the bed when we ask for its version
        vendored_binaries = Dir["#{GEM_ROOT}/bin/#{ binary_name }.*"].sort
        vendored_binaries.find do |path|
          system("#{ path } -version 2> /dev/null > /dev/null")
        end
      end

      def which cmd
        exts = ENV["PATHEXT"] ? ENV["PATHEXT"].split(";") : [""]
        ENV["PATH"].split(File::PATH_SEPARATOR).each do |path|
          exts.each do |ext|
            exe = File.join(path, "#{cmd}#{ext}")
            return exe if File.executable?(exe) && !File.directory?(exe)
          end
        end
        nil
      end
    end
  end
end
