require "sprockets/image_compressor"

describe Sprockets::ImageCompressor::PngCompressor do
  let(:compressor) { Sprockets::ImageCompressor::PngCompressor.new }
  let(:gem_root) { Sprockets::ImageCompressor::GEM_ROOT }

  describe "#binary_path" do
    context "when pngcrush is installed" do
      before do
        compressor.should_receive(:`).with("which pngcrush").and_return("/path/to/pngcrush\n")
      end

      it "prefers the system's binary" do
        compressor.binary_path.should == "/path/to/pngcrush"
      end
    end

    context "when pngcrush is missing and we're on a supported system" do
      before do
        compressor.should_receive(:`).with("which pngcrush").and_return("")
        compressor.should_receive(:system).and_return(true)
      end

      it "falls back to a vendored binary" do
        compressor.binary_path.should include("#{gem_root}/bin/pngcrush")
      end
    end

    context "when pngcrush is missing and we're an unsupported system" do
      before do
        compressor.should_receive(:`).with("which pngcrush").and_return("")
        compressor.should_receive(:system).twice.and_return(false)
      end

      it "raises hell" do
        lambda { compressor.binary_path }.should raise_exception
      end
    end
  end

  describe "#compress" do
    it "returns uncompressable content as-is with a warning" do
      compressor.should_receive(:warn)
      compressor.compress("asdf").should == "asdf"
    end
  end
end
