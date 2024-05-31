require 'rails_helper'
RSpec.describe UserKeyAccessJob do
  subject { described_class.new }

  let(:user) { create(:user) }

  def perform_job
    subject.perform(user.id)
  end

  describe '#perform' do
    context 'when the job is performed successfully' do
      let(:account_key) { Faker::Internet.password }

      before do
        allow_any_instance_of(AccountKeyService)
          .to receive(:call).with(user.email, user.key).and_return(account_key)
      end

      it 'calls AccountKeyService' do
        expect_any_instance_of(AccountKeyService).to receive(:call).with(user.email, user.key)
        perform_job
      end

      it 'updates the user account key' do
        expect { perform_job }.to change { user.reload.account_key }.from(nil).to(account_key)
      end
    end

    context 'when AccountKeyService raises an error' do
      before do
        allow_any_instance_of(AccountKeyService)
          .to receive(:call).with(user.email, user.key).and_raise(RestClient::Exception)
      end

      it 'raises an error' do
        expect { perform_job }.to raise_error(RestClient::Exception)
      end

      it 'does not update the user account key' do
        expect { perform_job rescue nil }.not_to(change { user.reload.account_key })
      end

      it 'retries the job' do
        expect(described_class).to be_retryable 10
      end
    end

    context 'when the user does not exist' do
      let(:user) { build(:user, id: 0) }

      it 'not raises an error' do
        expect { subject.perform(0) }.not_to raise_error
      end
    end
  end
end
