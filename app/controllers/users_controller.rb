class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    @user_list =  User.paginate(page: params[:page]).per_page(10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    if !params[:disable].nil?
      if params[:disable] == "1"
         @user = User.find(params[:id])
         @user.update_attribute(:status, "Inactivo")
         flash[:success] = I18n.t('usuario.deshabilitado') 
      else
         @user = User.find(params[:id])
         @user.update_attribute(:status, "Activo")
         flash[:success] = I18n.t('usuario.habilitado')
      end
    end
    redirect_to users_url
  end
  
  def create
    @user = User.new(user_params)    
    if @user.save
      flash[:success] = 'Mensaje de exito'
      redirect_to users_url
    else
      if @user.code.nil?
        flash[:error] = 'no hay codigo de usuario, por favor ingreselo'
        elseif @user.password.nil
        flash[:error] = 'el password no puede ser vacio'
      else
      end
      render 'new'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = I18n.t('usuario.eliminado') 
    redirect_to users_url
  end
  
  def disable
    @user = User.find(params[:id])
    @user.update_attribute(:status, "Inactivo")
    flash[:success] = I18n.t('usuario.deshabilitado') 
 
     
  end
  
  def user_params
    params.require(:user).permit(:firstname,:lastname,:code,:identificationtype,:identification,:status,:usertype, :email, 
      :password,:password_confirmation)
      
  end
end
