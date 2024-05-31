# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }, limit: 200
      t.string :phone_number, null: false, index: { unique: true }, limit: 20
      t.string :full_name, limit: 200
      t.string :password, null: false, limit: 100
      t.string :key, null: false, index: { unique: true }, limit: 100
      t.string :account_key, index: { unique: true }, limit: 100
      t.text :metadata

      t.timestamps
    end
  end
end
