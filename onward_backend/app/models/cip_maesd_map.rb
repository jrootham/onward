class CipMaesdMap < ApplicationRecord
  self.table_name = 'program_cip_map'
  self.primary_key = :program_code

  has_one :maesd_program, foreign_key: 'program_code', primary_key: 'program_code'
end
