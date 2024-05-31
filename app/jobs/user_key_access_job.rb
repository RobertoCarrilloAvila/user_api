# frozen_string_literal: true

class UserKeyAccessJob
  include Sidekiq::Job
  sidekiq_options retry: 10

  sidekiq_retries_exhausted do |job, _ex|
    Sidekiq.logger.warn "Failed #{job['class']} with #{job['args']}: #{job['error_message']}"
  end

  def perform(user_id)
    @user_id = user_id

    return unless user

    user.update!(account_key: account_key)
  end

  private

  attr_reader :user_id

  def user
    @user ||= User.find_by(id: user_id)
  end

  def account_key
    @account_key ||= AccountKeyService.new.call(user.email, user.key)
  end
end
