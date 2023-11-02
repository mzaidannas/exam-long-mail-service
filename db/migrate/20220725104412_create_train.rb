class CreateTrain < ActiveRecord::Migration[7.0]
  def change
    create_enum :train_statuses, %w[waiting booked reached withdrawn]
    create_table :trains do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :name, limit: 255, null: false
      t.integer :cost, null: false
      t.float :weight, null: false
      t.float :volume, null: false
      t.string :lines, limit: 1, array: true, default: [], null: false
      t.enum :status, enum_type: "train_statuses", default: "waiting", null: false
      t.timestamps
    end

    add_index :trains, :lines, using: :gin
    add_index :trains, :status, using: :hash
  end
end
