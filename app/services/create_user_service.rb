# frozen_string_literal: true

class CreateUserService
  PERMITTED_PARAMS = %i[email phone_number full_name password metadata].freeze

  def call(params)
    @params = params.with_indifferent_access
    user = build_user

    UserKeyAccessJob.perform_async(user.id) if user.save
    user
  end

  private

  attr_reader :params

  def build_user
    User.new(user_params)
  end

  def user_params
    params.slice(*PERMITTED_PARAMS)
  end
end
