class Occupation < ApplicationRecord
  # base description and job title from noc_uniques

  has_many :task_skills, primary_key: 'noc_code', foreign_key: 'noc_code'
  has_many :tasks, through: :task_skills
  has_many :skills, through: :task_skills
  has_many :specific_programs, foreign_key: 'noc_code', primary_key: 'noc_code'

  def automation_risk_percentage
    risk = AutomationRisk.find_by(noc_code: noc_code)
    return nil unless risk

    risk.to_f * 100
  end
end
