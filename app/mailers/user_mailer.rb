class UserMailer < ActionMailer::Base
  default from: "juandavidr@gmail.com"
  
  def welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000/'
    mail(to: @user.email, subject: 'Bienvenido a MasterClass!')
  end
  
  def notification_quota_email(program_id,preregister_subject)
    @preregister_subject = preregister_subject
    @subject = Subject.find_by_id(@preregister_subject.subject_id)
    @user = Program.find_by_id(program_id).user
    mail(to: @user.email, subject: 'Se ha sobre pasado la quota!')
  end
  
end
