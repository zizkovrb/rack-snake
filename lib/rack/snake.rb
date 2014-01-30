require 'rack'
require 'active_support/inflector'

module Rack
  class Snake
    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      @env = env
      env['rack.input'] = snakeize_query(env['rack.input'].read)
      env['QUERY_STRING'] = snakeize_query(env['QUERY_STRING'])
      @app.call(env)
    end

    private

    def snakeize_query(query)
      params = Rack::Utils.parse_nested_query(query)
      if Hash === params
        snake_params = {}
        params.each_pair do |key, value|
          snake_params[key.underscore] = value
        end
        Rack::Utils.build_nested_query(snake_params)
      end
    end
  end
end
