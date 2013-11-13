class RegisterSubjectsController < ApplicationController
  def index
  end

  def edit
  end

  def create
  end
  
  def signed_in_user
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end
end
