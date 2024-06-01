# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    DEFAULT_PARAMS_KEYS = %w[controller action format].freeze

    before_action :validate_searchable_params, only: [:index]

    def index
      @users = ::UserQuery.search(user_search_params.to_hash)
      render 'users/index', status: :ok
    end

    def create
      @user = CreateUserService.new.call(user_params.to_hash)

      if @user.persisted?
        render 'users/create', status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.permit(:email, :phone_number, :full_name, :password, :metadata)
    end

    def user_search_params
      params.permit(User.ransackable_attributes)
    end

    def validate_searchable_params
      unpermitted_params = params.keys - DEFAULT_PARAMS_KEYS - User.ransackable_attributes
      render json: { errors: ['Unprocessable Entity'] }, status: :unprocessable_entity if unpermitted_params.any?
    end
  end
end
