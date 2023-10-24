# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Discover', type: :feature do
  before :each do
    @user_1 = User.create!(name: 'Jamie', email: '34@gmail.com', password: '12345')
  end

  feature 'As a user' do
    feature "When I go to a user dashboard and click the 'Discover Movies' button" do
      scenario 'it redirects to a discover page, where :id is the user_id of the user whose dashboard I was just on' do
        visit '/'

        expect(page).to have_button("Log In")
        click_button "Log In"
    
        fill_in :email, with: @user_1.email
        fill_in :password, with: @user_1.password
        click_on "Log In"
    
    
        expect(current_path).to eq(user_path(@user_1))
        expect(page).to have_content("Welcome, #{@user_1.name}")
        
        click_button 'Discover Movies'

        expect(current_path).to eq("/users/#{@user_1.id}/discover")

        expect(page).to have_content('Discover Movies')
      end
    end

    feature 'When I visit the discover movies page, where :id, is the id of a valid user' do
      scenario 'I see a button to discover Top Rated Movies' do
        visit "/users/#{@user_1.id}/discover"

        expect(page).to have_button('Discover Top Rated Movies')
      end

      scenario 'I see a text field to enter keyword(s) to search by movie title, and a button to search by movie title' do
        visit "/users/#{@user_1.id}/discover"

        expect(page).to have_content('Movie title')

        expect(page).to have_field(:title)

        expect(page).to have_button('Search by Movie Title')

        fill_in :title, with: 'Fight Club'
      end
    end
  end
end
