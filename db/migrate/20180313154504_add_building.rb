class AddBuilding < ActiveRecord::Migration[5.1]
  def change
    create_table :buildings do |t|
      t.string :title, null: false
      t.string :address, null: false
      t.belongs_to :campus, index: true
      t.timestamps
    end
  end
end
