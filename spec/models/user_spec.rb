# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'table columns' do
    it { is_expected.to have_db_column(:id).of_type(:integer).with_options(null: false, primary: true) }
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false, limit: 200) }
    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_column(:phone_number).of_type(:string).with_options(null: false, limit: 20) }
    it { is_expected.to have_db_index(:phone_number).unique(true) }
    it { is_expected.to have_db_column(:full_name).of_type(:string).with_options(limit: 200) }
    it { is_expected.to have_db_column(:password).of_type(:string).with_options(null: false, limit: 100) }
    it { is_expected.to have_db_column(:key).of_type(:string).with_options(null: false, limit: 100) }
    it { is_expected.to have_db_index(:key).unique(true) }
    it { is_expected.to have_db_column(:account_key).of_type(:string).with_options(limit: 100) }
    it { is_expected.to have_db_index(:account_key).unique(true) }
  end

  describe 'validations' do
    subject { create(:user) }

    describe '#email' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
      it { is_expected.to validate_length_of(:email).is_at_most(200) }
    end

    describe '#phone_number' do
      it { is_expected.to validate_presence_of(:phone_number) }
      it { is_expected.to validate_uniqueness_of(:phone_number).case_insensitive }
      it { is_expected.to validate_length_of(:phone_number).is_at_most(20) }
    end

    describe '#full_name' do
      it { is_expected.to validate_length_of(:full_name).is_at_most(200) }
    end

    describe '#account_key' do
      it { is_expected.to validate_uniqueness_of(:account_key).allow_nil }
    end

    describe '#metadata' do
      it { is_expected.to validate_length_of(:metadata).is_at_most(2_000) }
    end

    describe '#password' do
      it { is_expected.to validate_presence_of(:password) }

      it 'encrypts the password' do
        expect(BCrypt::Password).to receive(:create).and_call_original
        subject
      end
    end

    describe '#key' do
      subject { create(:user, key: nil) }

      let(:random_key) { 'random_key' }
      let(:user_with_same_key) { create(:user) }

      before do
        allow(SecureRandom).to receive(:hex).and_return(random_key, random_key, 'unique_key')
      end

      it 'builds key' do
        expect(subject.key).to eq(random_key)
      end

      it 'builds unique key' do
        expect(user_with_same_key.key).to eq(random_key)

        expect(SecureRandom).to receive(:hex).twice
        subject
      end

      it 'persists the key' do
        expect { subject }.to change(described_class, :count).by(1)
      end
    end
  end
end
