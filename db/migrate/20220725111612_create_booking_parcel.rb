class CreateBookingParcel < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_parcels do |t|
      t.references :booking, null: false, foreign_key: true, index: true
      t.references :parcel, null: false, foreign_key: true, index: true
    end
    add_index :booking_parcels, [:booking_id, :parcel_id], unique: true
  end
end
