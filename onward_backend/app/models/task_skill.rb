class TaskSkill < ApplicationRecord
  self.table_name = 'noc_skills_tasks'
  belongs_to :task, foreign_key: 'task_code'
  belongs_to :occupation, foreign_key: 'noc_code'
  belongs_to :skill, foreign_key: [:skill_code, :level_code]
end
