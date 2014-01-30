require 'spec_helper'

describe Rack::Snake do
  attr_accessor :query_params
  let(:simple_app) { ->(env) { [200, env, env['rack.input'] + env['QUERY_STRING']] } }
  let(:app) do
    described_class.new(simple_app)
  end

  it 'works for POST' do
    post '/', {"camelCase" => 'camel', "snake_case" => 'snake'}
    expect(last_response.body).to eq("camel_case=camel&snake_case=snake")
  end

  it 'works for GET' do
    get '/', {"camelCase" => 'camel', "snake_case" => 'snake'}
    expect(last_response.body).to eq("camel_case=camel&snake_case=snake")
  end
end
