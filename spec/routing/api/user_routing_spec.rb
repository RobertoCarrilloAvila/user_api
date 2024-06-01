# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Routes for api users' do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/users').to route_to('api/users#index')
    end

    it 'routes to #create' do
      expect(post: '/api/users').to route_to('api/users#create')
    end
  end
end
