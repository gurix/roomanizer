class FlagLoginFromExchange < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :from_exchange, :boolean, default: false
  end
end
