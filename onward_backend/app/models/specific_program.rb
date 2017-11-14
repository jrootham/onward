class SpecificProgram < ApplicationRecord
  belongs_to :occupation, foreign_key: 'noc_code'
  has_one :credential
end
