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
  
  def update
    @user = User.find(params[:id])  
      if @user.update_attributes(user_params)
        
#            params[:programs].each do |program|
#            user_programs = UserProgram.new(program_id: program, user_id: @user.id, status: "Activo")
#            if user_programs.valid?
#              user_programs.save
#            else
#              flash.now[:error] = 'Cant save user program'
#              #@errors += user_programs.errors
#            end 
#        end
        flash[:success] = "La informacion del usuario se ha actualizado exitosamente"
#        sign_in @user
        redirect_to users_url
      else
        flash[:error]="Ocurrio un error al editar el usuario"
        render 'edit'
      end
  end
  
  def user_params
    params.require(:user).permit(:firstname,:lastname,:code,:identificationtype,:identification,:status,:usertype, :email, 
      :password,:password_confirmation)
      
  end
end
