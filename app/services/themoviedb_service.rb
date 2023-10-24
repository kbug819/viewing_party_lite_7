# frozen_string_literal: true

class ThemoviedbService
  def poster_image_base_url
    response = connection.get("/3/configuration?api_key=#{Rails.application.credentials.config[:themoviedb][:key]}")
    JSON.parse(response.body, symbolize_names: true)[:images]
  end

  def movie_details(movie_id)
    response = connection.get("/3/movie/#{movie_id}?api_key=#{Rails.application.credentials.config[:themoviedb][:key]}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def movie_credits(movie_id)
    response = connection.get("/3/movie/#{movie_id}/credits?api_key=#{Rails.application.credentials.config[:themoviedb][:key]}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def movie_reviews(movie_id)
    response = connection.get("/3/movie/#{movie_id}/reviews?api_key=#{Rails.application.credentials.config[:themoviedb][:key]}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def movie_titles(title)
    response = connection.get("/3/search/movie?query=#{title}&api_key=#{Rails.application.credentials.config[:themoviedb][:key]}")
    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  def top_movies
    response = connection.get("/3/movie/top_rated?api_key=#{Rails.application.credentials.config[:themoviedb][:key]}")
    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  def connection
    Faraday.new(url: 'https://api.themoviedb.org')
  end
end
