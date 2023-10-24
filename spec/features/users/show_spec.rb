# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user show page', type: :feature do
  before :each do
    @user_1 = User.create!(name: 'Jamie', email: '34@gmail.com', password: '12345')
    @user_2 = User.create!(name: 'Katie', email: '34997@gmail.com', password: '12345')
    @user_3 = User.create!(name: 'George', email: 'george@gmail.com', password: '12345')
    @viewing_party_1 = ViewingParty.create!(duration: 180, date: '2023-05-14', start_time: '07:00:00', movie_id: 238,
                                            host_user_id: @user_2.id)
    @viewing_party_2 = ViewingParty.create!(duration: 180, date: '2023-05-16', start_time: '07:00:00', movie_id: 155,
                                            host_user_id: @user_1.id)
    UserViewingParty.create!(user: @user_1, viewing_party: @viewing_party_1)
    UserViewingParty.create!(user: @user_3, viewing_party: @viewing_party_1)
    UserViewingParty.create!(user: @user_2, viewing_party: @viewing_party_2)
    UserViewingParty.create!(user: @user_3, viewing_party: @viewing_party_2)
  end

  feature 'As a user' do
    feature 'When I access my user show page' do
      scenario "I see the user's name, a button to discover movies and a list of viewing parties I am invited to, as well as a list of viewing parties I am hosting" do
        visit '/'
        expect(page).to have_button("Log In")
        click_button "Log In"
    
        expect(current_path).to eq('/login')
        expect(page).to have_content("Unique Email:")
        expect(page).to have_content("Password")
    
        fill_in :email, with: @user_1.email
        fill_in :password, with: @user_1.password
        VCR.use_cassette('user_dashboard_page_1') do
        click_on "Log In"
    
    
        expect(current_path).to eq(user_path(@user_1))
        expect(page).to have_content("Welcome, #{@user_1.name}")
        
          visit "/users/#{@user_1.id}"
        end

        VCR.use_cassette('discover_movies') do
          expect(page).to have_content("#{@user_1.name}'s Dashboard")
          expect(page).to have_content("User email: #{@user_1.email}")
          expect(page).to have_button('Discover Movies')
          within('.party_invitations') do
            expect(page).to have_content('Viewing Party Invitations')
          end

          within('.hosted_parties') do
            expect(page).to have_content("Viewing Parties I'm Hosting")
          end
        end
      end

      feature 'and I look at my viewing party invitations' do
        scenario 'I see the movie image, the movie title (which links to that movies show page), the date and time of the party, who is hosting the event, and the list of users invited (with my name in bold)' do
          VCR.use_cassette('user_dashboard_page_2') do
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
          end

          VCR.use_cassette('poster_base_url') do
            within('.party_invitations') do
              find("img[src='http://image.tmdb.org/t/p/w92/3bhkrj58Vtu7enYsRolD1fZdja1.jpg']")
              expect(page).to have_link('The Godfather')
            end
          end

          within('.party_invitations') do
            VCR.use_cassette('invited_parties') do
              expect(page).to have_content("When: #{@viewing_party_1.date.strftime('%-m/%-d/%y')}")
              expect(page).to have_content("Start Time: #{@viewing_party_1.start_time.strftime('%I:%M:%S')}")
              expect(page).to have_content("Host: #{@user_2.name}")
              expect(page).to have_content('Invitees:')
              expect(page).to have_content(@user_1.name.to_s)
              expect(page).to have_content(@user_3.name.to_s)
              expect(page).to have_css('strong', text: @user_1.name.to_s, visible: true)
              click_link('The Godfather')
            end
          end
          expect(current_path).to eq("/users/#{@user_1.id}/movies/238")
        end
      end

      feature "and I look at the viewing parties I'm hosting" do
        scenario 'I see the movie image, the movie title (which links to that movies show page), the date and time of the party, that I am hosting the event, and the list of users invited' do
          VCR.use_cassette('user_dashboard_page_3') do
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
          end
          VCR.use_cassette('hosted_parties') do
            within('.hosted_parties') do
              find("img[src='http://image.tmdb.org/t/p/w92/qJ2tW6WMUDux911r6m7haRef0WH.jpg']")
              expect(page).to have_link('The Dark Knight')
              expect(page).to have_content("When: #{@viewing_party_2.date.strftime('%-m/%-d/%y')}")
              expect(page).to have_content("Start Time: #{@viewing_party_2.start_time.strftime('%I:%M:%S')}")
              expect(page).to have_content('Host: I am hosting')
              expect(page).to have_content('Invitees:')
              expect(page).to have_content(@user_2.name.to_s)
              expect(page).to have_content(@user_3.name.to_s)
              click_link('The Dark Knight')
            end
            expect(current_path).to eq("/users/#{@user_1.id}/movies/155")
          end
        end
      end
    end
  end
end
