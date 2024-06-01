# frozen_string_literal: true

json.users @users do |user|
  p user
  json.partial! 'users/user', user: user
end
