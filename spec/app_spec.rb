require 'spec_helper'
require 'webmock/rspec'

require_relative '../app'

RSpec.describe 'App', type: :request do

  def app
    Sinatra::Application
  end

  it 'says hello world' do
    get '/'
    expect(last_response.body).to match(/Hello World/)
    expect(last_response).to be_ok
  end
end
