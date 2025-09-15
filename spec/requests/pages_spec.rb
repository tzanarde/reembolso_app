require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /home" do
    let(:user) { FactoryBot.build_stubbed(:user, :employee) }

    context 'for the page home' do
      context 'when the user is logged in' do
        it "returns http success" do
          sign_in user
          get "/pages/home"

          expect(response).to have_http_status(:success)
        end
      end

      context 'when the user is logged out' do
        it "returns found status code and redirects to login" do
          get "/pages/home"
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    context 'for the page user menu' do
      context 'when the user is logged in' do
        it "returns http success" do
          sign_in user

          get "/user_menu"
          expect(response).to have_http_status(:success)
        end
      end

      context 'when the user is logged out' do
        it "returns found status code and redirects to login" do
          get "/user_menu"
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end

end
