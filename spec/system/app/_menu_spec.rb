require "rails_helper"

RSpec.describe "shared/_menu.html.haml", type: :view do
  include Devise::Test::ControllerHelpers

  context 'for the main menu bar' do
    let!(:manager) { create(:user, :manager) }
    let!(:employee) { create(:user, :employee, manager_user_id: manager.id) }

    it "renders the menu container" do
      allow(view).to receive(:current_user).and_return(employee)
      render partial: "shared/menu"
      
      expect(rendered).to have_css("div#menu-container")
    end

    it "renders the menu" do
      allow(view).to receive(:current_user).and_return(employee)
      render partial: "shared/menu"

      expect(rendered).to have_css("div#menu")
    end

    it "renders the home item" do
      allow(view).to receive(:current_user).and_return(employee)
      render partial: "shared/menu"

      expect(rendered).to have_css("div.menu-item")
      expect(rendered).to have_css("div.menu-item img[src*='home'][alt='#{t("images_alt.home")}']")
      expect(rendered).to have_css("a#home-item[href='/']")
    end

    it "renders the pending expenses item" do
      allow(view).to receive(:current_user).and_return(employee)
      render partial: "shared/menu"

      expect(rendered).to have_css("div.menu-item")
      expect(rendered).to have_css("div.menu-item img[src*='pending_expenses'][alt='#{t("images_alt.pending_expenses")}']")
      expect(rendered).to have_css("a#pending-expenses-item[href='#{expenses_path(type: "pending")}']")
    end

    it "renders the expenses history item" do
      allow(view).to receive(:current_user).and_return(employee)
      render partial: "shared/menu"

      expect(rendered).to have_css("div.menu-item")
      expect(rendered).to have_css("div.menu-item img[src*='expenses_history'][alt='#{t("images_alt.expenses_history")}']")
      expect(rendered).to have_css("a#expenses-history-item[href='#{expenses_path(type: "history")}']")
    end

    context 'for the add expense item' do
      context 'for an employee' do
        it "renders the add expense item" do
          allow(view).to receive(:current_user).and_return(employee)
          render partial: "shared/menu"

          expect(rendered).to have_css("div.menu-item")
          expect(rendered).to have_css("div.menu-item img[alt='#{t("images_alt.add_expense")}']")
          expect(rendered).to have_css("a#add-expense-item[href='#{new_expense_path}']")
        end
      end
      context 'for a manager' do
        it "does not render the add expense item" do
          allow(view).to receive(:current_user).and_return(manager)
          render partial: "shared/menu"

          expect(rendered).not_to have_css("div.menu-item img[alt='#{t("images_alt.add_expense")}']")
          expect(rendered).not_to have_css("a#add-expense-item[href='#{new_expense_path}']")
        end
      end
    end

    it "renders the user item" do
      allow(view).to receive(:current_user).and_return(employee)
      render partial: "shared/menu"

      expect(rendered).to have_css("div.menu-item")
      expect(rendered).to have_css("div.menu-item img[src*='user'][alt='#{t("images_alt.user")}']")
      expect(rendered).to have_css("a#user-item[href='/user_menu']")
    end

    context 'for an employee' do
      it "render all the vertical dividers" do
        allow(view).to receive(:current_user).and_return(employee)
        render partial: "shared/menu"

        expect(rendered).to have_css("div.vertical-divider", count: 4)
      end
    end

    context 'for a manager' do
      it "render all the vertical dividers" do
        allow(view).to receive(:current_user).and_return(manager)
        render partial: "shared/menu"

        expect(rendered).to have_css("div.vertical-divider", count: 3)
      end
    end

    it "renders with the correct structure" do
      allow(view).to receive(:current_user).and_return(employee)
      render partial: "shared/menu"

      expect(rendered).to have_css("div#menu-container #menu")
    end
  end
end
