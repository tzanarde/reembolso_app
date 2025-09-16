require 'rails_helper'
include MatchHelpers

RSpec.describe "New Expense", type: :system do
  context 'with an employee user related to a manager' do
    let!(:manager) { create(:user, :manager) }
    let!(:employee) { create(:user, :employee, manager_user_id: manager.id) }
    context 'when the user is logged in' do
      before { login_as(employee, scope: :user) }
      context 'with valid information' do
        it "allows a user to create an expense" do
          visit '/expenses/new'

          fill_form_new_expense(description: 'Descrição da despesa',
                                date: Date.today,
                                amount: 10.00,
                                location: 'Local da despesa',
                                tags: 'tag1')

          click_button "request_expense"

          expect(page).to have_content(I18n.t("messages.refound_request_sent"))
        end
      end
      context 'with invalid information' do
        context 'for the amount field' do
          context 'when the field is blank' do
            it "does not allow a user to create an expense" do
              visit '/expenses/new'

              fill_form_new_expense(description: 'Descrição da despesa',
                                    date: Date.today,
                                    location: 'Local da despesa',
                                    tags: 'tag1')

              click_button "request_expense"

              expect(page).to have_content(I18n.t("errors.forms.expenses.amount.blank"))
            end
          end
        end
        context 'for the date field' do
          context 'when the date is blank' do
            it "does not allow a user to create an expense" do
              visit '/expenses/new'

              fill_form_new_expense(description: 'Descrição da despesa',
                                    amount: 10.00,
                                    location: 'Local da despesa',
                                    tags: 'tag1')

              click_button "request_expense"

              expect(page).to have_content(I18n.t("errors.forms.expenses.date.blank"))
            end
          end
        end
        # context 'for the tags field' do
        #   context 'when the tags is blank' do
        #     it "does not allow a user to create an expense" do
        #       visit '/expenses/new'

        #       fill_form_new_expense(description: 'Descrição da despesa',
        #                             date: Date.today,
        #                             amount: 10.00,
        #                             location: 'Local da despesa')

        #       click_button "request_expense"

        #       expect(page).to have_content(I18n.t("errors.forms.expenses.tags.blank"))
        #     end
        #   end
        # end
        context 'for the location field' do
          context 'when the location is blank' do
            it "does not allow a user to create an expense" do
              visit '/expenses/new'

              fill_form_new_expense(description: 'Descrição da despesa',
                                    date: Date.today,
                                    amount: 10.00,
                                    tags: 'tag1')

              click_button "request_expense"

              expect(page).to have_content(I18n.t("errors.forms.expenses.location.blank"))
            end
          end
          context 'when the location is too long' do
            it "does not allow a user to create an expense" do
              visit '/expenses/new'

              fill_form_new_expense(description: 'Descrição da despesa',
                                    date: Date.today,
                                    amount: 10.00,
                                    location: 'aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeef',
                                    tags: 'tag1')

              click_button "request_expense"

              expect(page).to have_content(I18n.t("errors.forms.expenses.location.too_long"))
            end
          end
        end
        context 'for the description field' do
          context 'when the description is blank' do
            it "does not allow a user to create an expense" do
              visit '/expenses/new'

              fill_form_new_expense(date: Date.today,
                                    amount: 10.00,
                                    location: 'Local da despesa',
                                    tags: 'tag1')

              click_button "request_expense"

              expect(page).to have_content(I18n.t("errors.forms.expenses.description.blank"))
            end
          end
          context 'when the description is too long' do
            it "does not allow a user to create an expense" do
              visit '/expenses/new'

              fill_form_new_expense(description: 'aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhi',
                                    date: Date.today,
                                    amount: 10.00,
                                    location: 'Local da despesa',
                                    tags: 'tag1')

              click_button "request_expense"

              expect(page).to have_content(I18n.t("errors.forms.expenses.description.too_long"))
            end
          end
        end
      end
    end
  end
end
