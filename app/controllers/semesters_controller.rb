class SemestersController < ApplicationController
  before_action :signed_in_user
  
  
  def new
    @semester = Semester.new
  end

  def index
    @semester_list =  Semester.paginate(page: params[:page],  :order => 'name DESC').per_page(10)
  end

  def edit
    @semester = Semester.find(params[:id])
  end

  def show
    if !params[:disable].nil?
      @semester = Semester.find(params[:id])
      if params[:disable] == "1"       
        @semester.update_attribute(:status, "Inactivo")
        flash[:success] = I18n.t('semester.deshabilitado') 
      else       
        @semester.update_attribute(:status, "Activo")
        flash[:success] = I18n.t('semester.habilitado')
      end
    end
    redirect_to semesters_url
  end
  
  def update
    @semester = Semester.find(params[:id])
    if @semester.update_attributes(semester_params)       
      flash[:success] = "La informacion del semestere se ha actualizado exitosamente"
      redirect_to semesters_url
    else
      flash[:error]="Ocurrio un error al editar el semestre"
      render 'edit'
    end
  end

  #  def create
  #    begin
  #      @semester = Semester.new(semester_params)    
  #      if @semester.save
  #        flash[:success] = 'El semestre ha sido almacenado con éxito'
  #        redirect_to semesters_url
  #      else     
  #        flash[:error] = 'Ha ocurrido un error'
  #        render 'new'
  #      end
  #    rescue
  #      logger.error($!.to_s)
  #    end
  #  end
 
  def create
    begin
      @semester = Semester.new(semester_params)  
    
      dateev = params[:startdate]
      @semester.startdate =  Time.zone.local(dateev[:year].to_i, dateev[:month].to_i, dateev[:day].to_i, 0)
      datefev = params[:finaldate]
      @semester.finaldate =  Time.zone.local(datefev[:year].to_i, datefev[:month].to_i, datefev[:day].to_i, 0)
      if @semester.save!
        flash[:success] = 'Se ha creado el semestre exitosamente'
        redirect_to semesters_url
      else     
        flash[:error] = 'Ha ocurrido un error al guardar el semestre'
        render 'new'
      end
    rescue
      logger.error($!.to_s)
      flash[:error] =$!.to_s
      render 'new'
    end
  end
  
  
  
  def semester_params
    params.require(:semester).permit(:name,:startdate,:finaldate,:status,:stype)
      
  end
  
  def signed_in_user
    redirect_to signin_url, notice: "Por favor ingrese antes de poder realizar esta acción" unless signed_in?
  end
end
