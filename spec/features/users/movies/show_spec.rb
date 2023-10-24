# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movie Details Page', type: :feature do
  before :each do
    @user_1 = User.create!(name: 'Jamie', email: '34@gmail.com', password: '12345')
    @user_2 = User.create!(name: 'Katie', email: '34997@gmail.com', password: '12345')
  end

  feature 'As a user' do
    feature 'When I visit a movies detail page, where :id is a valid user id' do
      scenario 'I should see a button to create a viewing party, a button to return to the discover page, the movie title, vote average of the movie, runtime in hours and minutes, genre(s) associated to the movie, summary description, the first 10 cast members, count of total reviews, each reviews author and information' do
        
        visit '/'
        expect(page).to have_button("Log In")
        click_button "Log In"
    
        expect(current_path).to eq('/login')
        expect(page).to have_content("Unique Email:")
        expect(page).to have_content("Password")
    
        fill_in :email, with: @user_1.email
        fill_in :password, with: @user_1.password
        click_on "Log In"
    
    
        expect(current_path).to eq(user_path(@user_1))
        expect(page).to have_content("Welcome, #{@user_1.name}")
        
        visit "/users/#{@user_1.id}/discover"

        VCR.use_cassette('discover_movies_top_rated') do
          click_button 'Discover Top Rated Movies'
        end

        VCR.use_cassette('godfather_movie_details') do
          click_link 'The Godfather'

          expect(current_path).to eq("/users/#{@user_1.id}/movies/238")

          expect(page).to have_content('The Godfather')
          expect(page).to have_content('Vote Average: 8.7')
          expect(page).to have_content('Runtime: 2 hours, 55 minutes')
          expect(page).to have_content('Genres:')
          expect(page).to have_content('Drama')
          expect(page).to have_content('Crime')
          expect(page).to have_content('Summary: Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.')
          expect(page).to have_content('Cast:')
          expect(page).to have_content('Don Vito Corleone - Marlon Brando')
          expect(page).to have_content('Michael Corleone - Al Pacino')
          expect(page).to have_content('Sonny Corleone - James Caan')
          expect(page).to have_content('Tom Hagen - Robert Duvall')
          expect(page).to have_content('Clemenza - Richard S. Castellano')
          expect(page).to have_content('Kay Adams - Diane Keaton')
          expect(page).to have_content('Connie Corleone Rizzi - Talia Shire')
          expect(page).to have_content('Carlo Rizzi - Gianni Russo')
          expect(page).to have_content('Captain McCluskey - Sterling Hayden')
          expect(page).to have_content('Jack Woltz - John Marley')
          expect(page).to have_content('Number of Reviews: 5')
          expect(page).to have_content('Reviews:')
          expect(page).to have_content('Author: futuretv')
          expect(page).to have_content('The Godfather Review by Al Carlson')
          expect(page).to have_content('The Godfather is a movie you can’t refuse.')
          expect(page).to have_content('Author: Suresh Chidurala')
          expect(page).to have_content('Great Movie **Ever**')

          expect(page).to have_button('Return to Discover Page')
          click_button 'Return to Discover Page'
          expect(current_path).to eq("/users/#{@user_1.id}/discover")
        end

        VCR.use_cassette('discover_movies_top_rated') do
          click_button 'Discover Top Rated Movies'
        end

        VCR.use_cassette('godfather_movie_details') do
          click_link 'The Godfather'

          expect(page).to have_button('Create a Viewing Party')
        end

        VCR.use_cassette('godfather_viewing_party') do
          click_button 'Create a Viewing Party'
          expect(current_path).to eq("/users/#{@user_1.id}/movies/238/viewing_parties/new")
        end
      end
    end
  end
end
