class CreatePackages < ActiveRecord::Migration[7.1]
  def change
    create_table :packages do |t|
      t.string :name, null: false
      t.integer :price_cents, null: false

      t.timestamps
    end

    add_index :packages, :name, unique: true
  end
end
