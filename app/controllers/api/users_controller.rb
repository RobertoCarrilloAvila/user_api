# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
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
  end
end
