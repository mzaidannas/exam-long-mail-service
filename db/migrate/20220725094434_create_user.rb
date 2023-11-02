class CreateUser < ActiveRecord::Migration[7.0]
  def change
    create_enum :roles, %w[operator postmaster owner]
    create_table :users do |t|
      t.string :name, limit: 100, null: false
      t.string :email, limit: 256, null: false
      t.enum :role, enum_type: 'roles', default: 'owner', null: false
      t.timestamps
    end
  end
end
