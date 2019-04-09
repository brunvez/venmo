require 'rails_helper'

describe 'GET api/v1/user/:user_id/feed/', type: :request do
  let(:user) { create(:user) }
  let!(:other_payment) { create(:payment) }
  let!(:payments) { create_list(:payment, 5, sender: user) + create_list(:payment, 6, receiver: user) }
  let(:parameters) { {} }

  subject { get api_v1_feed_path(user.id, parameters), as: :json }

  context 'without a page param' do

    it 'is successful' do
      subject
      expect(response).to be_successful
    end

    it 'returns at most 10 items ordered by creation date' do
      subject
      item_ids = json(response)[:feed][:payments].map { |p| p[:id] }
      expect(item_ids).to match_array(payments.last(10).map(&:id))
    end
  end

  context 'with a page param' do
    let(:parameters) { { page: 2 } }

    it 'is successful' do
      subject
      expect(response).to be_successful
    end

    it 'returns items on the second page' do
      subject
      items = json(response)[:feed][:payments]
      expect(items.length).to eq(1)
    end
  end
end
