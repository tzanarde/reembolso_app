# frozen_string_literal: true

module MatchHelpers extend RSpec::SharedContext
  def fill_form_sign_up(name: nil, email: nil, password: nil, password_confirmation: nil, user_role: nil, manager: nil)
    fill_in "user_name", with: name unless name.nil?
    fill_in "user_email", with: email unless email.nil?
    fill_in "user_password", with: password unless password.nil?
    fill_in "user_password_confirmation", with: password_confirmation unless password_confirmation.nil?
    select user_role, from: "role" unless user_role.nil?
    select manager, from: "manager_user_id" unless manager.nil?
  end

  def fill_form_sign_in(email: nil, password: nil)
    fill_in "user_email", with: email unless email.nil?
    fill_in "user_password", with: password unless password.nil?
  end

  def fill_form_forgot_password(email: nil)
    fill_in "user_email", with: email unless email.nil?
  end

  def fill_form_edit_user(name: nil, email: nil, password: nil, password_confirmation: nil, current_password: nil, user_role: nil, manager: nil)
    fill_in "user_name", with: name
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    fill_in "user_password_confirmation", with: password_confirmation
    fill_in "user_current_password", with: current_password
    select user_role, from: "role", match: :first
    select manager.name, from: "manager" if manager
  end

  def match_user_edited(user:, name: nil, email: nil, password: nil, password_confirmation: nil, current_password: nil, user_role: nil, manager: nil)
    expect(user.name).to eq(name)
    expect(user.email).to eq(email)
    expect(user.password).to eq(password)
    expect(user.password_confirmation).to eq(password_confirmation)
    expect(user.role).to eq(user_role)
  end

  def fill_form_new_expense(description: nil, date: nil, amount: nil, location: nil, tags: nil)
    fill_in "description", with: description, id: "description" unless description.nil?
    fill_in "date", with: date unless date.nil?
    fill_in "amount", with: amount unless amount.nil?
    fill_in "location", with: location unless location.nil?
    fill_in "tags", with: tags unless tags.nil?
  end
end
