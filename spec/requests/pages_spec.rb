require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /home" do
    let(:user) { FactoryBot.build_stubbed(:user, :employee) }

    before do
      sign_in user
    end

    context 'for the page home' do
      it "returns http success" do
        get "/pages/home"
        expect(response).to have_http_status(:success)
      end
    end

    context 'for the page user menu' do
      it "returns http success" do
        get "/user_menu"
        expect(response).to have_http_status(:success)
      end
    end
  end

end
