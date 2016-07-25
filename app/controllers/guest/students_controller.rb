class Guest::StudentsController < Guest::ApplicationController
  layout 'print'
  def show
    @student   = Student.find_by(:confirm => params[:id])
    @studentID = (@student.studentID) ? @student.studentID   : ''
    @group     = (@student.group)     ? @student.group.group : ''
    @time      = Time.now
    

    @teachers = Array.new
    @replaced = Array.new
    v1 = @student.vacancy_id
    v2 = @student.coop_vacancy_id
    r1 = @student.replaced_id
    r2 = @student.coop_replaced_id
    [v1, v2].compact.each do |vacancy_id|
      teacher = Vacancy.find(vacancy_id).teacher
      @teachers.push(teacher.name)
    end
    [r1, r2].compact.each do |teacher_id|
      teacher = Teacher.find(teacher_id)
      @replaced.push(teacher.name)
    end

    respond_to do |format|
      format.html do
        @page_title = "#{@student.name}_#{@student.year}_#{@group[0..3]}_#{@student.confirm[0..7]}"
      end
    end
  end
end
