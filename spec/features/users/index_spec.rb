# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Register', type: :feature do
  before :each do
    @user_1 = User.create!(name: 'Jamie', email: '34@gmail.com', password: '12345')
    @user_2 = User.create!(name: 'Katie', email: '34997@gmail.com', password: '12345')

    visit '/'
  end

  feature 'As a user' do
    feature 'When I click the add a new user button' do
      scenario "I'm routed to '/register' path and see a form to register" do
        expect(page).to have_button('Create a New User')
        click_button 'Create a New User'

        expect(current_path).to eq('/register')

        expect(page).to have_content('Name')
        expect(page).to have_content('Email (must be unique)')
        expect(page).to have_button('Register')

        fill_in 'Name', with: 'George'
        fill_in 'email', with: 'George@gmail.com'
        fill_in 'password', with: '234'
        fill_in 'password_confirmation', with: '234'
        click_button 'Register'

        user = User.find_by(name: 'George', email: 'George@gmail.com')
        expect(current_path).to eq user_path(user.id)
      end
    end
  end
end
