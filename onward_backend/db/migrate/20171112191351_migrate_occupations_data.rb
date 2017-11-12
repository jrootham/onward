class MigrateOccupationsData < ActiveRecord::Migration[5.0]
  def up
    raw_sql = "SELECT noc_uniques.base_description_en, noc_uniques.noc_code, noc_wages.hourly_wage, noc_wages.yearly_wage FROM noc_uniques INNER JOIN noc_wages ON noc_uniques.noc_code=noc_wages.noc_code"
    nocs = ActiveRecord::Base.connection.execute(raw_sql)
    count = 0
    nocs.each do |noc|
      occupation = Occupation.new
      title = noc[0].split('->').last.strip
      occupation.job_title = title
      occupation.noc_code = noc[1]
      occupation.hourly_wage = noc[2].to_f
      occupation.salary = noc[3]
      occupation.save!
      p "Created #{occupation.job_title}"
      count += 1
    end
    p "------------- Migrated data for #{count} occupations -------------"
  end

  def down
    Occupation.destroy_all
  end
end
