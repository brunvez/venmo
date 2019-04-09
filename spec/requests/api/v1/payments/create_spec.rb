require 'rails_helper'

describe 'POST api/v1/user/:user_id/payments/', type: :request do
  let(:user_account_balance) { 700 }
  let(:user) { create(:user, account_balance: user_account_balance) }
  let(:friend) { create(:user) }
  let(:user_id) { user.id }
  let(:friend_id) { friend.id }
  let(:amount) { 300 }
  let(:description) { 'Dinner' }
  let(:request_params) do
    { payment:
        {
          friend_id:   friend_id,
          amount:      amount,
          description: description
        }
    }
  end

  subject { post api_v1_payments_path(user_id), params: request_params, as: :json }

  context 'when the users are friends' do

    before do
      create(:friendship, first_user: user, second_user: friend)
    end

    context 'when the users exist and the parameters are valid' do

      it 'is successful' do
        subject
        expect(response).to be_successful
      end

      it 'returns no content' do
        subject
        expect(response.body).to be_empty
      end
    end

    context 'when the sender does not exist' do
      let(:user_id) { 0 }

      it 'returns a not found code' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error' do
        subject
        expect(json(response)[:error]).to match(/not found/)
      end
    end

    context 'when the receiver does not exist' do
      let(:friend_id) { 0 }

      it 'returns a not found code' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error' do
        subject
        expect(json(response)[:error]).to match(/not found/)
      end
    end

    context 'when the amount is invalid' do
      let(:amount) { 1001 }

      it 'returns an unprocessable entity error' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the validation errors' do
        subject
        expect(json(response)[:errors][:amount]).to include('must be between 0 and 1000')
      end
    end
  end

  context 'when the users are not friends' do
    it 'returns a not found code' do
      subject
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error' do
      subject
      expect(json(response)[:error]).to match(/not found/)
    end
  end
end
