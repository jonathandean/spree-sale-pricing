class CreateSalePrices < ActiveRecord::Migration
  def change
    create_table :spree_sale_prices do |t|
      t.integer :variant_id
      t.float :value
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :enabled
      t.timestamps
    end

    # Getting active sale prices for a variant
    add_index :spree_sale_prices, [:variant_id, :start_at, :end_at, :enabled], :name => "index_active_sale_prices_for_variant"
    # Getting all active sale prices for all variants
    add_index :spree_sale_prices, [:start_at, :end_at, :enabled], :name => "index_active_sale_prices_for_all_variants"
    # Getting all sale prices for a variant
    add_index :spree_sale_prices, :variant_id, :name => "index_sale_prices_for_variant"
  end
end