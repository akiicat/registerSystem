class Guest::StudentsController < Guest::ApplicationController
  
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
      format.pdf do
        report = nil

        # don't used add_field :replaced
        # :replaced is reserved in liberconv
        replace_field = lambda do |r|
          r.add_field :student    , @student.name
          r.add_field :teacherre , @replaced.join('、')
          r.add_field :teacher    , @teachers.join('、')

          r.add_field :student_id , @studentID
          r.add_field :group      , @group
          r.add_field :year       , @time.year
          r.add_field :month      , @time.month
          r.add_field :day        , @time.day
        end

        # gem 'odf-report'
        if @student.repl
          report = ODFReport::Report.new("#{Rails.root}/lib/odt_templates/contract_replace.odt") {|r| replace_field.call(r)}
        else
          report = ODFReport::Report.new("#{Rails.root}/lib/odt_templates/contract.odt") {|r| replace_field.call(r)}
        end

        odt_file = Tempfile.new('contract_odt_', "#{Rails.root}/tmp/contract")
        pdf_file = Tempfile.new('contract_pdf_', "#{Rails.root}/tmp/contract")
      
        # gem 'libreconv'
        report.generate(odt_file.path)
        Libreconv.convert(odt_file.path, pdf_file.path)

        # Respond to the request by sending the temp file
        send_file pdf_file.path, filename: "contract_#{@student.name}_#{@student.confirm[0..7]}#{@time.strftime "%Y%m%dt%H%M%S%z"}.pdf", disposition: 'attachment'
      end
    end
  end
end
