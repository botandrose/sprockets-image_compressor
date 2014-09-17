require "sprockets/image_compressor"

describe Sprockets::ImageCompressor::BinaryFinder do
  # Whether we're searching for jpegoptim or pngcrush is irrelevant to testing
  let(:finder) { Sprockets::ImageCompressor::BinaryFinder.new(:jpegoptim) }
  let(:gem_root) { Sprockets::ImageCompressor::GEM_ROOT }

  describe "#binary_path" do

    context "when binary is installed" do

      it "prefers the system's binary" do
        # Assume that the program has found a local file
        allow(finder).to receive(:try_system_binary).and_return("/path/to/binary")
        # It should return that path
        expect(finder.path).to eq("/path/to/binary")
      end

    end

    context "when binary is missing and we're on a supported system" do

      it "falls back to a vendored binary" do
        # Assume that the program has NOT found a local file
        allow(finder).to receive(:try_system_binary).and_return(nil)
        # We cannot actually test local files as they are system-dependant (would not pass in Windows)
        # using current implementation)
        allow(finder).to receive(:try_vendored_binaries).and_return("#{gem_root}/bin/jpegoptim")
        # It should return the vendored binary path
        expect(finder.path).to eq("#{gem_root}/bin/jpegoptim")
      end

    end

    context "when binary is missing and we're on an unsupported system" do

      it "raises hell" do
        # Assume that the program has NOT found a local file and the vendored
        # binaries aren't operable, an error should be raised
        allow(finder).to receive(:try_system_binary).and_return(nil)
        allow(finder).to receive(:try_vendored_binaries).and_return(nil)

        expect{finder.path}.to raise_error(Errno::ENOENT)
      end

    end
  end
end
