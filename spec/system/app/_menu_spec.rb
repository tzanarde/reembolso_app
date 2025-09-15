require "rails_helper"

RSpec.describe "shared/_menu.html.haml", type: :view do
  context 'for the main menu bar' do
    before do
      render partial: "shared/menu"
    end

    it "renders the menu container" do
      expect(rendered).to have_css("div#menu-container")
    end

    it "renders the menu" do
      expect(rendered).to have_css("div#menu")
    end

    it "renders the home item" do
      expect(rendered).to have_css("div.menu-item")
      expect(rendered).to have_css("div.menu-item img[src*='home'][alt='#{t("images_alt.home")}']")
      expect(rendered).to have_css("a#home-item[href='/']")
    end

    it "renders the pending expenses item" do
      expect(rendered).to have_css("div.menu-item")
      expect(rendered).to have_css("div.menu-item img[src*='pending_expenses'][alt='#{t("images_alt.pending_expenses")}']")
      expect(rendered).to have_css("a#pending-expenses-item[href='/']")
    end

    it "renders the expenses history item" do
      expect(rendered).to have_css("div.menu-item")
      expect(rendered).to have_css("div.menu-item img[src*='expenses_history'][alt='#{t("images_alt.expenses_history")}']")
      expect(rendered).to have_css("a#expenses-history-item[href='/']")
    end

    it "renders the user item" do
      expect(rendered).to have_css("div.menu-item")
      expect(rendered).to have_css("div.menu-item img[src*='user'][alt='#{t("images_alt.user")}']")
      expect(rendered).to have_css("a#user-item[href='/']")
    end

    it "render all the vertical dividers" do
      expect(rendered).to have_css("div.vertical-divider", count: 3)
    end

    it "renders with the correct structure" do
      expect(rendered).to have_css("div#menu-container #menu")
    end
  end
end
