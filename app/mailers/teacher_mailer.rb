class TeacherMailer < ApplicationMailer
  # Admin::TeachersController#sends
  def send_password(teacher, password)
    @teacher  = teacher
    @password = password
    mail(to: %(#{@teacher.name} <#{@teacher.email}>), subject: '研究所師資管理系統 寄送新的帳號密碼')
  end

  # User::StudentsController#create
  # User::StudentsController#accept
  def accept_student(teacher, student, teacher_co = nil)
    @teacher = teacher
    @student = student
    @teacher_co = teacher_co
    mail(to: %(#{@teacher.name} <#{@teacher.email}>), subject: '研究所師資管理系統 通知訊息')
  end

  # User::StudentsController#create
  def invite_coopTeacher(teacher, student, teacher_co)
    @teacher    = teacher
    @student    = student
    @teacher_co = teacher_co
    mail(to: %(#{@teacher.name} <#{@teacher.email}>), subject: "研究所師資管理系統 共同指導邀請通知")
  end

  def cancel_student(teacher, student)
    @teacher    = teacher
    @student    = student
    mail(to: %(#{@teacher.name} <#{@teacher.email}>), subject: "研究所師資管理系統 取消指導關係通知")
  end
  
  # ----------- not use ----------------

  def reject_coopTeacher(teacher, student, teacher_co)
    @teacher    = teacher
    @student    = student
    @teacher_co = teacher_co
    mail(to: %(#{@teacher.name} <#{@teacher.email}>), subject: "研究所師資管理系統 共同指導拒絕邀請通知")
  end

  def replace_student(teacher, student, from_teachers, to_teachers)
    @teacher           = teacher
    @student           = student
    @from_teacher_name = Array.new
    @to_teacher_name   = Array.new

    from_teachers.each { |teacher| @from_teacher_name.push(teacher.name) }
    to_teachers.each   { |teacher| @to_teacher_name.push(teacher.name) }
    mail(to: %(#{@teacher.name} <#{@teacher.email}>), subject: '研究所師資管理系統 更換指導教授通知')
  end


private

                
end
