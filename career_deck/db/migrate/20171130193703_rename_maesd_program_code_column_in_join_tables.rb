class RenameMaesdProgramCodeColumnInJoinTables < ActiveRecord::Migration[5.1]
  def change
    rename_column :maesd_programs_ouac_university_programs, :program_code, :maesd_program_id
    rename_column :maesd_programs_occupations, :program_code, :maesd_program_id
  end
end
