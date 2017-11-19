class Task < ApplicationRecord
  self.table_name = 'noc_tasks'

  belongs_to :occupation
  has_many :task_skills, primary_key: 'task_code'
end
