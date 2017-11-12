class AddUniquePrimaryKeyToSkillsLevels < ActiveRecord::Migration[5.0]
  def change
    add_column :noc_skills_levels, :skill_level_code, :string
  end
end
