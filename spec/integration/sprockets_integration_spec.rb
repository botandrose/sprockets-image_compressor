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
    big_response = get "/largepng.png"
    small_response = get "/smallpng.png"
    big_response.headers["Content-Length"].should == small_response.headers["Content-Length"]
    big_response.body.should == small_response.body
  end

  it "should compress jpgs" do
    big_response = get "/largejpg.jpg"
    small_response = get "/smalljpg.jpg"
    big_response.headers["Content-Length"].should == small_response.headers["Content-Length"]
    big_response.body.should == small_response.body
  end
end
