class OptimisticLocksForRoomManagment < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :lock_version, :integer, default: 0
    add_column :campuses, :lock_version, :integer, default: 0
    add_column :buildings, :lock_version, :integer, default: 0
    add_column :floors, :lock_version, :integer, default: 0
    add_column :rooms, :lock_version, :integer, default: 0
    add_column :workspaces, :lock_version, :integer, default: 0
  end
end
