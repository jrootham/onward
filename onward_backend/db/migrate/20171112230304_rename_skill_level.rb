class RenameSkillLevel < ActiveRecord::Migration[5.0]
  def change
    rename_column :noc_skills_tasks, :skill_level, :level_code
  end
end
