# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /api/users' do
    let!(:users) { create_list(:user, 3) }
    let(:first_user) { User.order(id: :desc).first }
    let(:response_users) { response.parsed_body['users'] }

    context 'when there is\'t any query params' do
      before { get api_users_path }

      it 'return all users' do
        expect(response_users.size).to eq(3)
      end

      it 'return correct attributes' do
        first_user_attributes = first_user.attributes
                                          .slice('email', 'phone_number', 'full_name', 'key', 'account_key', 'metadata')

        expect(response_users.first).to include(first_user_attributes)
      end
    end

    context 'when there is email query param' do
      let(:expected_user) { create(:user, email: 'test@test.com') }

      before { get api_users_path, params: { email: expected_user.email } }

      it 'return only the user with the email' do
        expect(response_users.size).to eq(1)
      end

      it 'return correct user' do
        expect(response_users.first['email']).to eq(expected_user.email)
      end
    end

    context 'when there is full_name query param' do
      let(:expected_user) { create(:user, full_name: 'Test User') }

      before { get api_users_path, params: { full_name: expected_user.full_name } }

      it 'return only the user with the full_name' do
        expect(response_users.size).to eq(1)
      end

      it 'return correct user' do
        expect(response_users.first['full_name']).to eq(expected_user.full_name)
      end
    end

    context 'when there is metadata query param' do
      let(:expected_user) { create(:user, metadata: 'test metadata') }

      before { get api_users_path, params: { metadata: expected_user.metadata } }

      it 'return only the user with the metadata' do
        expect(response_users.size).to eq(1)
      end

      it 'return correct user' do
        expect(response_users.first['metadata']).to eq(expected_user.metadata)
      end
    end

    context 'when there is unpermitted query param' do
      before { get api_users_path, params: { unpermitted: 'test' } }

      it 'return unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return correct error message' do
        expect(response.parsed_body['errors']).to eq(['Unprocessable Entity'])
      end
    end
  end

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
