class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true
      t.string :status, null: false
      t.string :stripe_session_id, null: false

      t.timestamps
    end
  end
end
