require "rails_helper"

RSpec.describe "devise/shared/_messages.html.haml", type: :view do
  context 'for the flash errors' do
    context 'when there is an error' do
      context 'for the sign up error' do
        it "renders the modal" do
          flash[:show_modal_user] = true
          flash[:modal_message] = t("messages.user_register_request_sent_message")

          render "devise/shared/messages", resource: nil

          expect(rendered).to include(I18n.t("messages.user_register_request_sent_message"))
        end
      end
      context 'for the edit user error' do
        it "renders the modal" do
          flash[:show_modal_user] = true
          flash[:modal_message] = I18n.t("messages.user_edited")

          render "devise/shared/messages", resource: nil

          expect(rendered).to include(I18n.t("messages.user_edited"))
        end
      end
    end
    context 'when there is no error' do
      it "does not render the modal" do
        render "devise/shared/messages", resource: nil

        expect(rendered).to be_empty
      end
    end
  end
  context 'for the flash messages' do
    context 'for the expense create' do
      it "renders the modal" do
        flash[:show_modal_expense_created] = true
        flash[:modal_message] = I18n.t("messages.refound_request_sent")

        render "devise/shared/messages", resource: nil

        expect(rendered).to include(I18n.t("messages.refound_request_sent"))
      end
    end
  end
end
