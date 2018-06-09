require 'rails_helper'

RSpec.describe 'display likes', type: :request do
  it 'returns a 200 status OK code' do
    get '/'
    expect(response.code).to eq '200'
  end
end
