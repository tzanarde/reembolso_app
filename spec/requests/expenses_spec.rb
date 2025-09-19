# frozen_string_literal: true

require 'rails_helper'
include MatchHelpers

RSpec.describe "Expenses", type: :request do
  describe "GET /expenses" do
    context 'with a manager' do
      let!(:manager) { create(:user, :manager) }
      context 'with employees related to the manager' do
        let!(:employees) do
          [ create(:user, :employee, manager_user_id: manager.id),
            create(:user, :employee, manager_user_id: manager.id) ]
        end
        context 'with expenses' do
          let!(:expenses) do
            [
              create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 1, user: employees[0], amount: 10.00),
              create(:expense, :approved, :with_tags, :with_nf_file, :with_card_file, tags_count: 2, user: employees[0], amount: 20.00),
              create(:expense, :declined, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employees[0], amount: 30.00),
              create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 4, user: employees[1], amount: 40.00),
              create(:expense, :approved, :with_tags, :with_nf_file, :with_card_file, tags_count: 5, user: employees[1], amount: 50.00),
              create(:expense, :declined, :with_tags, :with_nf_file, :with_card_file, tags_count: 6, user: employees[1], amount: 60.00)
            ]
          end
          let!(:pending_expenses) { [ expenses[0], expenses[3] ] }
          let!(:history_expenses) { [ expenses[1], expenses[2], expenses[4], expenses[5] ] }
          let!(:employee_1_expenses) { [ expenses[0], expenses[1], expenses[2] ] }
          let!(:employee_2_expenses) { [ expenses[3], expenses[4], expenses[5] ] }
          let!(:employee_1_pending_expenses) { [ expenses[0] ] }
          let!(:employee_1_history_expenses) { [ expenses[1], expenses[2] ] }
          let!(:employee_2_pending_expenses) { [ expenses[3] ] }
          let!(:employee_2_history_expenses) { [ expenses[4], expenses[5] ] }
          context "when an employee is logged in" do
            before { login_as(employees.first, scope: :user) }
            context "without filters" do
              context 'for the pending expenses' do
                let!(:params) { { type: 'pending' } }
                let(:testing_expenses) { expenses }
                let(:testing_employee) { employees.first }
                it 'returns all pending expenses' do
                  get "/expenses", params: params
                  
                  expect(response).to have_http_status(:ok)
                  match_expense_fields_index(assigns(:expenses), employee_1_pending_expenses, manager, testing_employee)
                end
              end
              context 'for the expense history' do
                let!(:params) { { type: 'history' } }
                context "without filters" do
                  let(:testing_expenses) { expenses }
                  let(:testing_employee) { employees.first }
                  it 'returns the whole expense history' do
                    get "/expenses", params: params
                    
                    expect(response).to have_http_status(:ok)
                    match_expense_fields_index(assigns(:expenses), employee_1_history_expenses, manager, testing_employee)
                  end
                end
              end
            end

            context "with filters" do
              context 'for the pending expenses' do
                context "filtering by description" do
                  context 'for the pending expenses' do
                    let(:params) { { type: 'pending', description: expenses[0].description } }
                    let(:testing_expenses) { [ expenses[0] ] }
                    let(:testing_employee) { employees.first }
                    it 'returns all pending expenses filtered by description' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                  context 'for the expenses history' do
                    let(:params) { { type: 'history', description: expenses[1].description } }
                    let(:testing_expenses) { [ expenses[1] ] }
                    let(:testing_employee) { employees.first }
                    it 'returns the whole expense history filtered by description' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                end
                context "filtering by location" do
                  context 'for the pending expenses' do
                    let(:params) { { type: 'pending', location: expenses[0].location } }
                    let(:testing_expenses) { [ expenses[0] ] }
                    let(:testing_employee) { employees.first }
                    it 'returns all pending expenses filtered by location' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                  context 'for the expenses history' do
                    let(:params) { { type: 'history', location: expenses[1].location } }
                    let(:testing_expenses) { [ expenses[1] ] }
                    let(:testing_employee) { employees.first }
                    it 'returns the whole expense history filtered by location' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                end
                context "filtering by amount" do
                  context 'for the pending expenses' do
                    let(:params) { { type: 'pending', min_amount: 5.00, max_amount: 25.00 } }
                    let(:testing_expenses) { [ expenses[0] ] }
                    let(:testing_employee) { employees.first }
                    it 'returns all pending expenses filtered by amount' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                  context 'for the expenses history' do
                    let(:params) { { type: 'history', min_amount: 5.00, max_amount: 25.00 } }
                    let(:testing_expenses) { [ expenses[1] ] }
                    let(:testing_employee) { employees.first }
                    it 'returns the whole expense history filtered by amount' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                end
                context "filtering by date" do
                  context "with a specific day" do
                    context 'for the pending expenses' do
                      let(:params) { { type: 'pending', date: expenses[0].date } }
                      let(:testing_expenses) { [ expenses[0] ] }
                      let(:testing_employee) { employees.first }
                      it 'returns all pending expenses filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(1)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                    context 'for the expenses history' do
                      let(:params) { { type: 'history', date: expenses[1].date } }
                      let(:testing_expenses) { [ expenses[1] ] }
                      let(:testing_employee) { employees.first }
                      it 'returns the whole expense history filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(1)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                  end
                  context "with a period of days with both start and final dates" do
                    context 'for the pending expenses' do
                      let(:params) { { type: 'pending', start_date: expenses[0].date, final_date: expenses[0].date } }
                      let(:testing_expenses) { [ expenses[0] ] }
                      let(:testing_employee) { employees.first }
                      it 'returns all pending expenses filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(1)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                    context 'for the expenses history' do
                      let(:params) { { type: 'history', start_date: expenses[2].date, final_date: expenses[1].date } }
                      let(:testing_expenses) { [ expenses[1], expenses[2] ] }
                      let(:testing_employee) { employees.first }
                      it 'returns the whole expense history filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(2)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                  end
                  context "with a period of days with only start date" do
                    context 'for the pending expenses' do
                      let(:params) { { type: 'pending', start_date: expenses[0].date } }
                      let(:testing_expenses) { [ expenses[0] ] }
                      let(:testing_employee) { employees.first }
                      it 'returns all pending expenses filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(1)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                    context 'for the expenses history' do
                      let(:params) { { type: 'history', start_date: expenses[1].date } }
                      let(:testing_expenses) { [ expenses[1] ] }
                      let(:testing_employee) { employees.first }
                      it 'returns the whole expense history filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(1)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                  end
                end
                context "filtering by tags" do
                  context 'for the pending expenses' do
                    let(:params) { { type: 'pending', tags: [ expenses[0].tags.first.description ] } }
                    let(:testing_expenses) { [ expenses[0] ] }
                    let(:testing_employee) { employees.first }
                    it 'returns all pending expenses filtered by tag' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                  context 'for the expenses history' do
                    let(:params) { { type: 'history', tags: [ expenses[1].tags.second.description ] } }
                    let(:testing_expenses) { [ expenses[1] ] }
                    let(:testing_employee) { employees.first }
                    it 'returns the whole expense history filtered by tag' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                end
              end
            end
          end
          context "when an employee is logged out" do
            it 'does not allow to return the expenses' do
              get "/expenses"

              expect(response).to have_http_status(:found)
            end
          end
          context "when a manager is logged in" do
            before { login_as(manager, scope: :user) }
            context "without filters" do
              context 'for the pending expenses' do
                let!(:params) { { type: 'pending' } }
                let(:testing_expenses) { [expenses[0], expenses[3]] }
                let(:testing_employees) { employees }
                it 'returns all pending expenses from all employees related to the manager' do
                  get "/expenses", params: params
                  
                  expect(response).to have_http_status(:ok)
                  expect(assigns(:expenses).count).to eq(2)
                  match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employees)
                end
              end
              context 'for the expense history' do
                let!(:params) { { type: 'history' } }
                context "without filters" do
                  let(:testing_expenses) { [expenses[1], expenses[2], expenses[4], expenses[5]] }
                  let(:testing_employees) { employees }
                  it 'returns the whole expense history from all employees related to the manager' do
                    get "/expenses", params: params
                    
                    expect(response).to have_http_status(:ok)
                    expect(assigns(:expenses).count).to eq(4)
                    match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employees)
                  end
                end
              end
            end
            context "with filters" do
              context 'for the pending expenses' do
                context "filtering by description" do
                  context 'for the pending expenses' do
                    let(:params) { { type: 'pending', description: expenses[0].description } }
                    let(:testing_expenses) { [ expenses[0] ] }
                    let(:testing_employee) { employees }
                    it 'returns all pending expenses filtered by description' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                  context 'for the expenses history' do
                    let(:params) { { type: 'history', description: expenses[1].description } }
                    let(:testing_expenses) { [ expenses[1] ] }
                    let(:testing_employee) { employees }
                    it 'returns the whole expense history filtered by description' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                end
                context "filtering by location" do
                  context 'for the pending expenses' do
                    let(:params) { { type: 'pending', location: expenses[0].location } }
                    let(:testing_expenses) { [ expenses[0] ] }
                    let(:testing_employee) { employees }
                    it 'returns all pending expenses filtered by location' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                  context 'for the expenses history' do
                    let(:params) { { type: 'history', location: expenses[1].location } }
                    let(:testing_expenses) { [ expenses[1] ] }
                    let(:testing_employee) { employees }
                    it 'returns the whole expense history filtered by location' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                end
                context "filtering by amount" do
                  context 'for the pending expenses' do
                    let(:params) { { type: 'pending', min_amount: 5.00, max_amount: 25.00 } }
                    let(:testing_expenses) { [ expenses[0] ] }
                    let(:testing_employee) { employees }
                    it 'returns all pending expenses filtered by amount' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                  context 'for the expenses history' do
                    let(:params) { { type: 'history', min_amount: 5.00, max_amount: 25.00 } }
                    let(:testing_expenses) { [ expenses[1] ] }
                    let(:testing_employee) { employees }
                    it 'returns the whole expense history filtered by amount' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                end
                context "filtering by date" do
                  context "with a specific day" do
                    context 'for the pending expenses' do
                      let(:params) { { type: 'pending', date: expenses[0].date } }
                      let(:testing_expenses) { [ expenses[0] ] }
                      let(:testing_employee) { employees }
                      it 'returns all pending expenses filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(1)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                    context 'for the expenses history' do
                      let(:params) { { type: 'history', date: expenses[1].date } }
                      let(:testing_expenses) { [ expenses[1] ] }
                      let(:testing_employee) { employees }
                      it 'returns the whole expense history filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(1)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                  end
                  context "with a period of days with both start and final dates" do
                    context 'for the pending expenses' do
                      let(:params) { { type: 'pending', start_date: expenses[0].date, final_date: expenses[0].date } }
                      let(:testing_expenses) { [ expenses[0] ] }
                      let(:testing_employee) { employees }
                      it 'returns all pending expenses filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(1)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                    context 'for the expenses history' do
                      let(:params) { { type: 'history', start_date: expenses[2].date, final_date: expenses[1].date } }
                      let(:testing_expenses) { [ expenses[1], expenses[2] ] }
                      let(:testing_employee) { employees }
                      it 'returns the whole expense history filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(2)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                  end
                  context "with a period of days with only start date" do
                    context 'for the pending expenses' do
                      let(:params) { { type: 'pending', start_date: expenses[0].date } }
                      let(:testing_expenses) { [ expenses[0] ] }
                      let(:testing_employee) { employees }
                      it 'returns all pending expenses filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(1)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                    context 'for the expenses history' do
                      let(:params) { { type: 'history', start_date: expenses[1].date } }
                      let(:testing_expenses) { [ expenses[1] ] }
                      let(:testing_employee) { employees }
                      it 'returns the whole expense history filtered by date' do
                        
                        get "/expenses", params: params
                        
                        expect(response).to have_http_status(:ok)
                        expect(assigns(:expenses).count).to eq(1)
                        match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                      end
                    end
                  end
                end
                context "filtering by tags" do
                  context 'for the pending expenses' do
                    let(:params) { { type: 'pending', tags: [ expenses[0].tags.first.description ] } }
                    let(:testing_expenses) { [ expenses[0] ] }
                    let(:testing_employee) { employees }
                    it 'returns all pending expenses filtered by tag' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                  context 'for the expenses history' do
                    let(:params) { { type: 'history', tags: [ expenses[1].tags.second.description ] } }
                    let(:testing_expenses) { [ expenses[1] ] }
                    let(:testing_employee) { employees }
                    it 'returns the whole expense history filtered by tag' do
                      
                      get "/expenses", params: params
                      
                      expect(response).to have_http_status(:ok)
                      expect(assigns(:expenses).count).to eq(1)
                      match_expense_fields_index(assigns(:expenses), testing_expenses, manager, testing_employee)
                    end
                  end
                end
              end
            end
          end
        end

        context "when the user is logged out" do
          it 'does not allow to return the expenses' do
            get "/expenses"

            expect(response).to have_http_status(:found)
          end
        end
      end
    end
  end

  describe "GET /expenses/:id" do
    let!(:manager) { create(:user, :manager) }
    let!(:employees) do
      [ create(:user, :employee, manager_user_id: manager.id),
        create(:user, :employee, manager_user_id: manager.id) ]
    end
    let!(:expense) do
      create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employees[0])
    end
    let(:testing_expenses) { expense }
    let(:testing_employees) { employees[0] }

    context "when the user is logged in" do
      context 'when the expense exists' do
        before { login_as(employees.first, scope: :user) }
        it 'returns an expense' do
          get "/expenses/#{testing_expenses.id}"

          expect(response).to have_http_status(:ok)
          expect(assigns(:expense)).to eq(testing_expenses)

          match_expense_fields_show(assigns(:expense), testing_expenses, manager, testing_employees)
        end
      end

      context 'when the expense does not exist' do
        before { login_as(employees.first, scope: :user) }

        it 'returns not found' do
          get "/expenses/1"

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "when the user is logged out" do
      it 'does not allow to return the expense' do
        get "/expenses/#{testing_expenses.id}"

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "POST /expenses" do
    context "when the user is logged in" do
      let!(:manager) { create(:user, :manager) }
      let!(:employees) do
        [ create(:user, :employee, manager_user_id: manager.id),
          create(:user, :employee, manager_user_id: manager.id) ]
      end
      before { login_as(employees.first, scope: :user) }
      context "without tags" do
        let!(:valid_params) do
          attributes_for(:expense, :pending, :with_tags)
            .merge(user_id: employees.first["id"],
                   receipt_nf: fixture_file_upload("spec/fixtures/files/receipt_nf.png", "image/png"),
                   receipt_card: fixture_file_upload("spec/fixtures/files/receipt_card.png", "image/png"))
        end
        let(:testing_expense) { valid_params }
        let(:testing_employee) { employees[0] }

        it 'does not create an expense' do
          post expenses_path, params: { expense: testing_expense }

          expect(response).to have_http_status(:unprocessable_content)
        end
      end

      context "with tags" do
        context "with only one tag" do
          let!(:valid_params) do
            attributes_for(:expense, :pending)
              .merge(user_id: employees.first["id"],
                    tag_names: ["tag1"],
                    receipt_nf: fixture_file_upload("spec/fixtures/files/receipt_nf.png", "image/png"),
                    receipt_card: fixture_file_upload("spec/fixtures/files/receipt_card.png", "image/png"))
          end
          let(:testing_expense) { valid_params }
          let(:testing_employee) { employees[0] }

          it 'creates an expense' do
            post expenses_path, params: { expense: testing_expense }

            expect(response).to have_http_status(:found)
            match_expense_fields_create(expense_returned: assigns(:expense),
                                        expense_expected: testing_expense,
                                        manager: manager,
                                        employee: testing_employee)
          end
        end

        context "with multiple tags" do
          let!(:valid_params) do
            attributes_for(:expense, :pending)
              .merge(user_id: employees.first["id"],
                    tag_names: ["tag1","tag2", "tag3", "tag4", "tag5"],
                    receipt_nf: fixture_file_upload("spec/fixtures/files/receipt_nf.png", "image/png"),
                    receipt_card: fixture_file_upload("spec/fixtures/files/receipt_card.png", "image/png"))
          end
          let(:testing_expense) { valid_params }
          let(:testing_employee) { employees[0] }

          it 'creates an expense' do
            post expenses_path, params: { expense: testing_expense }

            expect(response).to have_http_status(:found)
            match_expense_fields_create(expense_returned: assigns(:expense),
                                        expense_expected: testing_expense,
                                        manager: manager,
                                        employee: testing_employee)
          end
        end
      end

      context "with receipt files" do
        context "with both receipt nf and receipt card files" do
          let!(:valid_params) do
            attributes_for(:expense, :pending)
              .merge(user_id: employees.first["id"],
                    tag_names: ["tag1","tag2"],
                    receipt_nf: fixture_file_upload("spec/fixtures/files/receipt_nf.png", "image/png"),
                    receipt_card: fixture_file_upload("spec/fixtures/files/receipt_card.png", "image/png"))
          end
          let(:testing_expense) { valid_params }
          let(:testing_employee) { employees[0] }

          it 'creates an expense' do
            post expenses_path, params: { expense: testing_expense }

            expect(response).to have_http_status(:found)
            match_expense_fields_create(expense_returned: assigns(:expense),
                                        expense_expected: testing_expense,
                                        manager: manager,
                                        employee: testing_employee)
          end
        end
        context "with only receipt nf file" do
          let!(:valid_params) do
            attributes_for(:expense, :pending)
              .merge(user_id: employees.first["id"],
                    tag_names: ["tag1","tag2"],
                    receipt_nf: fixture_file_upload("spec/fixtures/files/receipt_nf.png", "image/png"))
          end
          let(:testing_expense) { valid_params }
          let(:testing_employee) { employees[0] }

          it 'creates an expense' do
            post expenses_path, params: { expense: testing_expense }

            expect(response).to have_http_status(:unprocessable_content)
          end
        end
        context "with only receipt card file" do
          let!(:valid_params) do
            attributes_for(:expense, :pending)
              .merge(user_id: employees.first["id"],
                    tag_names: ["tag1","tag2"],
                    receipt_card: fixture_file_upload("spec/fixtures/files/receipt_card.png", "image/png"))
          end
          let(:testing_expense) { valid_params }
          let(:testing_employee) { employees[0] }

          it 'creates an expense' do
            post expenses_path, params: { expense: testing_expense }

            expect(response).to have_http_status(:unprocessable_content)
          end
        end
      end
    end
    context "when the user is logged out" do
      it 'does not allow to return the expense' do
        post expenses_path, params: { expense: { description: "teste", date: Date.today, amount: 10, location: "Local" } }

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "PATCH /expenses" do
    context "when the user is logged in" do
      let!(:manager) { create(:user, :manager) }
      let!(:employees) do
        [ create(:user, :employee, manager_user_id: manager.id),
          create(:user, :employee, manager_user_id: manager.id) ]
      end
      before { login_as(employees.first, scope: :user) }
      context "without tags" do
        context 'when the expense exists' do
          let!(:expense) do
            create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employees[0])
          end
          let(:valid_params) do
            {
              description: 'New Description',
              date: expense.date,
              amount: expense.amount,
              location: expense.location,
              tag_names: expense.tags.map(&:description),
              receipt_nf: fixture_file_upload("spec/fixtures/files/receipt_nf.png", "image/png"),
              receipt_card: fixture_file_upload("spec/fixtures/files/receipt_card.png", "image/png")
            }
          end
          let(:testing_expense) { expense }
          let(:testing_employees) { employees[0] }
          it 'updates an expense' do
            patch "/expenses/#{expense.id}", params: { expense: valid_params }

            expect(response).to have_http_status(:found)
            expect(assigns(:expense)["description"]).not_to eq(testing_expense["description"])
          end
        end
        context 'when the expense does not exist' do
          before { login_as(employees.first, scope: :user) }
          it 'returns not found' do
            patch "/expenses/1"

            expect(response).to have_http_status(:not_found)
          end
        end
      end
      context "with tags" do
        context "to add new tags" do
          before { login_as(employees.first, scope: :user) }
          let!(:expense) do
            create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employees[0])
          end
          let!(:tags) { create_list(:tag, 10) }
          let(:all_tags) { expense.tags + tags }
          let(:valid_params) do
            {
              description: expense.description,
              date: expense.date,
              amount: expense.amount,
              location: expense.location,
              tag_names: all_tags.map(&:description),
              receipt_nf: fixture_file_upload("spec/fixtures/files/receipt_nf.png", "image/png"),
              receipt_card: fixture_file_upload("spec/fixtures/files/receipt_card.png", "image/png")
            }
          end
          let(:testing_expense) { expense }
          let(:testing_employees) { employees[0] }
          it 'updates an expense' do
            patch "/expenses/#{expense.id}", params: { expense: valid_params }

            expect(response).to have_http_status(:found)
            expect(assigns(:expense).tags.count).to eq(13)
          end
        end
        context "to remove tags" do
          before { login_as(employees.first, scope: :user) }
          let!(:expense) do
            create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employees[0])
          end
          let(:all_tags) { [expense.tags[0], expense.tags[1]] }
          let(:valid_params) do
            {
              description: expense.description,
              date: expense.date,
              amount: expense.amount,
              location: expense.location,
              tag_names: all_tags.map(&:description),
              receipt_nf: fixture_file_upload("spec/fixtures/files/receipt_nf.png", "image/png"),
              receipt_card: fixture_file_upload("spec/fixtures/files/receipt_card.png", "image/png")
            }
          end
          let(:testing_expense) { expense }
          let(:testing_employees) { employees[0] }
          it 'updates an expense' do
            patch "/expenses/#{expense.id}", params: { expense: valid_params }

            expect(response).to have_http_status(:found)
            expect(assigns(:expense).tags.count).to eq(2)
          end
        end

        context "to both add and remove tags" do
          before { login_as(employees.first, scope: :user) }
          let!(:expense) do
            create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employees[0])
          end
          let!(:tags) { create_list(:tag, 10) }
          let(:all_tags) { [expense.tags[0], expense.tags[1]] + tags }
          let(:valid_params) do
            {
              description: expense.description,
              date: expense.date,
              amount: expense.amount,
              location: expense.location,
              tag_names: all_tags.map(&:description),
              receipt_nf: fixture_file_upload("spec/fixtures/files/receipt_nf.png", "image/png"),
              receipt_card: fixture_file_upload("spec/fixtures/files/receipt_card.png", "image/png")
            }
          end
          let(:testing_expense) { expense }
          let(:testing_employees) { employees[0] }
          it 'updates an expense' do
            patch "/expenses/#{expense.id}", params: { expense: valid_params }

            expect(response).to have_http_status(:found)
            expect(assigns(:expense).tags.count).to eq(12)
          end
        end
      end
    end
    context "when the user is logged out" do
      it 'returns unauthorized' do
        patch "/expenses/1"

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "DELETE /expenses" do
    context "when the user is logged in" do
      let!(:manager) { create(:user, :manager) }
      let!(:employees) do
        [ create(:user, :employee, manager_user_id: manager.id),
          create(:user, :employee, manager_user_id: manager.id) ]
      end
      before { login_as(employees.first, scope: :user) }
      context 'when the expenses exists' do
        let!(:expense) do
          create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employees[0])
        end

        it 'deletes an expense' do
          expect {
            delete "/expenses/#{expense.id}"
          }.to change(Expense, :count).by(-1)

          expect(response).to have_http_status(:found)
        end
      end

      context 'when the expense does not exist' do
        before { login_as(employees.first, scope: :user) }

        it 'returns not found' do
          delete "/expenses/1", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
