require "rails_helper"

RSpec.describe "shared/_modal_confirm.html.haml", type: :view do
  context 'for a confirm modal' do
    before do
      render partial: "shared/modal_confirm", locals: { message_text: "Mensagem",
                                                        button_id: "test-modal",
                                                        button_text: "Confirmar" }
    end

    it "renders with the correct text" do
      expect(rendered).to have_css("p.regular-text", text: "Mensagem", exact_text: true)
    end

    it "renders with a confirm button" do
      expect(rendered).to have_selector("button", text: "Confirmar", exact_text: true)
      expect(rendered).to have_css("button#test-modal")
      expect(rendered).to have_css("button.btn.btn-confirm.btn-full-width")
    end

    it "renders with the correct structure" do
      expect(rendered).to have_css("div.modal")
    end
  end
end
