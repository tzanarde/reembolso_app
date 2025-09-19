# frozen_string_literal: true

module MatchHelpers extend RSpec::SharedContext
  def match_expense_fields_index(expenses_returned, expenses_created, manager, employees)
    expect(expenses_returned.count).to eq(expenses_created.count)
    expect(expenses_returned).to match_array(expenses_created)

    expenses_returned.each_with_index do |requested_expense, index|
      expense_created = expenses_created[index]

      expenses_returned.each_with_index do |expense, index|
        created_expense = expenses_created[index]
        
        unless created_expense.tags.nil?
          expect(expense.tags.count).to eq(created_expense.tags.count)
          created_expense.tags.each_with_index do |tag, index|
            expect(expense.tags[index]).to eq(tag)
          end
        end
      end
    end
  end

  def match_expense_fields_show(expense_returned, expense_created, manager, employees)
    # Attributes check
    expected_attributes = ["description", "date", "amount", "location", "status"]
    expect(expected_attributes.all? { |attr| expense_returned.has_attribute?(attr) }).to be true

    # Values check
    expect(expense_returned.description).to eq(expense_created["description"])
    expect(expense_returned.date).to eq(expense_created["date"].to_date)
    expect(expense_returned.amount).to eq(expense_created["amount"].to_f)
    expect(expense_returned.location).to eq(expense_created["location"])
    expect(expense_returned.status).to eq(expense_created["status"])

    # Tags check
    unless expense_created["tag_names"].nil?
      expect(expenses_returned.tags.count).to eq(expense_created["tag_names"].count)
      expense_created["tag_names"].each_with_index do |tag, index|
        expect(expenses_returned.tags[index].description).to eq(tag)
      end
    end

    # Receipts check
    expect(expense_returned.receipt_nf.download).to eq(expense_created.receipt_nf.download)
    expect(expense_returned.receipt_card.download).to eq(expense_created.receipt_card.download)
  end

  def match_expense_fields_create(expense_returned:, expense_expected:, manager:, employee:)
    # Attributes check
    expected_attributes = ["description", "date", "amount", "location", "status"]
    expect(expected_attributes.all? { |attr| expense_returned.has_attribute?(attr) }).to be true

    # Values check
    expect(expense_returned.description).to eq(expense_expected[:description])
    expect(expense_returned.date).to eq(expense_expected[:date].to_date)
    expect(expense_returned.amount).to eq(expense_expected[:amount].to_f)
    expect(expense_returned.location).to eq(expense_expected[:location])
    expect(expense_returned.status).to eq(expense_expected[:status])

    # Tags check
    unless expense_expected[:tag_names].nil?
      expect(expense_returned.tags.count).to eq(expense_expected[:tag_names].count)
      expense_expected[:tag_names].each_with_index do |tag, index|
        expect(expense_returned.tags[index].description).to eq(tag)
      end
    end

    # Receipts check
    expect(expense_returned.receipt_nf.filename.to_s).to eq(expense_expected[:receipt_nf].original_filename)
    expect(expense_returned.receipt_card.filename.to_s).to eq(expense_expected[:receipt_card].original_filename)

    # Employee check
    expect(expense_returned.user).to eq(employee)

    # Manager check
    expect(expense_returned.manager_user).to eq(manager)
  end
end
