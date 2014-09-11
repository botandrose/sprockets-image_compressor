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
    expect(big_response.headers["Content-Length"]).to eq(small_response.headers["Content-Length"])
    expect(big_response.body).to eq(small_response.body)
  end

  it "should compress jpgs" do
    big_response = get "/largejpg.jpg"
    small_response = get "/smalljpg.jpg"
    expect(big_response.headers["Content-Length"]).to eq(small_response.headers["Content-Length"])
    expect(big_response.body).to eq(small_response.body)
  end

  it "should still serve text assets" do
    response = get "/test.css"
    expect(response.status).to eq(200)
  end
end
