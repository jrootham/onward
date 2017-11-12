class CreateOccupations < ActiveRecord::Migration[5.0]
  def change
    create_table :occupations do |t|
      t.string :job_title
      t.string :noc_code
      t.integer :salary
      t.float :hourly_wage

      t.timestamps
    end
  end
end
