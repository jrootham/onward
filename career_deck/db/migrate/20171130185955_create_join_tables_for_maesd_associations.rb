class CreateJoinTablesForMaesdAssociations < ActiveRecord::Migration[5.1]
  def change
    create_table :maesd_programs_ouac_university_programs, id: false do |t|
      t.string :program_code, index: { name: 'index_maesd_ouac_programs_on_maesd_program_code' }
      t.integer :ouac_university_program_id, index: {name: 'index_maesd_ouac_programs_on_ouac_program_id'}
    end

    create_table :maesd_programs_occupations, id: false do |t|
      t.string :program_code, index: {name: 'index_maesd_programs_occupations_on_maesd_code'}
      t.integer :occupation_id, index: {name: 'index_maesd_programs_occupations_on_occupation_id'}
    end
  end
end
