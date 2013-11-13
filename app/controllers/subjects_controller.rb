class SubjectsController < ApplicationController
  before_action :signed_in_user
  def new
    @subject = Subject.new
  end

  def index
    @subject_list =Subject.paginate(page: params[:page]).per_page(10)
  end

  def edit
    @subject =  Subject.find_by_id(params[:id])
  end
  
  def update
    @subject = Subject.find_by_id(params[:id])
    if @subject.update_attributes(subject_params)
      #        Actualizar programas a los que pertenece la materia
      flash[:success] = "Subject was updated"
      redirect_to subjects_path
    else
      flash[:success] = "Ocurrio un error actualizando al usuario"
      render "edit"
    end
  end
  
  def disable  
  end
  
  def show
    if !params[:disable].nil?
      @subject = Subject.find_by_id(params[:id])
      if params[:disable] == "1"
     
        @subject.update_attribute(:status, "Inactivo")
        flash[:success] = I18n.t('subject.deshabilitado') 
      else
        
        @subject.update_attribute(:status, "Activo")
        flash[:success] = I18n.t('subject.habilitado')
      end
    end
    redirect_to subjects_url
  end

  def create
    @subject = Subject.new(subject_params)    
    if @subject.save
      flash[:success] = 'Se ha guardado con éxito la materia'
      redirect_to subjects_url
    else
      if @subject.code.nil?
        flash[:error] = 'no hay codigo de programa, por favor ingreselo'    
      end
      render 'new'
    end
  end

  def destroy
    Subject.find(params[:id]).destroy
    flash[:success] = I18n.t('subject.eliminado') 
    redirect_to subjects_url
  end

  def subject_params
    params.require(:subject).permit(:name,:code,:quota,:credits,:status)
  end
  
  def signed_in_user
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end
end
