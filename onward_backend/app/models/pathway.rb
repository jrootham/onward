class Pathway
  attr_accessor :result

  PERMITTED_QUERY_PARAMS = %w(hs_courses current_level cip_codes noc_codes)

  LEVELS = [
    {
      name: 'grade_9',
      options_next_level: 'next_year_courses',
      options_previous_level: nil
    },
    {
      name: 'grade_10',
      options_next_level: 'next_year_courses',
      options_previous_level: 'previous_year_courses'
    },
    {
      name: 'grade_11',
      options_next_level: 'next_year_courses',
      options_previous_level: 'previous_year_courses'
    },
    {
      name: 'grade_12',
      options_next_level: 'post_secondary_programs',
      options_previous_level: 'previous_year_courses'
    },
    {
      name: 'post_secondary',
      options_next_level: 'occupation_options',
      options_previous_level: 'program_prerequisites'
    },
    {
      name: 'occupation',
      options_next_level: nil,
      options_previous_level: 'post_secondary_requirements'
    }
  ]

  def initialize(query_params)
    @query_params = query_params.with_indifferent_access
    @result = Hash[LEVELS.map{ |level| [level[:name], []] }].with_indifferent_access

    populate_high_school_courses(@query_params[:hs_courses])
    populate_post_secondary_programs(@query_params[:cip_codes])
    populate_occupations(@query_params[:noc_codes])

    # limit_pathway(LEVELS.last)
    generate_pathway(level_from_name(@query_params[:current_level]))
  end

  def level_from_name(level_name)
    LEVELS.find { |level| level[:name] == level_name } || LEVELS[0]
  end

  def populate_high_school_courses(hs_course_codes)
    courses = HighSchoolCourse.includes(:course_prerequisite, :course_grade).find(hs_course_codes)
    p "COURSES => #{courses}"

    courses.each do |course|
      hash_key = "grade_#{course.grade}"
      @result[hash_key].push course
    end
  end

  def populate_occupations(noc_codes)
    occupations = Occupation.where(noc_code: noc_codes).to_a
    @result[:occupation] = occupations
  end

  def populate_post_secondary_programs(cip_codes)
    programs = SpecificProgram.where(cip_program_code: cip_codes)
    @result[:post_secondary] = programs
  end

  def generate_pathway(current_level)
    return @result unless current_level

    method_name = current_level[:options_next_level]

    return @result unless method_name

    send(method_name, current_level)

    generate_pathway(next_level(current_level))

  rescue NoMethodError => e
    puts "------------------------------"
    puts e
    return @result
    puts "------------------------------"

  rescue TypeError
    binding.pry
  end

  def limit_pathway(current_level)
    return @result unless current_level

    method_name = current_level[:options_previous_level]

    return @result unless method_name

    pl = prev_level(current_level)

    send(method_name, current_level, pl)

    limit_pathway(pl)

  rescue NoMethodError => e
    puts "------------------------------"
    puts e
    return @result
    puts "------------------------------"
  end

  def previous_year_courses(current_level)
    current_courses = @result[current_level[:name]]
    previous_level = prev_level(current_level)

    @result[previous_level[:name]] = @result[previous_level[:name]].tap do |courses|
      courses << current_courses.map { |course| course.prereq }
      courses.flatten!
    end
  end

  def next_year_courses(current_level)
    current_courses = @result[current_level[:name]]
    nx_level = next_level(current_level)

    @result[nx_level[:name]] = @result[nx_level[:name]].tap do |courses|
      current_courses.map { |course| courses << course.prereq_for }
      courses.flatten!
    end
  end

  def post_secondary_requirements(_)
    programs = @result[:occupation].map do |occupation|
      occupation.specific_programs
    end

    @result[:post_secondary] = @result[:post_secondary].tap do |ps|
      ps << programs
      ps.flatten!
    end
  end

  def program_prerequisites(_)
    # TODO
  end

  def post_secondary_programs(_)
    # TODO
  end

  def occupation_options(_)
    specific_programs = @result[:post_secondary]
    @result[:occupation] = @result[:occupation].tap do |occ|
      occ << specific_programs.map { |sp| sp.occupation }
      occ.flatten!
    end
  end

  private

  def next_level(current_level)
    current_level_index = LEVELS.index(current_level)

    return if current_level_index === LEVELS.length - 1

    LEVELS[LEVELS.index(current_level) + 1]
  end

  def prev_level(current_level)
    current_level_index = LEVELS.index(current_level)

    return if current_level_index === 0

    LEVELS[current_level_index - 1]
  end
end
