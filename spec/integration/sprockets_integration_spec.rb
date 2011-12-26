require "rack/test"
require "sprockets"
require "sprockets/image_compressor"

describe "sprockets integration" do
  include Rack::Test::Methods

  let(:app) do
    Sprockets::Environment.new.tap do |env|
      Sprockets::ImageCompressor::Integration.setup env
      env.append_path "spec/fixtures"
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
