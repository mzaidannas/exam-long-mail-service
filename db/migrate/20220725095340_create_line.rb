class CreateLine < ActiveRecord::Migration[7.0]
  def change
    create_table :lines do |t|
      t.string :name, limit: 1, null: false
      t.boolean :booked, default: false, null: false
    end
    add_index :lines, :name, using: :hash
    add_index :lines, :booked
  end
end
