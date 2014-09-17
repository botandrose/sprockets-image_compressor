require "sprockets/image_compressor"

describe Sprockets::ImageCompressor::BinaryFinder do
  subject { Sprockets::ImageCompressor::BinaryFinder.new(binary) }
  let(:binary) { "example_binary_name" } 
  let(:path)   { "/some/path/to/binary" }

  describe "#path" do
    context "when binary is installed locally " do
      before { subject.stub try_system_binary: path }

      it "prefers the system's binary" do
        subject.path.should == path
      end
    end

    context "when local binary is missing, but one of the vendored binaries works" do
      before { subject.stub try_system_binary: nil, try_vendored_binaries: path }

      it "falls back to the vendored binary" do
        subject.path.should == path
      end
    end

    context "when local binary is missing and none of the vendored binaries work" do
      before { subject.stub try_system_binary: nil, try_vendored_binaries: nil }

      it "raises an error" do
        expect { subject.path }.to raise_error(Errno::ENOENT)
      end
    end
  end
end
