require "rails_helper"

RSpec.describe "pages/user_menu.html.haml", type: :view do
  context 'for the user menu' do
    let!(:employee) { FactoryBot.build_stubbed(:user, :employee, name: "Test Employee") }
    let!(:manager) { FactoryBot.build_stubbed(:user, :manager, name: "Test Manager") }
    context 'for the edit user button' do
      it "renders the button" do
        allow(view).to receive(:current_user).and_return(employee)
        render template: "pages/user_menu"
        
        expect(rendered).to have_css("button.btn.btn-primary.btn-full-width")
      end

      it "points to the correct route" do
        allow(view).to receive(:current_user).and_return(employee)
        render template: "pages/user_menu"

        expect(rendered).to have_link(I18n.t("buttons.edit_user"), href: 'users/edit')
      end
    end

    context 'for the delete user button' do
      context 'for an employee' do
        it "renders the button" do
          allow(view).to receive(:current_user).and_return(employee)
          render template: "pages/user_menu"

          expect(rendered).to have_button(t("buttons.delete_user"))
          expect(rendered).to have_css("button.btn.btn-primary.btn-full-width")
        end

        it "points to the correct route" do
          allow(view).to receive(:current_user).and_return(employee)
          render template: "pages/user_menu"

          form_action = "/users"

          expect(rendered).to have_css("form[action='#{form_action}'][method='post']") do |form|
            expect(form).to have_css("input[name='_method'][value='delete']", visible: false)
          end
        end
      end
      context 'for a manager' do
        it "does not render the button" do
          allow(view).to receive(:current_user).and_return(manager)
          render template: "pages/user_menu"

          expect(rendered).not_to have_button(t("buttons.delete_user"))
          expect(rendered).to have_css("button.btn.btn-primary.btn-full-width", count: 1)
        end
      end
    end

    context 'for the logout button' do
      it "renders the button" do
        allow(view).to receive(:current_user).and_return(employee)
        render template: "pages/user_menu"

        expect(rendered).to have_button(t("buttons.logout"))
        expect(rendered).to have_css("button.btn.btn-primary.btn-full-width")
      end

      it "points to the correct route" do
        allow(view).to receive(:current_user).and_return(employee)
        render template: "pages/user_menu"
        
        form_action = "/users/sign_out"

        expect(rendered).to have_css("form[action='#{form_action}'][method='post']") do |form|
          expect(form).to have_css("input[name='_method'][value='delete']", visible: false)
        end
      end
    end

    it "renders with the correct structure" do
      allow(view).to receive(:current_user).and_return(employee)
      render template: "pages/user_menu"

      expect(rendered).to have_css("div.main-center div.container.container-primary.container-center-sm")
    end
  end
end
