# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Welcome', type: :feature do
  before :each do
    @user_1 = User.create!(name: 'Jamie', email: '34@gmail.com', password: '12345')
    @user_2 = User.create!(name: 'Katie', email: '34997@gmail.com', password: '12345')

    visit '/'
  end

  describe 'As a user' do
    describe 'When I visit the root path' do
      it 'displays the title of the application' do
        expect(page).to have_content('Viewing Party')
      end

      it 'displays a button to create a new user' do
        expect(page).to have_button('Create a New User')
      end

      it 'displays a list of existing users and a link to each users dashboard' do
        expect(page).to have_link(@user_1.name.to_s)
        expect(page).to have_link(@user_2.name.to_s)
      end

      it 'displays a link to go back to the landing page' do
        expect(page).to have_link('Back to Viewing Party Home Page')

        click_link 'Back to Viewing Party Home Page'

        expect(current_path).to eq('/')
      end
    end
  end
end
