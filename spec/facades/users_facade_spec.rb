# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoviesFacade do
  before :each do
    @user_1 = User.create!(name: 'Lane', email: 'lane@example.com', password: '12345')
  end

  it 'exists and has readable attributes' do
    users_facade = UsersFacade.new({ id: @user_1.id })

    expect(users_facade.id).to eq(@user_1.id)
    expect(users_facade.user).to eq(@user_1)
  end

  it '#invited_viewing_parties' do
    users_facade = UsersFacade.new({ id: @user_1.id })
    user_2 = User.create!(name: 'Kaylee', email: 'kaylee@example.com', password: '12345')
    viewing_party_1 = ViewingParty.create!(duration: 300, date: '2050-08-05', start_time: '12:00:00', movie_id: 238,
                                           host_user_id: user_2.id)
    UserViewingParty.create!(user_id: @user_1.id, viewing_party_id: viewing_party_1.id)

    expect(users_facade.invited_viewing_parties).to eq([viewing_party_1])
  end

  it '#hosted_viewing_parties' do
    users_facade = UsersFacade.new({ id: @user_1.id })
    user_2 = User.create!(name: 'Kaylee', email: 'kaylee@example.com', password: '12345')
    viewing_party_1 = ViewingParty.create!(duration: 300, date: '2050-08-05', start_time: '12:00:00', movie_id: 238,
                                           host_user_id: @user_1.id)
    UserViewingParty.create!(user_id: user_2.id, viewing_party_id: viewing_party_1.id)

    expect(users_facade.hosted_viewing_parties).to eq([viewing_party_1])
  end

  it '#invited_party_movie' do
    users_facade = UsersFacade.new({ id: @user_1.id })
    movie_id = 238

    VCR.use_cassette('testing_invited_party_movie') do
      expect(users_facade.party_movie(movie_id)).to be_a(MovieDetails)
    end
  end

  it '#poster_url' do
    users_facade = UsersFacade.new({ id: @user_1.id })
    movie_id = 238

    VCR.use_cassette('testing_poster_url') do
      expect(users_facade.poster_url(movie_id)).to be_a(String)
    end
  end
end
