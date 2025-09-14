require "rails_helper"

RSpec.describe "shared/_modal_question.html.haml", type: :view do
  context 'for a question modal' do
    before do
      render partial: "shared/modal_question", locals: { message_text: "Mensagem",
                                                         button_yes_id: "test-modal-yes",
                                                         button_no_id: "test-modal-no",
                                                         button_yes_text: "Sim",
                                                         button_no_text: "Não",
                                                         button_yes_route: "/test-route" }
    end

    it "renders with the correct text" do
      expect(rendered).to have_css("p.regular-text", text: "Mensagem", exact_text: true)
    end

    it "renders with a yes button" do
      expect(rendered).to have_selector("button", text: "Sim", exact_text: true)
      expect(rendered).to have_css("button#test-modal-yes")
      expect(rendered).to have_css("button.btn.btn-confirm.btn-half-width")
    end

    it "renders with a no button" do
      expect(rendered).to have_selector("button", text: "Não", exact_text: true)
      expect(rendered).to have_css("button#test-modal-no")
      expect(rendered).to have_css("button.btn.btn-cancel.btn-half-width")
    end

    it "renders with the correct structure" do
      expect(rendered).to have_css("div.main")
    end
  end
end
