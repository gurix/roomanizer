class AddCampus < ActiveRecord::Migration[5.1]
  def change
    create_table :campuses do |t|
      t.string :title, null: false
      t.belongs_to :location, index: true
      t.timestamps
    end
  end
end
