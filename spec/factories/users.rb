# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    phone_number { Faker::PhoneNumber.unique.phone_number }
    full_name { Faker::Name.unique.name }
    password { Faker::Internet.password(min_length: 8, max_length: 15) }
  end
end
