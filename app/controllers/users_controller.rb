# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    # @user = User.new
  end

  def show
    if current_user
      @facade = UsersFacade.new(params)
    else
      redirect_to '/'
      flash[:error] = "You must be logged in or registered to access user dashboard" unless current_user
    end
  end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    new_user = User.create(user_params)
    if new_user.save
      session[:user_id] = new_user.id
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
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}"
      redirect_to user_path(user.id)
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    end
  end

  def log_out
    session[:user_id] = nil
    flash[:success] = "You've been logged out"
    redirect_to "/"
  end

  private


  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
