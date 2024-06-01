# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'POST /api/users' do
    include_context 'with success api response'

    context 'when the params are valid' do
      let(:user_params) { attributes_for(:user, :with_metadata, email: email) }

      before { post api_users_path, params: user_params }

      it 'creates a new user' do
        expect(User.count).to eq(1)
      end

      it 'return created status' do
        expect(response).to have_http_status(:created)
      end

      it 'key is generated' do
        expect(User.first.key).to be_present
      end

      it 'return user data' do
        expect(response.parsed_body).to include(user_params.except(:password))
      end

      it 'response return correct attributes' do
        expect(response.parsed_body.keys).to match_array(%w[email phone_number full_name key account_key metadata])
      end
    end
  end
end
