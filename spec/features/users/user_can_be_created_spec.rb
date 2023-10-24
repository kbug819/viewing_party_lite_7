# As a visitor 
# When I visit `/register`
# I see a form to fill in my name, email, password, and password confirmation.
# When I fill in that form with my name, email, and matching passwords,
# I'm taken to my dashboard page `/users/:id`

require 'rails_helper'

RSpec.describe 'User Registration Form' do 
  it 'creates a new user' do
    visit '/'

    click_on "Create a New User"

    expect(current_path).to eq(register_path)

    expect(page).to have_content('Register as a new User')
    expect(page).to have_content('Name')
    expect(page).to have_content('Email')
    expect(page).to have_content('Password')
    expect(page).to have_content('Password Confirmation')

    name = 'TTest Test'
    email = 'ttest@gmail.com'
    password = 'testing password'


    fill_in :name, with: name
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password

    click_on 'Register'

    expect(current_path).to eq(user_path(User.find_by(email: email)))

    expect(page).to have_content("Welcome, #{name}")
  end

#   As a visitor 
# When I visit `/register`
# and I fail to fill in my name, unique email, OR matching passwords,
# I'm taken back to the `/register` page
# and a flash message pops up, telling me what went wrong
  it 'checks to verify that passwords match' do
    visit '/'

    click_on "Create a New User"

    expect(current_path).to eq(register_path)

    name = 'TTest Test'
    email = 'ttest@gmail.com'
    password = 'testing password'


    fill_in :name, with: name
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: 'NOMATCH'

    click_on 'Register'

    expect(current_path).to eq(register_path)

    # expect(page).to have_content("Passwords must match, please try again")
  end

  it 'checks to verify that all needed information is added' do
    visit '/'

    click_on "Create a New User"

    expect(current_path).to eq(register_path)

    name = 'TTest Test'
    email = 'ttest@gmail.com'
    password = 'testing password'


    fill_in :name, with: name
    # fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password

    click_on 'Register'

    expect(current_path).to eq(register_path)

    expect(page).to have_content("Please enter all needed information to create an account")
  end
end

