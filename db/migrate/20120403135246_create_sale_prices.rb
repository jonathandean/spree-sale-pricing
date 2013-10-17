class CreateSalePrices < ActiveRecord::Migration
  def change
    create_table :spree_sale_prices do |t|
      t.integer :price_id
      t.float :value
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :enabled
      t.timestamps
    end

    # Getting active sale prices for a price
    add_index :spree_sale_prices, [:price_id, :start_at, :end_at, :enabled], :name => "index_active_sale_prices_for_price"
    # Getting all active sale prices for all prices
    add_index :spree_sale_prices, [:start_at, :end_at, :enabled], :name => "index_active_sale_prices_for_all_variants"
    # Getting all sale prices for a price
    add_index :spree_sale_prices, :price_id, :name => "index_sale_prices_for_price"
  end
end