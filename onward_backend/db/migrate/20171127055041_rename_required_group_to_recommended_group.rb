class RenameRequiredGroupToRecommendedGroup < ActiveRecord::Migration[5.0]
  def change
    rename_column :univ_prereq_group, :required_group, :recommended_group
  end
end
