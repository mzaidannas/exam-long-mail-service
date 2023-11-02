class CreateBooking < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :train, null: false, foreign_key: true, index: false
      t.references :user, null: false, foreign_key: true
      t.string :line, limit: 1, null: false
      t.datetime :end_time, null: false, default: -> { "CURRENT_TIMESTAMP + INTERVAL '3 HOURS'" }
      t.timestamps
    end

    add_index :bookings, :train_id, unique: true
    add_index :bookings, :end_time, using: :brin
    add_index :bookings, :line, using: :hash
  end
end
