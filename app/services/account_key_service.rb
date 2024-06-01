# frozen_string_literal: true

class AccountKeyService
  HEADERS = {
    content_type: :json,
    accept: :json
  }.freeze

  def call(email, key)
    @email = email
    @key = key

    response = RestClient.post(url, payload, HEADERS)
    parse_body(response)[:account_key]
  end

  private

  attr_reader :email, :key

  def parse_body(response)
    JSON.parse(response.body).with_indifferent_access
  end

  def payload
    {
      email: email,
      key: key
    }.to_json
  end

  def url
    @url ||= ENV['ACCOUNT_KEY_URL']
  end
end
