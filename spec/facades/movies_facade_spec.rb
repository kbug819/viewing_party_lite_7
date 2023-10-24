# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoviesFacade do
  before :each do
    @user_1 = User.create!(name: 'Lane', email: 'lane@example.com', password: '12345')
  end

  it 'exists and has readable attributes' do
    movie_facade = MoviesFacade.new({ id: 1, title: 'The Dark Knight',
                                      top_movies: ['The Godfather', 'The Dark Knight', 'Good Will Hunting', 'The Shawshank Redemption'], user_id: @user_1.id })

    expect(movie_facade).to be_a(MoviesFacade)
    expect(movie_facade.movie_id).to eq(1)
    expect(movie_facade.movie_title).to eq('The Dark Knight')
    expect(movie_facade.top_movies).to eq(['The Godfather', 'The Dark Knight', 'Good Will Hunting',
                                           'The Shawshank Redemption'])
    expect(movie_facade.user).to eq(@user_1)
  end

  it '#discover_options with top movies' do
    movie_facade = MoviesFacade.new({ id: 1, title: nil,
                                      top_movies: ['The Godfather', 'The Dark Knight', 'Good Will Hunting', 'The Shawshank Redemption'], user_id: @user_1.id })

    VCR.use_cassette('testing_top_movies') do
      expect(movie_facade.discover_options).to be_an Array

      first_movie_details = movie_facade.discover_options.first
      last_movie_details = movie_facade.discover_options.last

      expect(first_movie_details).to be_a MovieDetails
      expect(last_movie_details).to be_a MovieDetails
    end
  end

  it '#discover_options with movie title' do
    movie_facade = MoviesFacade.new({ id: 1, title: 'The Dark Knight', top_movies: nil, user_id: @user_1.id })

    VCR.use_cassette('testing_movie_title_search') do
      expect(movie_facade.discover_options).to be_an Array

      first_movie_details = movie_facade.discover_options.first
      last_movie_details = movie_facade.discover_options.last

      expect(first_movie_details).to be_a MovieDetails
      expect(last_movie_details).to be_a MovieDetails
    end
  end

  it '#header with top movies' do
    movie_facade = MoviesFacade.new({ id: 1, title: nil,
                                      top_movies: ['The Godfather', 'The Dark Knight', 'Good Will Hunting', 'The Shawshank Redemption'], user_id: @user_1.id })

    expect(movie_facade.header).to eq('Top Movies')
  end

  it '#header with movie title' do
    movie_facade = MoviesFacade.new({ id: 1, title: 'The Dark Knight', top_movies: nil, user_id: @user_1.id })

    expect(movie_facade.header).to eq('Search Results')
  end

  it '#movie_details' do
    movie_facade = MoviesFacade.new({ id: 238, title: nil, top_movies: nil, user_id: @user_1.id })

    VCR.use_cassette('testing_movie_details') do
      expect(movie_facade.movie_details).to be_a(MovieDetails)
    end
  end

  it '#movie_credits' do
    movie_facade = MoviesFacade.new({ id: 238, title: nil, top_movies: nil, user_id: @user_1.id })

    VCR.use_cassette('testing_movie_credits') do
      expect(movie_facade.movie_credits).to be_a(MovieCredits)
    end
  end

  it '#movie_reviews' do
    movie_facade = MoviesFacade.new({ id: 238, title: nil, top_movies: nil, user_id: @user_1.id })

    VCR.use_cassette('testing_movie_reviews') do
      expect(movie_facade.movie_reviews).to be_a(MovieReviews)
    end
  end
end
