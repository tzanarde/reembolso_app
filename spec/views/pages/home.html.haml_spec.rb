require "rails_helper"

RSpec.describe "pages/hemo.html.haml", type: :view do
  let(:user) { FactoryBot.build_stubbed(:user, :employee, name: "Test User") }
  
  context 'for the home screen' do
    before do
      allow(view).to receive(:current_user).and_return(user)

      render template: "pages/home"
    end

    context 'for the user greetings title' do
      it "renders the user greetings" do
        expect(rendered).to have_css("h2#user_greeting.title-text")
      end
      it "renders the expected text" do
        expect(rendered).to have_selector("h2", text: "Bem vindo(a), #{user.name}!")
      end
    end

    context 'for the pending expenses' do
      context 'for the section title' do
        it "renders the title" do
          expect(rendered).to have_css("#expenses-section h3#expenses-title.section-title-text")
        end
        it "renders the expected text" do
          expect(rendered).to have_selector("h3", text: t('titles.pending_expenses_section'))
        end
      end

      context 'for the all pending expenses box' do
        it "renders the box" do
          expect(rendered).to have_css("#expenses-section .regular-container #all-expenses-box.regular-box")
        end

        context 'for the box title' do
          it "renders the title" do
            expect(rendered).to have_css("#expenses-section .regular-container #all-expenses-box h4#all-expenses-title.subtitle-text")
          end
          it "renders the expected text" do
            expect(rendered).to have_selector("h4", text: t('titles.all_pending_expenses'))
          end
        end

        it "renders the number" do
          expect(rendered).to have_css("#expenses-section .regular-container #all-expenses-box p#all-expenses-number.indicator-text")
        end
      end

      context 'for the todays pending expenses box' do
        it "renders the box" do
          expect(rendered).to have_css("#expenses-section .regular-container #todays-expenses-box.regular-box")
        end

        context 'for the box title' do
          it "renders the title" do
            expect(rendered).to have_css("#expenses-section .regular-container #todays-expenses-box h4#todays-expenses-title.subtitle-text")
          end
          it "renders the expected text" do
            expect(rendered).to have_selector("h4", text: t('titles.todays_pending_expenses'))
          end
        end

        it "renders the number" do
          expect(rendered).to have_css("#expenses-section .regular-container #todays-expenses-box p#todays-expenses-number.indicator-text")
        end
      end

      context 'for the week pending expenses box' do
        it "renders the box" do
          expect(rendered).to have_css("#expenses-section .regular-container #week-expenses-box.regular-box")
        end

        context 'for the box title' do
          it "renders the title" do
            expect(rendered).to have_css("#expenses-section .regular-container #week-expenses-box h4#week-expenses-title.subtitle-text")
          end
          it "renders the expected text" do
            expect(rendered).to have_selector("h4", text: t('titles.week_pending_expenses'))
          end
        end

        it "renders the number" do
          expect(rendered).to have_css("#expenses-section .regular-container #week-expenses-box p#week-expenses-number.indicator-text")
        end
      end
    end

    # context 'for the delete user button' do
    #   it "renders the button" do
    #     expect(rendered).to have_button(t("buttons.delete_user"))
    #     expect(rendered).to have_css("button.btn.btn-primary.btn-full-width")
    #   end

    #   it "points to the correct route" do
    #     form_action = "/users"

    #     expect(rendered).to have_css("form[action='#{form_action}'][method='post']") do |form|
    #       expect(form).to have_css("input[name='_method'][value='delete']", visible: false)
    #     end
    #   end
    # end

    it "renders with the correct structure" do
      expect(rendered).to have_css("div.main-top")
      expect(rendered).to have_css("div.main-top #expenses-section")
      expect(rendered).to have_css("div.main-top #expenses-section .regular-container")
    end
  end
end
