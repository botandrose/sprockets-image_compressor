module Sprockets
  module ImageCompressor
    class BinaryFinder

      # Detect the OS and use the proper procedure
      # for detecting the installed binary location.
      # Return the executable location (or nil)
      def initialize(binary_name)
        @binary_name = binary_name
        @binary_path ||= begin
          try_system_binary or try_vendored_binaries or raise """
              Can't find an installed version of #{ @binary_name }, and none of the vendored binaries seem to work.
              Please install #{ @binary_name }, or open an issue on the project page at https://github.com/botandrose/sprockets-image_compressor
            """
        end
      end

      def to_s
        @binary_path
      end



      # Try to use known OS 'finder' methods.
      # Return the first one that doesn't fail,
      # but default to 'which' even if all else fails.
      def self.system_method
        # If system() call returns nil, the binary
        # doesn't exist, or at least can't be called
        # without directory context
        [:which, :where].each do |f|
          return f unless system(f.to_s).nil?
        end

        # If neither 'which', nor 'where' work, use old
        # Windows terminal commands to find it. If not using
        # Windows, default to 'which' anyway
        Gem.win_platform? ? "for %i in (#{ @binary_name }) do @echo.   %~$PATH:i" : 'which'
      end
      
      def system_method
        @finder ||= BinaryFinder::system_method
      end



    private

      def try_system_binary
        system_binary = `#{ system_method } #{ @binary_name }`.chomp.split(/[\r\n]/).compact.first
        system_binary.strip! rescue nil
        # If results are obtained, convert the string into proper notation
        # (i.e., C:\something into C:/something)...but raise an error
        # if the file is inaccessible for some reason (bad cygwin install for example)
        if !system_binary.nil? and system_binary.length > 0
          # If we have a path and the binary is accessible, return it.
          # Otherwise, raise an error because we have an inaccessible file!
          system_binary = File.join(system_binary.split(/[\\\/]/))
          raise "sprockets-image_compressor found #{ system_binary } but could not access it!" unless File.exists?(system_binary)
        end
        system_binary
      end

      def try_vendored_binaries
        # use the first vendored binary that doesn't shit the bed when we ask for its version
        vendored_binaries = Dir["#{GEM_ROOT}/bin/#{ @binary_name }.*"].sort
        vendored_binaries.find do |path|
          system("#{ path } -version 2> /dev/null > /dev/null")
        end
      end



    end
  end
end