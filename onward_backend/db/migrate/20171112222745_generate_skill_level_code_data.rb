class GenerateSkillLevelCodeData < ActiveRecord::Migration[5.0]
  def up
    Skill.all.map do |skill|
      skill.update(skill_level_code: "#{skill.skill_code}#{skill.level_code}")
      skill.save!
    end
  end

  def down
    Skill.all.map do |skill|
      skill.update(skill_level_code: nil)
      skill.save
    end
  end
end
