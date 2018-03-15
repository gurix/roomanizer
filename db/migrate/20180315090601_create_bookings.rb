class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.references :bookable, polymorphic: true, index: true
      t.references :organisator, index: true
      t.timestamps
    end

    create_table :bookings_users, id: false do |t|
      t.belongs_to :booking, index: true
      t.belongs_to :user, index: true
    end
  end
end
