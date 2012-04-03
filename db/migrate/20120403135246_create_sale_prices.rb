class CreateSalePrices < ActiveRecord::Migration
  def change
    create_table :spree_sale_prices do |t|
      t.integer :variant_id
      t.decimal :value
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :enabled
      t.timestamps
    end
  end
end