require "rails_helper"

RSpec.describe "devise/shared/_error_messages.html.haml", type: :view do
  context 'for the resource errors' do
    context 'when there is an error' do
      let!(:user) { build(:user, :manager, email: nil) }
      it "renders the modal" do
        user.valid?

        render "devise/shared/error_messages", resource: user

        expect(rendered).to include(I18n.t("errors.forms.user_sign_up.email.blank"))
      end
    end
    context 'when there is no error' do
      let!(:user) { build(:user, :manager) }
      it "does not render the modal" do
        user.valid?

        render "devise/shared/error_messages", resource: user

        expect(rendered).to be_empty
      end
    end
  end

  context 'for the flash errors' do
    context 'when there is an error' do
      context 'for the unauthenticated error' do
        it "renders the modal" do
          flash[:alert] = I18n.t('devise.failure.unauthenticated')

          render "devise/shared/error_messages", resource: nil

          expect(rendered).to include(I18n.t('devise.failure.unauthenticated'))
        end
      end
      context 'for the invalid field error' do
        it "renders the modal" do
          flash[:alert] = I18n.t('devise.failure.invalid', authentication_keys: 'Email')

          render "devise/shared/error_messages", resource: nil

          expect(rendered).to include(I18n.t("errors.forms.user_sign_in.invalid_credentials"))
        end
      end
    end
    context 'when there is no error' do
      it "does not render the modal" do
        render "devise/shared/error_messages", resource: nil

        expect(rendered).to be_empty
      end
    end
  end
end
