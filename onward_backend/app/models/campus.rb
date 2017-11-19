class Campus < ApplicationRecord
  self.table_name = 'campuses'
  has_one :institution, foreign_key: 'institution_code', primary_key: 'institution_code'
end
