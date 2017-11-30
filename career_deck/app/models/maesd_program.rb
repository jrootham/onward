class MaesdProgram < ApplicationRecord
  self.table_name = 'univ_programs_maesd'

  belongs_to :ouac_maesd_map
  belongs_to :cip_maesd_map

  has_and_belongs_to_many :ouac_university_programs, join_table: :maesd_programs_ouac_university_programs, primary_key: 'program_code'
  has_and_belongs_to_many :occupations, join_table: :maesd_programs_occupations, primary_key: 'program_code'
end
