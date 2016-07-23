# Preview all emails at http://localhost:3000/rails/mailers/teacher_mailer
class TeacherMailerPreview < ActionMailer::Preview
  def teacher_send_password
    teacher = Teacher.find_by(:name => "akii")
    password = "xxxxxxxx"
    TeacherMailer.send_password(teacher, password)
  end

  def teacher_accept_student
    teacher = Teacher.first
    student = Student.first
    TeacherMailer.accept_student(teacher, student)
  end
  def student_accepted
    teachers = [Teacher.first, Teacher.last]
    student = Student.first
    StudentMailer.accepted(student, teachers)
  end
  def teacher_invite_coopTeacher
    teacher_co = Teacher.first
    teacher    = Teacher.last
    student    = Student.first
    TeacherMailer.invite_coopTeacher(teacher, student, teacher_co)
  end
end
