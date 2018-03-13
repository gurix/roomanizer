class AddWorkspace < ActiveRecord::Migration[5.1]
  def change
    create_table :workspaces do |t|
      t.string :title, null: false
      t.belongs_to :room, index: true
      t.timestamps
    end
  end
end
