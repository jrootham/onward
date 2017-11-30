class BuildMaesdAssociationTables < ActiveRecord::Migration[5.1]
  def up
    OuacUniversityProgram.all.each do |ouac_program|
      maesd_associations = ouac_program.maesd_programs
      maesd_associations.each do |maesd|
        execute "INSERT INTO maesd_programs_ouac_university_programs (program_code, ouac_university_program_id) VALUES ('#{maesd.program_code}', #{ouac_program.id});"
      end
    end

    Occupation.all.each do |occupation|
      maesd_codes = occupation.maesd_codes
      maesd_assocations = MaesdProgram.find(maesd_codes)
      maesd_assocations.each do |maesd|
        execute "INSERT INTO maesd_programs_occupations (program_code, occupation_id) VALUES ('#{maesd.program_code}', #{occupation.id});"
      end
    end
  end

  def down
    execute 'DELETE FROM maesd_programs_ouac_university_programs;'
    execute 'DELETE FROM maesd_programs_occupations;'
  end
end
