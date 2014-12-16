class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      #redirct the user to show profile 
      login user
      if params[:session][:remember_me] == '1'
        remember user
      else
        forget user
      end
      redirect_to user 
    else
      #Create an error mesage
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end

end
