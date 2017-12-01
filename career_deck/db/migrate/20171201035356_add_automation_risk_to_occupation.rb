class AddAutomationRiskToOccupation < ActiveRecord::Migration[5.1]
  def change
    add_column :occupations, :risk_of_automation, :float
  end
end
