class SubjectController < ApplicationController
  def new
    @subject = Subject.new
  end

  def index
    @subject_list =Subject.paginate(page: params[:page]).per_page(10)
  end

  def edit
  end
  
  def disable
  
  end

  def create
    @subject = Subject.new(subject_params)    
    if @subject.save
      flash[:success] = 'Se ha guardado con éxito la materia'
      redirect_to programs_url
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
    redirect_to programs_url
  end

  def subject_params

  end
end
