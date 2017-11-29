class AddColumnsToOuacUniversityProgram < ActiveRecord::Migration[5.0]
  def change
    add_column :university_programs_ouac_code, :program_title, :string
    add_column :university_programs_ouac_code, :program_code, :string
    add_column :university_programs_ouac_code, :university, :string
  end
end
