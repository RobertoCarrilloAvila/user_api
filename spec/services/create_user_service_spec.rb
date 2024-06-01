# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateUserService do
  describe '#call' do
    subject { described_class.new.call(user_params) }

    context 'when the params are valid' do
      let(:user_params) { attributes_for(:user, :with_metadata) }

      it 'creates a new user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'enqueues a UserKeyAccessJob' do
        expect { subject }.to enqueue_sidekiq_job(UserKeyAccessJob)
      end

      it 'returns persisted user' do
        expect(subject).to be_persisted
      end
    end

    context 'when the params are invalid' do
      let(:user_params) { attributes_for(:user, :with_metadata).merge(email: nil) }

      it 'does not create a new user' do
        expect { subject }.not_to change(User, :count)
      end

      it 'does not enqueue a UserKeyAccessJob' do
        expect { subject }.not_to enqueue_sidekiq_job(UserKeyAccessJob)
      end

      it 'returns a user with errors' do
        expect(subject.errors).to be_present
      end
    end
  end
end
