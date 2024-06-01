# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_context 'with success api response' do
  let(:api_url) { ENV['ACCOUNT_KEY_URL'] }
  let(:email) { Faker::Internet.email }
  let(:key) { Faker::Internet.password }
  let(:request_headers) { { 'Content-Type' => 'application/json' } }
  let(:request_body) { { email: email, key: key }.to_json }
  let(:response_account_key) { Faker::Internet.password }
  let(:response_body) do
    {
      email: email,
      account_key: response_account_key
    }.to_json
  end

  before do
    stub_request(:post, api_url)
      .with(body: request_body, headers: request_headers)
      .to_return(status: 200, body: response_body)
  end
end
