# As a logged in user 
# When I visit the landing page
# I no longer see a link to Log In or Create an Account
# But I see a link to Log Out.
# When I click the link to Log Out
# I'm taken to the landing page
# And I can see that the Log Out link has changed back to a Log In link

require 'rails_helper'

RSpec.describe 'User Logout' do 
  it 'logs out a user' do
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

    visit '/'

    expect(page).not_to have_button("Log In")
    expect(page).not_to have_button("Create a New User")

    expect(page).to have_button("Log Out")

    click_on "Log Out"

    expect(page).to have_button("Log In")
    expect(page).to have_button("Create a New User")
  end
end
