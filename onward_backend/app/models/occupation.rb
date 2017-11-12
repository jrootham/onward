class Occupation < ApplicationRecord
  has_many :tasks, through: :task_skills
  has_many :task_skills, primary_key: 'noc_code', foreign_key: 'noc_code'
  has_many :skills, through: :task_skills

end
