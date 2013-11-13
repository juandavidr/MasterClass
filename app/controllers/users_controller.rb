#require 'httparty'
require 'rubygems'
require 'json'

class UsersController < ApplicationController
  include HTTParty
  #  before_action :signed_in_user
  def ver
    @user = User.find(params[:id])
    @program = Program.find_by_id(params[:program_id])
    @programs = @user.programs.paginate(page: params[:page], :per_page => 3)
    @subject_records = @user.subject_records.paginate(page: params[:page])
    @preregister_subjects = @user.preregister_subjects.where(program_id: params[:program_id]).paginate(page: params[:page])
    @verusr = "1"

  end
  
  
  def cargar_usuarios
    response = self.class.get("http://184.72.239.150:3000/get_json")
    #    response.to_str
    @parsed_and_a_hash = JSON.parse(response.body)
    #    flash[:error]=@parsed_and_a_hash.count
    @parsed_and_a_hash.each do |key, value|
      #      flash[:error]=key
      #      Codigo de la maestria KEY
      @program = Program.find_by_code(key) 
      if @program.nil?
        Program.create!( name: "Edit me", code:key, objective:"Edit me", status:"Activo")
      end
      
      value.each do |key1,value1|
        #          Cada estudiante por codigo
        
        @codigo= key1
        @user1 = User.find_by_code(@codigo) 
       
        value1.each do |key2,value2|
          #            materias y nombre
         
          if(key2.eql?("subjects"))
          
            @subjects_arr=Array.new(value2.count)
            @subjects =value2
            @subjects.each do |sbj|
              @subjects_arr.push(sbj)
            end
            
          else if(key2.eql?("name"))
              @name = value2
            end
          end
        end
        if @user1.nil? 
          code=@codigo
          firstname=@name
          lastname='Edit me'
          password='123456'
          email='@uniandes.edu.co'
          email = @codigo+email
          identification='123456'
          begin
            User.create!(firstname:firstname, lastname:lastname, code:code, 
              identificationtype:"CC", identification:identification, status:"Activo", 
              usertype:"Estudiante", password:password, password_confirmation:password, email:email)
            
            @program = Program.find_by_code(key) 
            @user1 = User.find_by_code(@codigo) 
            user_programs = UserProgram.new(program_id: @program.id, user_id: @user1.id, status: "Activo")
            if user_programs.valid?
              user_programs.save
            else
              flash.now[:error] = 'No se puede guadar el programa del usuario'
              #@errors += user_programs.errors
            end 
          rescue
            logger.error($!.to_s)
          end
          #  TODO          crear materias no existentes
          #
          #          @subjects = Subject.all
          #            
          #          @subjects.each do |sbj|
          #            @encontro = false
          #            @subjects_arr.each do |sbjenc|
          #              if sbj.code.eql?(sbjenc) 
          #                @encontro = true
          #              end
          #            end
          #            if !@encontro
          #              begin
          #                Subject.create!(name: "Edit me", code:sbjenc, quota:30, credits:3, status:"Activo")
          #              rescue
          #                logger.error($!.to_s)
          #              end
          #            end
          #          end
          #          #            Asociar materias a estudiantes
          #          #            @subjects = TeacherSubject.joins(:user).joins(:subject).select("subjects.*")
          #          #              validates :user_id, presence: true
          #          #  validates :subject_id, presence: true
          #          #  validates :status, presence: true
          #          @subjects = TeacherSubject.joins(:user).joins(:subject).select("subjects.*")
          #            
          #          @user1 = User.find_by_code(@codigo)
          #            
          #          @subjects_arr.each do |sbjenc|
          #            @encontro = false
          #            @subjects.each do |sbj|
          #              if sbj.code.eql?(sbjenc) 
          #                @encontro = true
          #              end
          #            end
          #            if !@encontro
          #              @subject = Subject.find_by_code(sbjenc)
          #              TeacherSubject.create(user_id: @user1.id, subject_id: @subject.id, status: "Visto")
          #            end
          #          end
          #          
          #        else
          #          flash[:error] = "Actualizar usuario"
          #          
          #          user = User.find_by(code: @codigo)
          #          
          #          @usrssubj =  TeacherSubject.joins(:user).joins(:subject).select("subjects.*")
          
        end
      end
    end
    flash[:success]="Usuarios cargados exitosamente"
    redirect_to users_url
    
  end
  def new
    @user = User.new
  end

  def index
    @user_list =  User.paginate(page: params[:page]).per_page(10)
  end

  def edit
    @user = User.find(params[:id])
    @programs = @user.programs
    @programs_ids=Array.new(@programs.count)
    @programs.each do |program|
      @programs_ids.push(program.id)
    end
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
      
      UserMailer.welcome_email(@user).deliver
      
      params[:programs].each do |program|
        user_programs = UserProgram.new(program_id: program, user_id: @user.id, status: "Activo")
        if user_programs.valid?
          user_programs.save
          flash[:success] = 'Usuario creado exitosamente'
        else
          flash.now[:error] = 'No fue posible guardar los programas del usuario'
          #@errors += user_programs.errors
        end 
      end
     
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
        
      params[:programs].each do |program|
        user_programs = UserProgram.new(program_id: program, user_id: @user.id, status: "Activo")
        if user_programs.valid?
          user_programs.save          
        else
          flash.now[:error] = 'No fue posible guardar los programas del usuario'
          #@errors += user_programs.errors
        end 
      end
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
  
  def signed_in_user
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end
end
