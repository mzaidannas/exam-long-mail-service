class CreateParcel < ActiveRecord::Migration[7.0]
  def change
    create_enum :shipping_statuses, %w[pending picked delivered retrieved]
    create_table :parcels do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :train, null: true, index: true
      t.integer :cost
      t.float :weight, null: false
      t.float :volume, null: false
      t.enum :status, enum_type: "shipping_statuses", default: "pending", null: false
      t.timestamps
    end
    add_index :parcels, :status, using: :hash
  end
end
