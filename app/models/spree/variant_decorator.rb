Spree::Variant.class_eval do
  has_many :sale_prices

  # TODO also accept a class reference for calculator type instead of only a string
  def put_on_sale(value, calculator_type = "Spree::Calculator::DollarAmountSalePriceCalculator", start_at = Time.now, end_at = nil, enabled = true)
    sale_price = sale_prices.new({ value: value, start_at: start_at, end_at: end_at, enabled: enabled })
    sale_price.calculator_type = calculator_type
    sale_price.save
  end
  alias :create_sale :put_on_sale

  def sale_price
    # TODO instead of taking the first, take the lowest price
    on_sale? ? sale_prices.active.first.price : price
  end

  def on_sale?
    sale_prices.active.present?
  end

  def original_price
    self[:price]
  end

  def price
    on_sale? ? sale_price : original_price
  end
end