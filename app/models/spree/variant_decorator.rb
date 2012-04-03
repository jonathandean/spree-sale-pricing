Spree::Variant.class_eval do
  has_many :sale_prices

  def put_on_sale(value, start_at = Time.now, end_at = nil, enabled = true)
    sale_prices.create({ value: value, start_at: start_at, end_at: end_at, enabled: enabled })
  end
  alias :create_sale :put_on_sale

  def sale_price
    # TODO instead of taking the first, take the lowest price
    on_sale? ? sale_prices.active.first.price : price
  end

  def on_sale?
    sale_prices.active.present?
  end
end