require "rails_helper"

RSpec.describe "pages/user_menu.html.haml", type: :view do
  context 'for the user menu' do
    before do
      user = FactoryBot.build_stubbed(:user, :employee, name: "Test User")
      allow(view).to receive(:current_user).and_return(user)

      render template: "pages/user_menu"
    end

    context 'for the edit user button' do
      it "renders the button" do
        expect(rendered).to have_css("button.btn.btn-primary.btn-full-width")
      end

      it "points to the correct route" do
        expect(rendered).to have_link(I18n.t("buttons.edit_user"), href: 'users/edit')
      end
    end

    context 'for the delete user button' do
      it "renders the button" do
        expect(rendered).to have_button(t("buttons.delete_user"))
        expect(rendered).to have_css("button.btn.btn-primary.btn-full-width")
      end

      it "points to the correct route" do
        form_action = "/users"

        expect(rendered).to have_css("form[action='#{form_action}'][method='post']") do |form|
          expect(form).to have_css("input[name='_method'][value='delete']", visible: false)
        end
      end
    end

    context 'for the logout button' do
      it "renders the button" do
        expect(rendered).to have_button(t("buttons.logout"))
        expect(rendered).to have_css("button.btn.btn-primary.btn-full-width")
      end

      it "points to the correct route" do
        form_action = "/users/sign_out"

        expect(rendered).to have_css("form[action='#{form_action}'][method='post']") do |form|
          expect(form).to have_css("input[name='_method'][value='delete']", visible: false)
        end
      end
    end

    it "renders with the correct structure" do
      expect(rendered).to have_css("div.main-center div.container.container-primary.container-center-md")
    end
  end
end
