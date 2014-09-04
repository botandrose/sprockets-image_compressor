require "tempfile"

module Sprockets
  module ImageCompressor
    GEM_ROOT = File.expand_path File.join(File.dirname(__FILE__), "../../../")

    class Base
      def binary_path
        @binary_path ||= begin
          try_system_binary or try_vendored_binaries or raise """
            Can't find an installed version of #{@name}, and none of the vendored binaries seem to work.
            Please install #{@name}, or open an issue on the project page at https://github.com/botandrose/sprockets-image_compressor
          """
        end
      end

      private

      def try_system_binary
        system_binary = nil
        [:which, :where].each do |find|
          # which/where may return two or more results separated by a newline. Use the first
          system_binary = `#{find} #{@name}`.chomp.split(/[\r\n]/).compact.first
          # If results are obtained, convert the string into proper notation
          # (i.e., C:\something into C:/something)...but do not set the result
          # if the file is inaccessible
          if system_binary.length > 0
            system_binary = File.join(system_binary.split(/[\\\/]/))
            # Break if the file is inaccessible
            break if File.exists?(system_binary)
            system_binary = nil
          end
        end
        system_binary
      end

      def try_vendored_binaries
        # use the first vendored binary that doesn't shit the bed when we ask for its version
        vendored_binaries = Dir["#{GEM_ROOT}/bin/#{@name}.*"].sort
        vendored_binaries.find do |path|
          system("#{path} -version 2> /dev/null > /dev/null")
        end
      end
    end
  end
end
