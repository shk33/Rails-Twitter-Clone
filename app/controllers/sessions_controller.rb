class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      #redirct the user to show profile 
      login user
      remember user
      redirect_to user 
    else
      #Create an error mesage
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_url
  end

end
