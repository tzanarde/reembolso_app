require "rails_helper"

RSpec.describe "shared/_modal_confirm.html.haml", type: :view do
  context 'for a confirm modal' do
    before do
      render partial: "shared/modal_confirm", locals: { message_text: "Mensagem",
                                                        button_id: "test-modal",
                                                        button_text: "Confirmar",
                                                        button_route: "/test-route" }
    end

    it "renders with the correct text" do
      expect(rendered).to have_css("p.regular-text", text: "Mensagem", exact_text: true)
    end

    it "renders with a confirm button" do
      expect(rendered).to have_selector("a", text: "Confirmar", exact_text: true)
      expect(rendered).to have_css("a#test-modal")
      expect(rendered).to have_css("a.btn.btn-primary.btn-full-width")
      expect(rendered).to have_link(href: "/test-route")
    end

    it "renders with the correct structure" do
      expect(rendered).to have_css("div.main")
    end
  end
end
