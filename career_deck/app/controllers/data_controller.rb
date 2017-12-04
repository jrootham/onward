class DataController < ActionController::API
  def maesd_programs
    render json: MaesdProgram.all.to_a
  end

  def high_school_programs
    render json: { error: 'Must provide current level to retrieve high school courses' } unless data_params[:grade].present?

    courses_by_grade = HighSchoolCourse.joins(:course_grade).where('hs_course_grade_link.grade = ?', data_params[:grade])
    course_selection = sort_by_priority_subjects(courses_by_grade)

    render json: course_selection
  end

  def data_params
    params.permit(:grade)
  end

  def sort_by_priority_subjects(courses)
    final_order = []
    HighSchoolCourse::PRIORITY_SUBJECTS.each do |initial|
      priority_courses = courses.select { |course| course.course_code.start_with?(initial) }
      courses = courses - priority_courses
      final_order << priority_courses
    end

    final_order << courses
    final_order.flatten
  end
end