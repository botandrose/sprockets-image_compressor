require "sprockets/image_compressor"

describe Sprockets::ImageCompressor::JpgCompressor do
  let(:compressor) { Sprockets::ImageCompressor::JpgCompressor.new }
  let(:gem_root) { Sprockets::ImageCompressor::GEM_ROOT }

  describe "#binary_path" do
    context "when jpegoptim is installed" do
      before do
        compressor.should_receive(:`).with("which jpegoptim").and_return("/path/to/jpegoptim\n")
      end

      it "prefers the system's binary" do
        compressor.binary_path.should == "/path/to/jpegoptim"
      end
    end

    context "when jpegoptim is missing and we're on a supported system" do
      before do
        compressor.should_receive(:`).with("which jpegoptim").and_return("")
        compressor.should_receive(:system).and_return(true)
      end

      it "falls back to a vendored binary" do
        compressor.binary_path.should include("#{gem_root}/bin/jpegoptim")
      end
    end

    context "when jpegoptim is missing and we're on an unsupported system" do
      before do
        compressor.should_receive(:`).with("which jpegoptim").and_return("")
        compressor.should_receive(:system).twice.and_return(false)
      end

      it "raises hell" do
        lambda { compressor.binary_path }.should raise_exception
      end
    end
  end
end
