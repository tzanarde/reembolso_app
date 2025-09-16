require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    context "with a valid user" do
      let(:valid_attributes) { attributes_for(:user, :manager, password: '123456', password_confirmation: '123456') }
      it "creates a new user and defines the flash" do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)

        expect(flash[:show_modal_user]).to be(true)
        expect(flash[:modal_message]).to eq(I18n.t("messages.user_register_request_sent_message"))
      end

      it "redirects to root_path after the registration" do
        post :create, params: { user: valid_attributes }

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH #update" do
    context "with a valid user" do
      let(:user) { create(:user, :manager, password: '123456', password_confirmation: '123456') }
      context "with valid information to update" do
        let(:valid_attributes) { attributes_for(:user, :manager, email: 'new@email.com', password: '123456', password_confirmation: '123456', current_password: '123456') }
        context 'whe the user is logged in' do
          before { sign_in user }
          it "updates the user and defines the flash" do
            post :update, params: { user: valid_attributes }

            expect(flash[:show_modal_user]).to be(true)
            expect(flash[:modal_message]).to eq(I18n.t("messages.user_edited"))
          end

          it "redirects to root_path after the update" do
            post :update, params: { user: valid_attributes }
            
            expect(response).to redirect_to(root_path)
          end
        end
      end
    end
  end
end