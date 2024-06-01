# frozen_string_literal: true

RSpec.shared_examples 'an api controller' do |controller, path|
  context 'when ActiveRecord::RecordNotFound is raised' do
    it 'return 404 status' do
      allow_any_instance_of(controller).to receive(:index).and_raise(ActiveRecord::RecordNotFound)
      get path, params: {}

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when StandardError is raised' do
    it 'return 500 status' do
      allow_any_instance_of(controller).to receive(:index).and_raise(StandardError)
      get path, params: {}

      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
