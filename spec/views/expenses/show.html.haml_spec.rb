require 'rails_helper'

RSpec.describe "expenses/show.html.haml", type: :view do
  include Devise::Test::ControllerHelpers

  context 'when user is logged in' do
    let!(:manager) { create(:user, :manager) }
    let!(:employee) { create(:user, :employee, manager_user_id: manager.id) }
    let!(:pending_expense) { create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employee) }
    let!(:history_expense) { create(:expense, :approved, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employee) }
    before do
      sign_in employee
      allow(view).to receive(:request).and_return(double(referer: expenses_path))
    end

    context 'for the top section' do
      context 'for back button' do
        context 'with a pending expense' do
          it "renders the button" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_css("a.btn.btn-simple")
          end
          it "points to the correct route" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_link(href: expenses_path(type: "pending"))
          end
        end
        context 'with a history expense' do
          it "renders the button" do
            assign(:expense, history_expense)
            render template: "expenses/show"

            expect(rendered).to have_css("a.btn.btn-simple")
          end
          it "points to the correct route" do
            assign(:expense, history_expense)
            render template: "expenses/show"

            expect(rendered).to have_link(href: expenses_path(type: "history"))
          end
        end
      end
      context 'for page title' do
        context 'for an employee' do
          it "renders the title" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_css("h2.title-text")
          end
          it "renders the expected text" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_selector("h2", text: t('titles.my_refound_request'))
          end
        end
        context 'for a manager' do
          it "renders the title" do
            sign_out employee
            sign_in manager
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_css("h2.title-text")
          end
          it "renders the expected text" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_selector("h2", text: t('titles.refound_request'))
          end
        end
      end
    end
    context 'for the content section' do
      context 'for the information' do
        context 'for description text' do
          it "renders the text" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_css("p.description-text-area")
          end
          it "renders the expected text" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_selector("p", text: pending_expense.description)
          end
        end
        context 'for location text' do
          it "renders the text" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_css("p.location-text-area")
          end
          it "renders the expected text" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_selector("p", text: pending_expense.location)
          end
        end
        context 'for tags' do
          it "renders all the tags" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_css("span.tag", count: 3)
          end
          it "renders the expected text for each tag" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_selector("span", text: pending_expense.tags.first.description)
            expect(rendered).to have_selector("span", text: pending_expense.tags.second.description)
            expect(rendered).to have_selector("span", text: pending_expense.tags.third.description)
          end
        end
        context 'for date' do
          context 'for the day' do
            it "renders the day" do
              assign(:expense, pending_expense)
              render template: "expenses/show"

              expect(rendered).to have_css("p#expense_day.day-text")
            end
            it "renders the expected text for the day" do
              assign(:expense, pending_expense)
              render template: "expenses/show"

              expect(rendered).to have_selector("p#expense_day.day-text", text: pending_expense.date.day)
            end
          end
          context 'for the day' do
            it "renders the month" do
              assign(:expense, pending_expense)
              render template: "expenses/show"

              expect(rendered).to have_css("p#expense_month.month-text")
            end
            it "renders the expected text for the month" do
              assign(:expense, pending_expense)
              render template: "expenses/show"

              expect(rendered).to have_selector("p#expense_month.month-text", text: pending_expense.date.strftime("%B").slice(0, 3))
            end
          end
        end
        context 'for the receipt files' do
          context 'for the nf receipt' do
            it "renders the nf receipt preview" do
              assign(:expense, pending_expense)
              render template: "expenses/show"

              expect(rendered).to have_css("img#expense_receipt_nf.file-preview")
            end
            it "renders the nf receipt large preview" do
              assign(:expense, pending_expense)
              render template: "expenses/show"

              expect(rendered).to have_css("img#expense_receipt_nf_large")
            end
          end
          context 'for the card receipt' do
            it "renders the card receipt preview" do
              assign(:expense, pending_expense)
              render template: "expenses/show"

              expect(rendered).to have_css("img#expense_receipt_card.file-preview")
            end
            it "renders the card receipt large preview" do
              assign(:expense, pending_expense)
              render template: "expenses/show"

              expect(rendered).to have_css("img#expense_receipt_card_large")
            end
          end
        end
        context 'for amount' do
          it "renders the amount" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_css("p#expense_amount.amount-text-view")
          end
          it "renders the expected amount" do
            assign(:expense, pending_expense)
            render template: "expenses/show"

            expect(rendered).to have_selector("p#expense_amount.amount-text-view", text: number_to_currency(pending_expense.amount, unit: "R$ ", separator: ",", delimiter: "."))
          end
        end
      end
      context 'for the buttons' do
        context 'for an employee' do
          let!(:manager_buttons) { create(:user, :manager) }
          let!(:employee_buttons) { create(:user, :employee, manager_user_id: manager_buttons.id) }
          let!(:expense_buttons) { create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employee_buttons) }
          context 'for the remove button' do
            it "renders the button" do
              sign_out employee
              sign_in employee_buttons
              assign(:expense, expense_buttons)
              render template: "expenses/show"

              expect(rendered).to have_button(t("buttons.remove"))
              expect(rendered).to have_css("button.btn.btn-cancel.btn-full-width")
            end

            it "renders the button with the expected text" do
              assign(:expense, expense_buttons)
              render template: "expenses/show"

              expect(rendered).to have_selector("button#remove_expense", text: t("buttons.remove"))
            end

            it "points to the correct route" do
              assign(:expense, expense_buttons)
              render template: "expenses/show"

              form_action = expense_path(expense_buttons)

              expect(rendered).to have_css("form[action='#{form_action}'][method='post']") do |form|
                expect(form).to have_css("input[name='_method'][value='delete']", visible: false)
              end
            end
          end
          context 'for the edit button' do
            it "renders the button" do
              assign(:expense, expense_buttons)
              render template: "expenses/show"

              expect(rendered).to have_css("a.btn.btn-primary.btn-full-width")
            end

            it "renders the button with the expected text" do
              assign(:expense, expense_buttons)
              render template: "expenses/show"

              expect(rendered).to have_selector("a#edit_expense", text: t("buttons.edit"))
            end

            it "points to the correct route" do
              assign(:expense, expense_buttons)
              render template: "expenses/show"

              edit_path = edit_expense_path(expense_buttons)

              expect(rendered).to have_link(href: edit_path)
            end
          end
        end
        context 'for a manager' do
          context 'with a pending expense' do
            let!(:manager_buttons) { create(:user, :manager) }
            let!(:employee_buttons) { create(:user, :employee, manager_user_id: manager_buttons.id) }
            let!(:expense_buttons) { create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employee_buttons) }
            context 'for the decline button' do
              it "renders the button" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                expect(rendered).to have_button(t("buttons.decline"))
                expect(rendered).to have_css("button.btn.btn-cancel.btn-full-width")
              end

              it "renders the button with the expected text" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                expect(rendered).to have_selector("button#decline_expense", text: t("buttons.decline"))
              end

              it "points to the correct route" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                form_action = expense_path(expense_buttons)


                expect(rendered).to have_selector("form[action='#{decline_expense_path(expense_buttons)}'][method='post']") do |form|
                  expect(form).to have_button
                end
              end
            end
            context 'for the approve button' do
              it "renders the button" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                expect(rendered).to have_css("button.btn.btn-confirm.btn-full-width")
              end

              it "renders the button with the expected text" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                expect(rendered).to have_selector("button#approve_expense", text: t("buttons.approve"))
              end

              it "points to the correct route" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                edit_path = edit_expense_path(expense_buttons)

                expect(rendered).to have_selector("form[action='#{approve_expense_path(expense_buttons)}'][method='post']") do |form|
                  expect(form).to have_button
                end
              end
            end
          end
          context 'with a history expense' do
            let!(:manager_buttons) { create(:user, :manager) }
            let!(:employee_buttons) { create(:user, :employee, manager_user_id: manager_buttons.id) }
            let!(:expense_buttons) { create(:expense, :approved, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employee_buttons) }
            context 'for the decline button' do
              it "does not render the button" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                expect(rendered).not_to have_button(t("buttons.decline"))
                expect(rendered).not_to have_css("button.btn.btn-cancel.btn-full-width")
              end

              it "does not render the button with a text" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                expect(rendered).not_to have_selector("button#decline_expense", text: t("buttons.decline"))
              end

              it "does not point to any route" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                form_action = expense_path(expense_buttons)


                expect(rendered).not_to have_selector("form[action='#{decline_expense_path(expense_buttons)}'][method='post']") do |form|
                  expect(form).not_to have_button
                end
              end
            end
            context 'for the approve button' do
              it "does not render the button" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                expect(rendered).not_to have_css("button.btn.btn-confirm.btn-full-width")
              end

              it "does not render the button with a text" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                expect(rendered).not_to have_selector("button#approve_expense", text: t("buttons.approve"))
              end

              it "does not point to any route" do
                sign_in manager_buttons
                assign(:expense, expense_buttons)
                render template: "expenses/show"

                edit_path = edit_expense_path(expense_buttons)

                expect(rendered).not_to have_selector("form[action='#{approve_expense_path(expense_buttons)}'][method='post']") do |form|
                  expect(form).not_to have_button
                end
              end
            end
          end
        end
      end
    end
    it "renders with the correct structure" do
      assign(:expense, pending_expense)
      render template: "expenses/show"

      expect(rendered).to have_css("div.main-top .container-top")
      expect(rendered).to have_css("div.container.container-primary.container-full-screen-secondary")
      expect(rendered).to have_css(".container-hor .tags-container-view")
      expect(rendered).to have_css(".container-hor .date-container-view")
      expect(rendered).to have_css(".files-container .file-box", count: 2)
    end
  end
end
