require "rails_helper"

RSpec.describe "pages/hemo.html.haml", type: :view do
  let!(:employee) { FactoryBot.build_stubbed(:user, :employee, name: "Test Employee") }
  let!(:manager) { FactoryBot.build_stubbed(:user, :manager, name: "Test Manager") }
  context 'for the home screen' do
    context 'for the user greetings title' do
      it "renders the user greetings" do
        allow(view).to receive(:current_user).and_return(employee)
        render template: "pages/home"

        expect(rendered).to have_css("h2#user_greeting.title-text")
      end
      it "renders the expected text" do
        allow(view).to receive(:current_user).and_return(employee)
        render template: "pages/home"
        
        expect(rendered).to have_selector("h2", text: "Bem vindo(a), #{employee.name}!")
      end
    end

    context 'for the pending expenses' do
      context 'for the section title' do
        context 'for an employee' do
          it "renders the title" do
            allow(view).to receive(:current_user).and_return(employee)
            render template: "pages/home"
            
            expect(rendered).to have_css("#expenses-section h3#expenses-title.section-title-text")
          end
          it "renders the expected text" do
            allow(view).to receive(:current_user).and_return(employee)
            render template: "pages/home"
            
            expect(rendered).to have_selector("h3", text: t('titles.my_pending_expenses'))
          end
        end
        context 'for a manager' do
          it "renders the title" do
            allow(view).to receive(:current_user).and_return(manager)
            render template: "pages/home"
            
            expect(rendered).to have_css("#expenses-section h3#expenses-title.section-title-text")
          end
          it "renders the expected text" do
            allow(view).to receive(:current_user).and_return(manager)
            render template: "pages/home"
            
            expect(rendered).to have_selector("h3", text: t('titles.pending_expenses_section'))
          end
        end
      end

      context 'for the all pending expenses box' do
        it "renders the box" do
          allow(view).to receive(:current_user).and_return(employee)
          render template: "pages/home"
          
          expect(rendered).to have_css("#expenses-section .regular-container #all-expenses-box.regular-box")
        end

        context 'for the box title' do
          it "renders the title" do
            allow(view).to receive(:current_user).and_return(employee)
            render template: "pages/home"
            
            expect(rendered).to have_css("#expenses-section .regular-container #all-expenses-box h4#all-expenses-title.subtitle-text")
          end
          it "renders the expected text" do
            allow(view).to receive(:current_user).and_return(employee)
            render template: "pages/home"
            
            expect(rendered).to have_selector("h4", text: t('titles.all_pending_expenses'))
          end
        end

        it "renders the number" do
          allow(view).to receive(:current_user).and_return(employee)
          render template: "pages/home"
          
          expect(rendered).to have_css("#expenses-section .regular-container #all-expenses-box p#all-expenses-number.indicator-text")
        end
      end

      context 'for the todays pending expenses box' do
        it "renders the box" do
          allow(view).to receive(:current_user).and_return(employee)
          render template: "pages/home"
          
          expect(rendered).to have_css("#expenses-section .regular-container #todays-expenses-box.regular-box")
        end

        context 'for the box title' do
          it "renders the title" do
            allow(view).to receive(:current_user).and_return(employee)
            render template: "pages/home"
            
            expect(rendered).to have_css("#expenses-section .regular-container #todays-expenses-box h4#todays-expenses-title.subtitle-text")
          end
          it "renders the expected text" do
            allow(view).to receive(:current_user).and_return(employee)
            render template: "pages/home"
            
            expect(rendered).to have_selector("h4", text: t('titles.todays_pending_expenses'))
          end
        end

        it "renders the number" do
          allow(view).to receive(:current_user).and_return(employee)
          render template: "pages/home"
          
          expect(rendered).to have_css("#expenses-section .regular-container #todays-expenses-box p#todays-expenses-number.indicator-text")
        end
      end

      context 'for the week pending expenses box' do
        it "renders the box" do
          allow(view).to receive(:current_user).and_return(employee)
          render template: "pages/home"
          
          expect(rendered).to have_css("#expenses-section .regular-container #week-expenses-box.regular-box")
        end

        context 'for the box title' do
          it "renders the title" do
            allow(view).to receive(:current_user).and_return(employee)
            render template: "pages/home"
            
            expect(rendered).to have_css("#expenses-section .regular-container #week-expenses-box h4#week-expenses-title.subtitle-text")
          end
          it "renders the expected text" do
            allow(view).to receive(:current_user).and_return(employee)
            render template: "pages/home"
            
            expect(rendered).to have_selector("h4", text: t('titles.week_pending_expenses'))
          end
        end

        it "renders the number" do
          allow(view).to receive(:current_user).and_return(employee)
          render template: "pages/home"
          
          expect(rendered).to have_css("#expenses-section .regular-container #week-expenses-box p#week-expenses-number.indicator-text")
        end
      end
    end
    it "renders with the correct structure" do
      allow(view).to receive(:current_user).and_return(employee)
      render template: "pages/home"
      
      expect(rendered).to have_css("div.main-top")
      expect(rendered).to have_css("div.main-top #expenses-section")
      expect(rendered).to have_css("div.main-top #expenses-section .regular-container")
    end
  end
end
