class SpecificProgram < ApplicationRecord
  self.table_name = 'noc_specific_program'

  belongs_to :occupation, foreign_key: 'noc_code', primary_key: 'noc_code'
  has_one :cip_program, foreign_key: 'cip_program_code', primary_key: 'cip_program_code'
  has_one :credential, foreign_key: 'credential_code', primary_key: 'credential_code'
end
