require 'rails_helper'

RSpec.describe "expenses/index.html.haml", type: :view do
  include Devise::Test::ControllerHelpers

  context 'for employee or manager' do
    context 'when user is logged in' do
      let!(:manager) { create(:user, :manager) }
      let!(:employee) { create(:user, :employee, manager_user_id: manager.id) }
      context 'for pending expenses' do
        let!(:pending_expenses) do
          [
            create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 1, user: employee, amount: 10.00),
            create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 2, user: employee, amount: 20.00)
          ]
        end
        let!(:history_expenses) do
          [
            create(:expense, :approved, :with_tags, :with_nf_file, :with_card_file, tags_count: 1, user: employee, amount: 10.00),
            create(:expense, :declined, :with_tags, :with_nf_file, :with_card_file, tags_count: 2, user: employee, amount: 20.00)
          ]
        end
        let!(:all_tags) { Tag.all }
        let!(:all_employees) { User.employees }
        before do
          allow(view).to receive(:request).and_return(double(referer: expenses_path))
          assign(:all_tags, all_tags)
          assign(:all_employees, all_employees)
        end
        

        context 'for the top section' do
          context 'for back button' do
            context 'with pending expenses' do
              it "renders the button" do
                sign_in employee
                assign(:expenses, pending_expenses)
                allow(view).to receive(:params).and_return({ type: 'pending' })

                render template: "expenses/index"

                expect(rendered).to have_css("a.btn.btn-simple")
              end
              it "points to the correct route" do
                sign_in employee
                assign(:expenses, pending_expenses)
                allow(view).to receive(:params).and_return({ type: 'pending' })
                render template: "expenses/index"

                expect(rendered).to have_link(href: expenses_path)
              end
            end
            context 'with history expenses' do
              it "renders the button" do
                sign_in employee
                assign(:expenses, history_expenses)
                allow(view).to receive(:params).and_return({ type: 'history' })
                render template: "expenses/index"

                expect(rendered).to have_css("a.btn.btn-simple")
              end
              it "points to the correct route" do
                sign_in employee
                assign(:expenses, history_expenses)
                allow(view).to receive(:params).and_return({ type: 'history' })
                render template: "expenses/index"

                expect(rendered).to have_link(href: expenses_path)
              end
            end
            context 'for page title' do
              context 'for an employee' do
                it "renders the title" do
                  sign_in employee
                  assign(:expenses, pending_expenses)
                  allow(view).to receive(:params).and_return({ type: 'pending' })
                  render template: "expenses/index"

                  expect(rendered).to have_css("h2.title-text")
                end
                it "renders the expected text" do
                  sign_in employee
                  assign(:expenses, pending_expenses)
                  allow(view).to receive(:params).and_return({ type: 'pending' })
                  render template: "expenses/index"

                  expect(rendered).to have_selector("h2", text: t('titles.my_pending_expenses'))
                end
              end
              context 'for a manager' do
                it "renders the title" do
                  sign_in manager
                  assign(:expenses, pending_expenses)
                  allow(view).to receive(:params).and_return({ type: 'pending' })
                  render template: "expenses/index"

                  expect(rendered).to have_css("h2.title-text")
                end
                it "renders the expected text" do
                  sign_in manager
                  assign(:expenses, pending_expenses)
                  allow(view).to receive(:params).and_return({ type: 'pending' })
                  render template: "expenses/index"

                  expect(rendered).to have_selector("h2", text: t('titles.pending_expenses'))
                end
              end
            end
          end
        end

        context 'for the tools section' do
          context 'for filter button' do
            it "renders the button" do
              assign(:expenses, pending_expenses)
              render template: "expenses/index"

              expect(rendered).to have_css("a.btn.btn-simple")
            end
            it "renders the modal HTML" do
              assign(:expenses, pending_expenses)
              render template: "expenses/index"

              expect(rendered).to have_css("#modal-filter")
            end
          end
        end

        context 'for the content section' do
          context 'for the information' do
            context 'for expense status' do
              it "renders the text" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_css("span.expense-status-index")
              end
              it "renders the expected text" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_selector("span", text: pending_expenses.first.full_status)
                expect(rendered).to have_selector("span", text: pending_expenses.second.full_status)
              end
            end
            context 'for employee name' do
              it "renders the text" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_css("p.expense-employee-name-index")
              end
              it "renders the expected text" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_selector("p", text: pending_expenses.first.user.name)
                expect(rendered).to have_selector("p", text: pending_expenses.second.user.name)
              end
            end
            context 'for date' do
              it "renders the date" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_css("p.expense-date-index")
              end
              it "renders the expected text" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_selector("p", text: formatted_expense_date(pending_expenses.first))
                expect(rendered).to have_selector("p", text: formatted_expense_date(pending_expenses.first))
              end
            end
            context 'for amount' do
              it "renders the amount" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_css("p.expense-amount-index")
              end
              it "renders the expected text" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_selector("p", text: formatted_expense_amount(pending_expenses.first))
                expect(rendered).to have_selector("p", text: formatted_expense_amount(pending_expenses.first))
              end
            end
            context 'for description' do
              it "renders the description" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_css("p.expense-description-index")
              end
              it "renders the expected text" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_selector("p", text: pending_expenses.first.description)
                expect(rendered).to have_selector("p", text: pending_expenses.second.description)
              end
            end
            context 'for tags' do
              it "renders all the tags" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_css("span.tag", count: 3)
              end
              it "renders the expected text" do
                assign(:expenses, pending_expenses)
                render template: "expenses/index"

                expect(rendered).to have_selector("span", text: pending_expenses.first.tags.first.description)
                expect(rendered).to have_selector("span", text: pending_expenses.second.tags.first.description)
                expect(rendered).to have_selector("span", text: pending_expenses.second.tags.second.description)
              end
            end
          end
        end
        it "renders with the correct structure" do
          assign(:expenses, pending_expenses)
          render template: "expenses/index"

          expect(rendered).to have_css("div.main-top .container-top")
          expect(rendered).to have_css("div.container-tools")
          expect(rendered).to have_css("div.container.container-primary.container-content-index")
          expect(rendered).to have_css("div.expense-box", count: 2)
          expect(rendered).to have_css("div.expense-box .expense-box-top", count: 2)
          expect(rendered).to have_css("div.expense-box .tags-container-view", count: 2)
        end
      end
    end
  end
end
