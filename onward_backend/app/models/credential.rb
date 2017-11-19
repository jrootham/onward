class Credential < ApplicationRecord
  belongs_to :specific_program, foreign_key: 'credential_code'
end
