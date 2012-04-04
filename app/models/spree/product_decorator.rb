Spree::Product.class_eval do

  # TODO also accept a class reference for calculator type instead of only a string
  def put_on_sale(value, calculator_type = "Spree::Calculator::DollarAmountSalePriceCalculator", all_variants = true, start_at = Time.now, end_at = nil, enabled = true)
    if all_variants && variants.present?
      variants.each do |v|
        v.put_on_sale(value, calculator_type, start_at, end_at, enabled)
      end
    end
    master.put_on_sale(value, calculator_type, start_at, end_at, enabled)
  end
  alias :create_sale :put_on_sale

  def sale_price
    master.sale_price
  end

  def on_sale?
    master.on_sale?
  end

  def original_price
    master.original_price
  end

  def price
    master.price
  end
end