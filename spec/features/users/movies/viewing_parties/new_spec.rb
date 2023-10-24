# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'New Viewing Party Page', type: :feeature do
  before :each do
    @user_1 = User.create!(name: 'Jamie', email: '34@gmail.com', password: '12345')
    @user_2 = User.create!(name: 'Katie', email: '34997@gmail.com', password: '12345')
    @user_3 = User.create!(name: 'George', email: 'george@gmail.com', password: '12345')
  end

  feature 'As a user' do
    feature 'I should see the name of the movie title rendered above a form with fields' do
      scenario 'I see duration of party, when, start time, a list of users and a button to create a party' do
        VCR.use_cassette('godfather_movie_details') do
          visit "/users/#{@user_1.id}/movies/238/viewing_parties/new"

          expect(page).to have_content('The Godfather Viewing Party')
          expect(page).to have_content('Duration')
          expect(page).to have_field('duration', with: 175)
          expect(page).to have_content('When:')
          expect(page).to have_content('Start time')
          expect(page).to have_unchecked_field(@user_2.id.to_s)
          expect(page).to have_unchecked_field(@user_3.id.to_s)
          expect(page).to have_button('Create a Party')

          fill_in 'duration', with: 180
          fill_in 'date', with: '2023-11-16'
          fill_in 'start_time', with: '07:00:00'
          check @user_2.id.to_s

          expect(page).to have_checked_field(@user_2.id.to_s)
          expect(page).to have_unchecked_field(@user_3.id.to_s)
        end
      end
    end
  end

  feature 'As a user' do
    feature 'when I click create a party' do
      feature 'I should be redirected to my dashboard where I see the party listed' do
        scenario 'all other users should also have party listed on dashboard' do
          VCR.use_cassette('godfather_movie_details') do
            visit "/users/#{@user_1.id}/movies/238/viewing_parties/new"

            fill_in 'duration', with: 180
            fill_in 'date', with: '2023-11-16'
            fill_in 'start_time', with: '07:00:00'
            check @user_2.id.to_s
          end

          VCR.use_cassette('user_dashboard_page') do
            click_button 'Create a Party'
            expect(current_path).to eq user_path(@user_1.id)
          end
        end
      end
    end
  end

  feature 'As a user' do
    feature 'when I click create a party' do
      feature 'If duration entered is less than runtime ' do
        scenario 'I am rerouted to the form and I see a flash message with an error' do
          VCR.use_cassette('godfather_movie_details') do
            visit "/users/#{@user_1.id}/movies/238/viewing_parties/new"

            fill_in 'duration', with: 50
            fill_in 'date', with: '2023-11-23'
            fill_in 'start_time', with: '07:00:00'
            check @user_2.id.to_s
          end
          VCR.use_cassette('godfather_movie_details') do
            click_button 'Create a Party'
            expect(current_path).to eq("/users/#{@user_1.id}/movies/238/viewing_parties/new")
            expect(page).to have_content('Party duration cannot be less than movie runtime')
          end
        end
      end
    end
  end
end
