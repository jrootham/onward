class Occupation < ApplicationRecord
  has_many :task_skills, primary_key: 'noc_code', foreign_key: 'noc_code'
  has_many :tasks, through: :task_skills
  has_many :skills, through: :task_skills
  has_one :credential, through: :specific_programs
  has_one :specific_program

  def automation_risk_percentage
    risk = AutomationRisk.find_by(noc_code: noc_code)
    return nil unless risk

    risk.to_f * 100
  end
end
