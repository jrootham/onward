class Institution < ApplicationRecord
  has_many :campuses, class_name: 'Campus', foreign_key: 'institution_code'
end
