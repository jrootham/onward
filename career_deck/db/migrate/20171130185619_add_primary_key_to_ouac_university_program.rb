class AddPrimaryKeyToOuacUniversityProgram < ActiveRecord::Migration[5.1]
  def up
    execute 'ALTER TABLE univ_prereq_group DROP FOREIGN KEY univ_prereq_group_ibfk_1;'
    execute 'ALTER TABLE university_programs_ouac_code ADD UNIQUE (ouac_univ_code, ouac_program_code, program_type, specialization);'
    execute 'ALTER TABLE university_programs_ouac_code DROP PRIMARY KEY;'
    execute 'ALTER TABLE university_programs_ouac_code ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
