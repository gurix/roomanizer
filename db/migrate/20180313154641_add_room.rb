class AddRoom < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :title, null: false
      t.belongs_to :floor, index: true
      t.timestamps
    end
  end
end
