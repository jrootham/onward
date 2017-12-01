class MigrateRiskAutomationData < ActiveRecord::Migration[5.1]
  def change
    Occupation.all.each do |occ|
      occ.update_attributes(risk_of_automation: occ.automation_risk_percentage)
    end
  end
end
