require "rails_helper"
include MatchHelpers
include FillFormHelpers

RSpec.describe "Sign up", type: :system do
  context 'for both employee and manager registrations' do
    context 'with valid information' do
      it "allows a user to sign up" do
        visit new_user_registration_path

        fill_form_sign_up(name: "Tiago",
                          email: "tiago@test.com",
                          password: "123456",
                          password_confirmation: "123456",
                          user_role: "Gestor")

        click_button "sign_up"

        expect(page).to have_content(I18n.t("messages.user_register_request_sent_message"))
      end
    end
    context 'with invalid information' do
      context 'for the name field' do
        context 'when the field is blank' do
          it "does not allow a user to sign up" do
            visit new_user_registration_path

            fill_form_sign_up(email: "tiago@test.com",
                              password: "123456",
                              password_confirmation: "123456",
                              user_role: "Gestor")

            click_button "sign_up"

            expect(page).to have_content(I18n.t("errors.forms.user_sign_up.name.blank"))
          end
        end

        context 'when the field is too long' do
          it "does not allow a user to sign up" do
            visit new_user_registration_path

            fill_form_sign_up(name: "aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeef",
                              email: "tiago@test.com",
                              password: "123456",
                              password_confirmation: "123456",
                              user_role: "Gestor")

            click_button "sign_up"

            expect(page).to have_content(I18n.t("errors.forms.user_sign_up.name.too_long"))
          end
        end
      end

      context 'for the email field' do
        context 'when the field is blank' do
          it "does not allow a user to sign up" do
            visit new_user_registration_path

            fill_form_sign_up(name: "Tiago",
                              password: "123456",
                              password_confirmation: "123456",
                              user_role: "Gestor")

            click_button "sign_up"

            expect(page).to have_content(I18n.t("errors.forms.user_sign_up.email.blank"))
          end
        end

        context 'when the field is too long' do
          it "does not allow a user to sign up" do
            visit new_user_registration_path

            fill_form_sign_up(name: "Tiago",
                              email: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@bbbbbbbbbb.com",
                              password: "123456",
                              password_confirmation: "123456",
                              user_role: "Gestor")

            click_button "sign_up"

            expect(page).to have_content(I18n.t("errors.forms.user_sign_up.email.too_long"))
          end
        end
      end

      context 'for the password fields' do
        context 'when the password field is blank' do
          it "does not allow a user to sign up" do
            visit new_user_registration_path

            fill_form_sign_up(name: "Tiago",
                              email: "tiago@email.com",
                              password_confirmation: "123456",
                              user_role: "Gestor")

            click_button "sign_up"

            expect(page).to have_content(I18n.t("errors.forms.user_sign_up.password.blank"))
          end
        end

        context 'when the password confirmation does not match the provided password field' do
          it "does not allow a user to sign up" do
            visit new_user_registration_path

            fill_form_sign_up(name: "Tiago",
                              email: "tiago@email.com",
                              password: "123456",
                              password_confirmation: "1234567",
                              user_role: "Gestor")

            click_button "sign_up"

            expect(page).to have_content(I18n.t("errors.forms.user_sign_up.password.not_match"))
          end
        end

        context 'when the password fields are too short' do
          it "does not allow a user to sign up" do
            visit new_user_registration_path

            fill_form_sign_up(name: "Tiago",
                              email: "tiago@email.com",
                              password: "123",
                              password_confirmation: "123",
                              user_role: "Gestor")

            click_button "sign_up"

            expect(page).to have_content(I18n.t("errors.forms.user_sign_up.password.too_short"))
          end
        end
      end
    
      context 'for the user role fields' do
        context 'when the user role select is blank' do
          it "does not allow a user to sign up" do
            visit new_user_registration_path

            fill_form_sign_up(name: "Tiago",
                              email: "tiago@email.com",
                              password: "123456",
                              password_confirmation: "123456")

            click_button "sign_up"

            expect(page).to have_content(I18n.t("errors.forms.user_sign_up.role.blank"))
          end
        end
      end
    end
  end
  context 'only for an employee registration' do
    context 'for the user role fields' do
      context 'when the user role select is set to employee and the manager select is blank' do
        it "does not allow a user to sign up" do
          visit new_user_registration_path

          fill_form_sign_up(name: "Tiago",
                            email: "tiago@email.com",
                            password: "123456",
                            password_confirmation: "123456",
                            user_role: "Funcionário")

          click_button "sign_up"

          expect(page).to have_content(I18n.t("errors.forms.user_sign_up.manager_user_id.blank"))
        end
      end
    end
  end
end