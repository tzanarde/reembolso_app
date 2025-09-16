require "rails_helper"
include MatchHelpers

RSpec.describe "Forgot Password", type: :system do
  before do
    Rails.application.routes.default_url_options[:host] = 'localhost:3000'
  end
  let!(:user) { create(:user, :manager) }
  context 'when the user is logged out' do
    context 'for both employee and manager' do
      context 'for the forgot password form' do
        context 'with valid information' do
          it "allows a user to request a password change" do
            visit new_user_password_path

            fill_form_forgot_password(email: user.email)

            click_button 'send_instructions'

            expect(page).to have_content(I18n.t('devise.passwords.send_instructions'))
          end
        end
        context 'with invalid information' do
          context 'fot an invalid email' do
            it "does not allow a user to request a password change" do
              visit new_user_password_path

              fill_form_forgot_password(email: 'a@email.com')

              click_button 'send_instructions'

              expect(page).to have_content(I18n.t('errors.forms.user_sign_up.email.not_found'))
            end
          end
        end
      end
    end
    context 'for the buttons' do
      context 'for the sign in button' do
        it "redirects user to the login page" do
          visit new_user_password_path

          click_link "login"

          expect(page).to have_current_path(new_user_session_path)
          expect(page).to have_content(I18n.t("titles.app"))
        end
      end
      context 'for the sign up button' do
        it "redirects user to the sign up page" do
          visit new_user_password_path

          click_link "sign_up"

          expect(page).to have_current_path(new_user_registration_path)
          expect(page).to have_content(I18n.t("titles.sign_up"))
        end
      end
    end
  end
  context 'when the user is logged in' do
    before { login_as(user, scope: :user) }
    it "redirects user to the home page" do
      visit new_user_password_path

      expect(page).to have_current_path(root_path)
      expect(page).to have_content(I18n.t("titles.welcome", name: user.name))
    end
  end
end