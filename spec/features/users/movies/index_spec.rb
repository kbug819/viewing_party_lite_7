# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movies Result Page', type: :feature do
  before :each do
    @user_1 = User.create!(name: 'Jamie', email: '34@gmail.com', password: '12345')
    @user_2 = User.create!(name: 'Katie', email: '34997@gmail.com', password: '12345')
  end

  feature 'As a user' do
    feature 'When I visit the discover movie page' do
      feature 'and click on either the Top movies button ' do
        scenario 'I should be taken to the movies results page (users/:user_id/movies), where I see movie details' do
          visit "/users/#{@user_1.id}/discover"

          VCR.use_cassette('discover_movies_top_rated') do
            click_button 'Discover Top Rated Movies'
            expect(current_path).to eq("/users/#{@user_1.id}/movies")

            expect(page.status_code).to eq 200

            expect(page).to have_link('The Godfather')
            expect(page).to have_content('Vote Average: 8.7')
            expect(page).to have_link('Shawshank Redemption')
            expect(page).to have_content('Vote Average: 8.7')
            expect(page).to have_link('The Godfather Part II')
            expect(page).to have_content('Vote Average: 8.6')
            expect(page).to have_link('Seven Samurai')
            expect(page).to have_content('Vote Average: 8.5')
            expect(page).to have_link('Cinema Paradiso')
            expect(page).to have_content('Vote Average: 8.5')

            expect(page).to have_button('Return to Discover Page')
            click_button 'Return to Discover Page'

            expect(current_path).to eq("/users/#{@user_1.id}/discover")
          end
        end
      end
    end
  end

  feature 'When I visit the discover movie page' do
    feature 'and click on either the search button' do
      scenario 'I should be taken to the movies results page (users/:user_id/movies), where I see movie details' do
        visit "/users/#{@user_1.id}/discover"

        VCR.use_cassette('search_by_title') do
          fill_in :title, with: 'Fight Club'

          click_on 'Search by Movie Title'

          expect(current_path).to eq("/users/#{@user_1.id}/movies")

          expect(page).to have_link('Fight Club')
          expect(page).to have_content('Vote Average: 8.439')
          expect(page).to have_link('Zombie Fight Club')
          expect(page).to have_content('Vote Average: 5.607')
          expect(page).to have_link('Comedy Fight Club Live')
          expect(page).to have_content('Vote Average: 8.833')
          expect(page).to have_link('Brooklyn Girls Fight Club')
          expect(page).to have_content('Vote Average: 8.7')

          expect(page).to have_button('Return to Discover Page')
          click_button 'Return to Discover Page'

          expect(current_path).to eq("/users/#{@user_1.id}/discover")
        end
      end
    end
  end
end
