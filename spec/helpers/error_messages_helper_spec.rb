require 'rails_helper'

RSpec.describe ErrorMessagesHelper do
  include ErrorMessagesHelper
  include RSpec::Rails::Matchers
  include FactoryBot::Syntax::Methods

  describe "#error_message" do
    context 'with a resource' do
      let!(:user) { build(:user, :manager) }
      context 'with an error' do
        context "for general errors" do
          before { user.errors.add(:email, :not_found) }

          it "returns the correct error message" do
            expect(error_message(user)).to eq(I18n.t('errors.forms.user_sign_up.email.not_found'))
          end
        end
        context "for password errors" do
          before { user.errors.add(:password_confirmation, :confirmation) }

          it "returns the correct error message" do
            expect(error_message(user)).to eq(I18n.t('errors.forms.user_sign_up.password.not_match'))
          end
        end
        context "for role errors" do
          before { user.errors.add(:role, :inclusion) }

          it "returns the correct error message" do
            expect(error_message(user)).to eq(I18n.t('errors.forms.user_sign_up.role.blank'))
          end
        end
      end
      context 'without an error' do
        it "returns no message" do
          expect(error_message(user)).to be_nil
        end
      end
    end
  end
end