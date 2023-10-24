# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoviesFacade do
  before :each do
    @user_1 = User.create!(name: 'Lane', email: 'lane@example.com', password: '12345')
  end

  it 'exists and has readable attributes' do
    viewing_parties_facade = ViewingPartiesFacade.new({ movie_id: 238, user_id: @user_1.id, duration: 300, runtime: 175,
                                                        date: '2050-08-05', start_time: '12:00:00' })

    expect(viewing_parties_facade.movie_id).to eq(238)
    expect(viewing_parties_facade.user).to eq(@user_1)
    expect(viewing_parties_facade.duration).to eq(300)
    expect(viewing_parties_facade.runtime).to eq(175)
    expect(viewing_parties_facade.date).to eq('2050-08-05')
    expect(viewing_parties_facade.start_time).to eq('12:00:00')
    expect(viewing_parties_facade.params).to eq({ movie_id: 238, user_id: @user_1.id, duration: 300, runtime: 175,
                                                  date: '2050-08-05', start_time: '12:00:00' })
  end

  it '#movie' do
    viewing_parties_facade = ViewingPartiesFacade.new({ movie_id: 238, user_id: @user_1.id, duration: 300, runtime: 175,
                                                        date: '2050-08-05', start_time: '12:00:00' })

    VCR.use_cassette('testing_movie') do
      expect(viewing_parties_facade.movie).to be_a(MovieDetails)
    end
  end

  it '#duration_less_than_runtime' do
    viewing_parties_facade = ViewingPartiesFacade.new({ movie_id: 238, user_id: @user_1.id, duration: 300, runtime: 175,
                                                        date: '2050-08-05', start_time: '12:00:00' })

    expect(viewing_parties_facade.duration_less_than_runtime).to be(false)
  end

  it '#create_user_viewing_party' do
    user_2 = User.create!(name: 'Kaylee', email: 'Kaylee@example.com', password: '12345')
    user_3 = User.create!(name: 'George', email: 'george@example.com', password: '12345')
    viewing_parties_facade = ViewingPartiesFacade.new({ movie_id: 238, user_id: @user_1.id, duration: 300, runtime: 175,
                                                        date: '2050-08-05', start_time: '12:00:00', "#{user_2.id}": '1', "#{user_3.id}": '0' })

    expect(viewing_parties_facade.create_user_viewing_party).to be_an Array
    expect(viewing_parties_facade.create_user_viewing_party.count).to eq(3)
  end
end
