# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountKeyService do
  describe '#call' do
    subject { described_class.new.call(email, key) }

    let(:api_url) { ENV['ACCOUNT_KEY_URL'] }
    let(:email) { Faker::Internet.email }
    let(:key) { Faker::Internet.password }
    let(:request_headers) { { 'Content-Type' => 'application/json' } }
    let(:request_body) { { email: email, key: key }.to_json }

    context 'when the account key api responds successfully' do
      include_context 'with success api response'

      it 'returns the account key' do
        expect(subject).to eq(response_account_key)
      end
    end

    context 'when the account key api responds status error' do
      before do
        stub_request(:post, api_url)
          .with(body: request_body, headers: request_headers)
          .to_return(status: 500)
      end

      it 'raises an error' do
        expect { subject }.to raise_error(RestClient::Exception)
      end
    end
  end
end
