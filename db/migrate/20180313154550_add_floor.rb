class AddFloor < ActiveRecord::Migration[5.1]
  def change
    create_table :floors do |t|
      t.string :title, null: false
      t.belongs_to :building, index: true
      t.timestamps
    end
  end
end
