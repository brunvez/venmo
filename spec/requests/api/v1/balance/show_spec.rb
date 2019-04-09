require 'rails_helper'

describe 'GET api/v1/user/:user_id/balance/', type: :request do
  let(:account_balance) { 100.434132 }
  let(:user) { create(:user, account_balance: account_balance) }
  let(:user_id) { user.id }

  subject { get api_v1_balance_path(user_id) }

  context 'when the user exists' do

    it 'is successful' do
      subject
      expect(response).to be_successful
    end

    it 'returns the user balance rounded' do
      subject
      expect(json(response)[:balance]).to eq(100.43)
    end
  end

  context 'when the user does not exist' do
    let(:user_id) { 0 }

    it 'returns a not found code' do
      subject
      expect(response).to have_http_status(:not_found)
    end
  end
end
