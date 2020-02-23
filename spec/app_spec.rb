require 'spec_helper'
require 'webmock/rspec'

require_relative '../app'

RSpec.describe 'App', type: :request do

  def app
    Sinatra::Application
  end

  let(:dummy_image_path) do
    'spec/fixtures/dummy_image.jpg'
  end
  let(:dummy_image_url_stubbed) do
    'https://i.imgur.com/fIokC3D.jpg'
  end

  before(:each) do
    stub_request(:get, /imgur.com/).
      with(
        headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(
        status: 200,
        body: File.read(dummy_image_path),
        headers: {}
      )
  end

  it 'displays image meta data' do
    get '/info', url: dummy_image_url_stubbed
    # The http request is stubbed with the identical
    # dummy image. Testing the content-type is the
    # only meaningful test of behaviour here.
    expect(last_response.content_type).to eq("application/json")
  end

  it 'resizes dummy image to 25%' do
    get '/thumbnail', url: dummy_image_url_stubbed
    expect(last_response.content_type).to eq("image/jpeg")

    dummy_image = MiniMagick::Image.open(dummy_image_path)
    response_image = MiniMagick::Image.read(last_response.body)

    expect(response_image.width).to eq dummy_image.width * 0.25
  end

  it 'says hello world' do
    get '/'
    expect(last_response.body).to match(/Hello World/)
    expect(last_response).to be_ok
  end
end