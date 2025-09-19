require "rails_helper"
include MatchHelpers
include FillFormHelpers

RSpec.describe "Sign in", type: :system do
  context 'when the user is logged out' do
    context 'for both employee and manager' do
      context 'for the login form' do
        let!(:user) { create(:user, :manager) }
        context 'with valid information' do
          it "allows a user to sign in" do
            visit new_user_session_path

            fill_form_sign_in(email: user.email,
                              password: user.password)

            click_button "sign_in"

            expect(page).to have_content(I18n.t("titles.welcome", name: user.name))
          end
        end
        context 'with invalid information' do
          context 'for an invalid email' do
            context 'when the email does not match' do
              it "does not allow a user to sign in" do
                visit new_user_session_path

                fill_form_sign_in(email: 'a@email.com',
                                  password: user.password)

                click_button "sign_in"

                expect(page).to have_content(I18n.t("errors.forms.user_sign_in.invalid_credentials"))
              end
            end
            context 'when the email is blank' do
              it "does not allow a user to sign in" do
                visit new_user_session_path

                fill_form_sign_in(password: user.password)

                click_button "sign_in"

                expect(page).to have_content(I18n.t("errors.forms.user_sign_in.invalid_credentials"))
              end
            end
          end
          context 'for an invalid password' do
            context 'when the password does not match' do
              it "does not allow a user to sign in" do
                visit new_user_session_path

                fill_form_sign_in(email: user.email,
                                  password: 'aaaaaa')

                click_button "sign_in"

                expect(page).to have_content(I18n.t("errors.forms.user_sign_in.invalid_credentials"))
              end
            end
          end
          context 'when the password is blank' do
            it "does not allow a user to sign in" do
              visit new_user_session_path

              fill_form_sign_in(email: user.email)

              click_button "sign_in"

              expect(page).to have_content(I18n.t("errors.forms.user_sign_in.invalid_credentials"))
            end
          end
        end
      end
      context 'for the buttons' do
        context 'for the sign up button' do
          it "redirects user to the sign up page" do
            visit new_user_session_path

            click_link "sign_up"

            expect(page).to have_current_path(new_user_registration_path)
            expect(page).to have_content(I18n.t("titles.sign_up"))
          end
        end
        context 'for the forgot password button' do
          it "redirects user to the forgot password page" do
            visit new_user_session_path

            click_link "forgot_password"

            expect(page).to have_current_path(new_user_password_path)
            expect(page).to have_content(I18n.t("titles.forgot_password"))
          end
        end
      end
    end
  end
end
