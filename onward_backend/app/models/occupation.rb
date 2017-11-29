class Occupation < ApplicationRecord
  # base description and job title from noc_uniques

  has_many :task_skills, primary_key: 'noc_code', foreign_key: 'noc_code'
  has_many :tasks, through: :task_skills
  has_many :skills, through: :task_skills
  has_many :specific_programs, foreign_key: 'noc_code', primary_key: 'noc_code'

  has_and_belongs_to_many :maesd_programs

  def automation_risk_percentage
    risk = AutomationRisk.find_by(noc_code: noc_code)
    return nil unless risk

    risk.to_f * 100
  end

  def illustrative_job_titles
    JobTitle.where(noc_code: noc_code).pluck(:description_en)
  end

  def maesd_codes
    cip_program_codes = SpecificProgram.where(noc_code: noc_code).pluck(:cip_program_code)
    cip_top_codes = CipProgram.where(cip_program_code: cip_program_codes).pluck(:cip_top_code)
    CipMaesdMap.where(cip_top_code: cip_top_codes).pluck(:program_code).uniq
  end
end