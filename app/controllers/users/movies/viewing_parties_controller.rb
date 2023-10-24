# frozen_string_literal: true

module Users
  module Movies
    class ViewingPartiesController < ApplicationController
      def new
        if current_user
          @facade = ViewingPartiesFacade.new(params)
        else
          flash[:error] = 'Must be logged in or registered to create a movie party'
          redirect_to user_movie_path(params[:user_id], params[:movie_id])
        end
      end

      def create
        @facade = ViewingPartiesFacade.new(params)
        if @facade.duration_less_than_runtime
          redirect_to new_user_movie_viewing_party_path(params[:user_id], params[:movie_id])
          flash[:error] = 'Party duration cannot be less than movie runtime'
        else
          @facade.create_user_viewing_party
          redirect_to user_path(params[:user_id])
        end
      end
    end
  end
end
