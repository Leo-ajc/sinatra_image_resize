require 'spec_helper'
require 'webmock/rspec'

require_relative '../app'

RSpec.describe '/', type: :request do

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
    stub_request(:get, /url-not-found-stubbed.com/).
      with(
        headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(
        status: 404,
        headers: {}
      )

    stub_request(:get, /imgur.com/).
      with(
        headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(
        status: 200,
        body: File.read(dummy_image_path),
        headers: {}
      )

    stub_request(:get, /invalid-image-url-stubbed.com/).
      with(
        headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(
        status: 200,
        body: File.read('spec/fixtures/not_an_image_file.txt'),
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
    resize_factor = 0.25
    get '/thumbnail', url: dummy_image_url_stubbed

    expect(last_response.content_type).to eq("image/jpeg")

    dummy_image = MiniMagick::Image.open(dummy_image_path)
    response_image = MiniMagick::Image.read(last_response.body)
    expect(response_image.width).to eq dummy_image.width * resize_factor
  end

  it 'handles open(params["url"]) not found' do
    get '/thumbnail', url: 'http://url-not-found-stubbed.com/foo.jpg'
    expect(last_response.status).to eq 400
  end

  it 'handles invalid images' do
    get '/thumbnail', url: 'http://invalid-image-url-stubbed.com/foo.txt'
    #get '/thumbnail', url: dummy_image_url_stubbed
    expect(last_response.status).to eq 400
  end

  ### The Request specs below implicitly test the underlying
  ### behaviour of ParameterValidation.
  it 'handles invalid urls' do
    get '/thumbnail', url: 'htttttttttp://invalid-url.com'
    expect(last_response.status).to eq 400
  end

  it 'handles blank urls' do
    get '/thumbnail', url: '' # blank
    expect(last_response.status).to eq 400
  end

  it 'handles absent url params' do
    get '/thumbnail' # no params
    expect(last_response.status).to eq 400
  end
end
