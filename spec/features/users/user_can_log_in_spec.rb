# As a registered user
# When I visit the landing page `/`
# I see a link for "Log In"
# When I click on "Log In"
# I'm taken to a Log In page ('/login') where I can input my unique email and password.
# When I enter my unique email and correct password 
# I'm taken to my dashboard page

require 'rails_helper'

RSpec.describe 'User can Log In' do 
  it 'allows user to log in' do
    user_1 = User.create!(name: "Jojo", email: 'jj@gmail.com', password: '12345')
    
    visit '/'
    expect(page).to have_button("Log In")
    click_button "Log In"

    expect(current_path).to eq('/login')
    expect(page).to have_content("Unique Email:")
    expect(page).to have_content("Password")

    fill_in :email, with: user_1.email
    fill_in :password, with: user_1.password
    click_on "Log In"


    expect(current_path).to eq(user_path(user_1))
    expect(page).to have_content("Welcome, #{user_1.name}")
  end

  # As a registered user
  # When I visit the landing page `/`
  # And click on the link to go to my dashboard
  # And fail to fill in my correct credentials 
  # I'm taken back to the Log In page
  # And I can see a flash message telling me that I entered incorrect credentials. 

  it "redirects user if they don't enter a correct email" do
    user_1 = User.create!(name: "Jojo", email: 'jj@gmail.com', password: '12345')


    visit '/'
    expect(page).to have_button("Log In")
    click_button "Log In"

    expect(current_path).to eq('/login')
    expect(page).to have_content("Unique Email:")
    expect(page).to have_content("Password")

    fill_in :email, with: "NOMATCH@GMAIL.com"
    fill_in :password, with: user_1.password
    click_on "Log In"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Sorry, your credentials are bad.")
  end

  it "redirects user if they don't enter a correct password" do
    user_1 = User.create!(name: "Jojo", email: 'jj@gmail.com', password: '12345')


    visit '/'
    expect(page).to have_button("Log In")
    click_button "Log In"

    expect(current_path).to eq('/login')
    expect(page).to have_content("Unique Email:")
    expect(page).to have_content("Password")

    fill_in :email, with: user_1.email
    fill_in :password, with: "NOMATCH"
    click_on "Log In"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Sorry, your credentials are bad.")
  end

end