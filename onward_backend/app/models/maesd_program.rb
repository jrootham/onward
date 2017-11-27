class MaesdProgram < ApplicationRecord
  self.table_name = 'univ_programs_maesd'

  belongs_to :ouac_maesd_map
  belongs_to :cip_maesd_map
end
