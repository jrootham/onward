class MigratePostSecondaryProgramData < ActiveRecord::Migration[5.0]
  def up
    OuacUniversityProgram.all.map do |program|
      program.update_attributes(program_title: get_program_title(program),
                                university: get_university_name(program))
    end
  end

  def down
    OuacUniversityProgram.all.map do |program|
      program.update_attributes(program_title: nil, university: nil)
    end
  end

  def get_program_title(program)
    OuacProgram.find(program.ouac_program_code).description_en
  end

  def get_university_name(program)
    OuacUniversity.find(program.ouac_univ_code).ouac_univ_description_en
  end
end
