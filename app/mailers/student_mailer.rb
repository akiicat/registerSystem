class StudentMailer < ApplicationMailer
  # User::StudentsController#create
  # User::StudentsController#accept
  def accepted(student, teachers)
    @student      = student
    @teacher_name = Array.new
    teachers.each { |teacher| @teacher_name.push(teacher.name) }
    mail(to: %(#{@student.name} <#{@student.email}>), subject: '研究所師資管理系統 通知訊息')
  end

  # ----------- not use ----------------

  def destroy(student, teachers)
    @student      = student
    @teacher_name = Array.new
    teachers.each { |teacher| @teacher_name.push(teacher.name) }
    mail(to: %(#{@student.name} <#{@student.email}>), subject: '研究所師資管理系統 取消指導教授通知')
  end

  def replaced(student, from_teachers, to_teachers)
    @student           = student
    @from_teacher_name = Array.new
    @to_teacher_name   = Array.new

    from_teachers.each { |teacher| @from_teacher_name.push(teacher.name) }
    to_teachers.each   { |teacher| @to_teacher_name.push(teacher.name) }
    mail(to: %(#{@student.name} <#{@student.email}>), subject: '研究所師資管理系統 更換指導教授通知')
  end

private
                
end
