class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    @user_list =  User.paginate(page: params[:page]).per_page(10)
  end

  def edit
  end

  def show
  end
  
  def create
    @user = User.new(user_params)    
    if @user.save
      flash[:success] = 'Mensaje de exito'
      redirect_to @user
    else
      flash[:error] = 'Mensaje de error'
      render 'new'
    end
  end
  
   def user_params
      params.require(:user).permit(:firstname,:lastname,:code,:identificationtype,:identification,:status,:usertype, :email, 
      :password,:password_confirmation)
      
    end
end
