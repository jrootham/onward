class BuildMaesdAssociationTables < ActiveRecord::Migration[5.1]
  def up
    OuacUniversityProgram.all.each do |ouac_program|
      maesd_codes = ouac_program.maesd_codes
      maesd_codes.each do |maesd_code|
        execute "INSERT INTO maesd_programs_ouac_university_programs (maesd_program_id, ouac_university_program_id) VALUES ('#{maesd_code}', #{ouac_program.id});"
      end
    end

    Occupation.all.each do |occupation|
      maesd_codes = occupation.maesd_codes
      maesd_codes.each do |maesd_code|
        execute "INSERT INTO maesd_programs_occupations (maesd_program_id, occupation_id) VALUES ('#{maesd_code}', #{occupation.id});"
      end
    end
  end

  def down
    execute 'DELETE FROM maesd_programs_ouac_university_programs;'
    execute 'DELETE FROM maesd_programs_occupations;'
  end
end
