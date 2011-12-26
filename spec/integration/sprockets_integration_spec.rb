require "rack/test"
require "sprockets"
require "sprockets/image_compressor"

describe "sprockets integration" do
  include Rack::Test::Methods

  let(:app) do
    Sprockets::Environment.new.tap do |environment|
      environment.register_postprocessor 'image/png', :png_compressor do |context, data|
        Sprockets::ImageCompressor::PngCompressor.new.compress data
      end
      environment.register_postprocessor 'image/jpeg', :jpg_compressor do |context, data|
        Sprockets::ImageCompressor::JpgCompressor.new.compress data
      end
      environment.append_path "spec/fixtures"
    end
  end

  it "should compress pngs" do
    get "/largepng.png"
    last_response.should be_ok
    last_response.headers["Content-Length"].should == "116773"
  end

  it "should compress jpgs" do
    get "/largejpg.jpg"
    last_response.should be_ok
    last_response.headers["Content-Length"].should == "4000"
  end
end
