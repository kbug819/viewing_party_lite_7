# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    # @user = User.new
  end

  def show
    @facade = UsersFacade.new(params)
  end

  def create
    # if params[:password] == params[:password_confirmation]
      user = user_params
      user[:email] = user[:email].downcase
      new_user = User.new(user_params)
      new_user.save
      if new_user.save
        flash[:success] = "Welcome, #{new_user.name}"
        redirect_to user_path(new_user.id)
      else !new_user.save
        redirect_to register_path
        flash[:error] = 'Please enter all needed information to create an account'
      end
    # else
    #   redirect_to register_path
    #   flash[:error] = 'Passwords must match, please try again'
    # end
  end

  def login_form
  end

  def login_user
    user = User.find_by(email: params[:email])
    if user.class == User
      if user.authenticate(params[:password])
        flash[:success] = "Welcome, #{user.name}"
        redirect_to user_path(user.id)
      else
        flash[:error] = "Sorry, your credentials are bad."
        render :login_form
      end
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
