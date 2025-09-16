require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    context "with a valid user" do
      let(:user) { create(:user, :manager) }
      context "with a valid email to request password change" do
        let(:valid_attributes) { { email: user.email } }
        it "creates a password change request and defines the flash" do
          post :create, params: { user: valid_attributes }

          expect(flash[:show_modal_forgot_password]).to be(true)
          expect(flash[:modal_message]).to eq(I18n.t("devise.passwords.send_instructions"))
        end

        it "redirects to root_path after the request" do
          post :create, params: { user: valid_attributes }

          expect(response).to redirect_to(new_user_session_path)
        end
      end
      context "with an invalid email to request password change" do
        let(:invalid_attributes) { { email: 'a@email.com' } }
        it "does not create a password change request and defines the flash" do
          post :create, params: { user: invalid_attributes }

          expect(flash[:show_modal_forgot_password]).to be_nil
          expect(flash[:modal_message]).to be_nil
        end

        it "redirects to root_path after the request" do
          post :create, params: { user: invalid_attributes }

          expect(response).to render_template(:new)
        end
      end
    end
  end
end