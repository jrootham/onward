require 'rails_helper'

RSpec.describe Pathway, type: :model do

  describe '#initialize' do
    it 'should generate a results hash with course options for each year of high school', focus: true do
      hs_course_codes = ['ENG1P', 'GLE1O', 'MFM1P']
      level = 'grade_9'
      pathway = Pathway.new(hs_course_codes: hs_course_codes, current_level: level)
      puts pathway.result
    end
  end
end
