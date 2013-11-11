class ProgramsController < ApplicationController
  def new
    @program = Program.new
  end

  def index
    @program_list =  Program.paginate(page: params[:page]).per_page(10)
  end

  def edit
     @program = Program.find(params[:id])
  end
  
  def show
     if !params[:disable].nil?
         @program = Program.find(params[:id])
      if params[:disable] == "1"       
         @program.update_attribute(:status, "Inactivo")
         flash[:success] = I18n.t('programa.deshabilitado') 
      else       
         @program.update_attribute(:status, "Activo")
         flash[:success] = I18n.t('programa.habilitado')
      end
    end
    redirect_to programs_url
  end
  
  def update
      @program = Program.find(params[:id])
      if @program.update_attributes(program_params)       
        flash[:success] = "La informacion del programa se ha actualizado exitosamente"
        redirect_to programs_url
      else
        flash[:error]="Ocurrio un error al editar el usuario"
        render 'edit'
      end
  end

  def create
    @program = Program.new(program_params)    
    if @program.save
      flash[:success] = 'Mensaje de exito'
      redirect_to programs_url
    else     
       flash[:error] = 'Ha ocurrido un error'
      render 'new'
    end
  end
  
  
  
  def program_params
    params.require(:program).permit(:name,:code,:objective,:status)
      
  end
end
