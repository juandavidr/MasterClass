class TeacherSubjectsController < ApplicationController
  before_action :signed_in_user
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def destroy
  end

  def update
  end
  
  def signed_in_user
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end
end
