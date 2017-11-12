class Skill < ApplicationRecord
  self.table_name = 'noc_skills_levels'
  self.primary_keys = :skill_code, :level_code

  belongs_to :occupation
  has_many :task_skills, foreign_key: [:skill_code, :level_code]
end
