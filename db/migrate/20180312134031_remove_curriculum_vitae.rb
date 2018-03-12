class RemoveCurriculumVitae < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :curriculum_vitae
  end
end
