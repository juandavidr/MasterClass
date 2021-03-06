class PreregisterSubjectsController < ApplicationController
  def new
    @preregister_subject = PreregisterSubject.new(user_id: params[:user_id])
    @subjects = Program.find_by_id(params[:program_id]).subjects.compact

    @pregistered_subjects = PreregisterSubject.where(user_id: params[:user_id])

    @pregistered_subjects.each do |pregistered_subject|
      @subject = Subject.find_by_id(pregistered_subject.subject_id)
      @subjects.delete(@subject)

    end

    @semesters = Program.find_by_id(params[:program_id]).semesters.where("startdate > ?", Time.now)
    @user_id = params[:user_id]
    @program_id = params[:program_id]
  end
  
  def edit
    @preregister_subject = PreregisterSubject.find(params[:id])
    @subjects = Program.find_by_id(params[:program_id]).subjects.compact
    @semesters = Program.find_by_id(params[:program_id]).semesters
    @user_id = params[:user_id]
    @program_id = params[:program_id]
  end
  
  def index
    
    @user = User.find_by_id(params[:user_id])
    @program = Program.find_by_id(params[:program_id])    

    redirect_to users_mostrar_path(@user,@program, :id => @user.id,:program_id =>@program.id)
    #redirect_to @user
    
  end

  def create

    @user = User.find_by_id(params[:user_id])
    if(!PreregisterSubject.where(user_id: params[:user_id],subject_id: params[:subject_id]).exists?)
      
      @preregister_subject = PreregisterSubject.new(user_id: params[:user_id], semester_id: params[:semester_id], subject_id: params[:subject_id],status: preregister_subject_params[:status], program_id: params[:program_id])

      if @preregister_subject.save
        @preregister_subject_total = PreregisterSubject.where(semester_id: params[:semester_id],subject_id: params[:subject_id])
        if(@preregister_subject_total.exists?)
  
          @subject = Subject.find_by_id(params[:subject_id])
          if(@preregister_subject_total.count > @subject.quota)
            UserMailer.notification_quota_email(params[:program_id],@preregister_subject).deliver
          end
        end
        flash[:success] = "Materia registrada con Exito"
      else
        flash[:error] = 'Error al guardar el registro'
      end
    else
      flash[:error] = 'La materia ya esta preinscrita'
    end
    redirect_to user_path(@user, params)
  end

  def update

    if !params[:automatic].nil? && params[:automatic] == "1"
      @user = User.find_by_id(params[:user_id])
      @subjects_programs = Program.find_by_id(params[:program_id]).subject_programs
   

      total_semesters = 6
      subjects_per_semester = 2
      @semesters = Program.find_by_id(params[:program_id]).semesters.where("startdate > ?", Time.now).order("startdate").limit(total_semesters)
      #aca primero se traen las materias registradas por semestre y se seleccionan las que menos ocupacion tengan
     
      semester_number = 0
      logger.info "total semesters:"+@semesters.count.to_s
      @semesters.each do |semester|
        semester_number = semester_number + 1
        if semester.stype == "normal"
          subjects_per_semester = 2
          @subjects2 = Subject.all :joins => [:subject_programs, :subject_semesters],:conditions => {'subject_semesters.semester_id' => semester.id,'subject_programs.subjecttype' => "Opcional",'subject_programs.program_id' => params[:program_id]}
        else
          subjects_per_semester = 1
          @subjects2 = Subject.all :joins => [:subject_programs, :subject_semesters],:conditions => {'subject_semesters.semester_id' => semester.id,'subject_programs.subjecttype' => "Electiva",'subject_programs.program_id' => params[:program_id]}           
        end

            
        @subjects_ocupation = Subject.count :joins => [:preregister_subjects],:conditions => {'preregister_subjects.semester_id' => semester.id,'preregister_subjects.program_id' => params[:program_id]},:group => "subjects.id"

        subject_students = Hash.new
        logger.info "total available subjects:"+@subjects2.count.to_s+" semester:"+semester.name
        @subjects2.each do |subject|
          students = @subjects_ocupation[subject.id]
          if students.nil?
            students = 0
          end
          subject_students[subject.id]=students
        end
        logger.info "students hash by subject:"+subject_students.to_s
        suggested_subject = subject_students.sort_by{ |subject_id, students| students }
        k = 0
        suggested_subject.each do |subject_id,student|
              
          if semester_number == total_semesters
            logger.info "suggested subject register: "+subject_id.to_s+" "+@user.id.to_s+" "+semester.id.to_s
            @preregister_subject= PreregisterSubject.new(user_id: @user.id, semester_id: semester.id, subject_id: subject_id,status: "Pendiente",program_id:params[:program_id])
            @preregister_subject.save
            @subjects2 = Subject.all :joins => [:subject_programs, :subject_semesters],:conditions => {'subject_semesters.semester_id' => semester.id,'subject_programs.subjecttype' => "Obligatoria",'subject_programs.program_id' => params[:program_id]} 
            logger.info "last semester register mandatory subject: "+@subjects2[0].name
            @preregister_subject2= PreregisterSubject.new(user_id: @user.id, semester_id: semester.id, subject_id: @subjects2[0].id,status: "Pendiente",program_id:params[:program_id]) 
            @preregister_subject2.save
            break
          else
            if k < subjects_per_semester
              logger.info "suggested subject register: "+subject_id.to_s+" "+@user.id.to_s+" "+semester.id.to_s
              k = k+1
              @preregister_subject= PreregisterSubject.new(user_id: @user.id, semester_id: semester.id, subject_id: subject_id,status: "Pendiente",program_id:params[:program_id])
              @preregister_subject.save
            else
              break
            end
          end
        end  
                    
      end
      flash[:success] = "Pensum Registrado con Exito"
    else
      @preregister_subject = PreregisterSubject.find_by_id(params[:id])
      @user = User.find_by_id(params[:user_id])  
      if @preregister_subject.update_attributes(preregister_subject_params)
        flash[:success] = "Info updated"
      else
        render 'edit'
      end

    end

    redirect_to user_path(@user, params)
  end

  def destroy
    #@user = User.find(preregister_subject_params[:user_id])
    if !params[:all].nil? && params[:all] == "1"
      @user = User.find_by_id(params[:user_id])
      @pregistered_subjects = @user.preregister_subjects.where(program_id: params[:program_id])
       
      @pregistered_subjects.each do |pregistered_subject|
        semester = Semester.find_by_id(pregistered_subject.semester_id)
        if semester.startdate > Time.now 
          pregistered_subject.destroy
        end  
      end
      flash[:success] = "Materias eliminadas."
    else
      PreregisterSubject.find(params[:id]).destroy
      flash[:success] = "Materia elminada."

    end
    
    redirect_to :back
  end

  private

  def preregister_subject_params
    params.require(:preregister_subject).permit(:user_id,:status,:semester_id,:subject_id,:program_id)
  end

end
