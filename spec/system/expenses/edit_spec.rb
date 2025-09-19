require 'rails_helper'
include MatchHelpers
include FillFormHelpers

RSpec.describe "Edit Expense", type: :system do
  context 'with an employee user related to a manager' do
    let!(:manager) { create(:user, :manager) }
    let!(:employee) { create(:user, :employee, manager_user_id: manager.id) }
    context 'with an expense' do
      let!(:expense) do
        create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employee)
      end
      context 'when the user is logged in' do
        before { login_as(employee, scope: :user) }
        context 'with valid information' do
          it "allows a user to update an expense" do
            visit "/expenses/#{expense.id}/edit"

            fill_form_edit_expense(description: 'Descrição da despesa',
                                   date: Date.today,
                                   amount: 10.00,
                                   location: 'Local da despesa',
                                   tag_names: ['tag1', 'tag2'],
                                   nf_file: "spec/fixtures/files/receipt_nf.png",
                                   card_file: "spec/fixtures/files/receipt_card.png")

            click_button "request_expense"

            expect(page).to have_content(I18n.t("messages.refound_request_edited"))
          end
        end
        context 'with invalid information' do
          context 'for the amount field' do
            context 'when the field is blank' do
              it "does not allow a user to update an expense" do
                visit "/expenses/#{expense.id}/edit"

                fill_in "amount", with: nil

                click_button "request_expense"

                expect(page).to have_content(I18n.t("errors.forms.expenses.amount.blank"))
              end
            end
          end
          context 'for the date field' do
            context 'when the date is blank' do
              it "does not allow a user to update an expense" do
                visit "/expenses/#{expense.id}/edit"

                fill_in "date", with: nil

                click_button "request_expense"

                expect(page).to have_content(I18n.t("errors.forms.expenses.date.blank"))
              end
            end
          end
          context 'for the location field' do
            context 'when the location is blank' do
              it "does not allow a user to update an expense" do
                visit "/expenses/#{expense.id}/edit"

                fill_in "location", with: nil

                click_button "request_expense"

                expect(page).to have_content(I18n.t("errors.forms.expenses.location.blank"))
              end
            end
            context 'when the location is too long' do
              it "does not allow a user to update an expense" do
                visit "/expenses/#{expense.id}/edit"

                fill_in "location", with: 'aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeef'

                click_button "request_expense"

                expect(page).to have_content(I18n.t("errors.forms.expenses.location.too_long"))
              end
            end
          end
          context 'for the description field' do
            context 'when the description is blank' do
              it "does not allow a user to update an expense" do
                visit "/expenses/#{expense.id}/edit"

                fill_in "description", with: nil

                click_button "request_expense"

                expect(page).to have_content(I18n.t("errors.forms.expenses.description.blank"))
              end
            end
            context 'when the description is too long' do
              it "does not allow a user to update an expense" do
                visit "/expenses/#{expense.id}/edit"

                fill_in "description", with: 'aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhi'

                click_button "request_expense"

                expect(page).to have_content(I18n.t("errors.forms.expenses.description.too_long"))
              end
            end
          end
          context 'for the tags field' do
            context 'when the tags is blank' do
              it "does not allow a user to update an expense" do
                visit "/expenses/#{expense.id}/edit"

                tags_list = find("#tags-list", visible: false)
                tags_list.native.inner_html = ""

                click_button "request_expense"

                expect(page).to have_content(I18n.t("errors.forms.expenses.tags.blank"))
              end
            end
          end
        end
      end
    end
  end
end
