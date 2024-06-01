# frozen_string_literal: true

class User < ApplicationRecord
  include BCrypt

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 200 }
  validates :phone_number, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 20 }
  validates :key, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :account_key, uniqueness: true, allow_nil: true, length: { maximum: 100 }
  validates :password, presence: true, length: { maximum: 100 }
  validates :full_name, length: { maximum: 200 }
  validates :metadata, length: { maximum: 2_000 }

  before_validation :build_unique_key

  def self.ransackable_attributes(auth_object = nil)
    %w[email full_name metadata]
  end

  def password=(new_password)
    new_password = Password.create(new_password) if new_password.present?
    super
  end

  private

  def build_unique_key
    self.key = loop do
      random_key = SecureRandom.hex(16)
      break random_key unless self.class.exists?(key: random_key)
    end
  end
end
