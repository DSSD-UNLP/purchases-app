class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.references :user, foreign_key: true
      t.integer :product_id
      t.integer :coupon_id
      t.float :mount
    end
  end
end
