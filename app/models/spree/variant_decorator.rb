Spree::Variant.class_eval do

  # TODO also accept a class reference for calculator type instead of only a string
  def put_on_sale(value, calculator_type = "Spree::Calculator::DollarAmountSalePriceCalculator", all_currencies = true, start_at = Time.now, end_at = nil, enabled = true)
    if all_currencies && prices.present?
      prices.each do { |p| p.put_on_sale value, calculator_type, start_at, end_at, enabled }
    else
      default_price.put_on_sale value, calculator_type, start_at, end_at, enabled
    end
  end
  alias :create_sale :put_on_sale

  # TODO make update_sale method

  def active_sale_in(currency)
    price_in(currency).active_sale
  end
  alias :current_sale :active_sale_in

  def next_active_sale_in(currency)
    price_in(currency).next_active_sale
  end
  alias :next_current_sale :next_active_sale_in

  def sale_price_in(currency)
    price_in(currency).sale_price
  end

  def on_sale_in?(currency)
    price_in(currency).on_sale?
  end

  def original_price_in(currency)
    price_in(currency).original_price
  end

  def enable_sale(all_currencies = true)
    if all_currencies && prices.present?
      prices.each do { |p| p.enable_sale }
    else
      default_price.enable_sale  
    end
  end

  def disable_sale(all_currencies = true)
    if all_currencies && prices.present?
      prices.each do { |p| p.disable_sale }
    else
      default_price.disable_sale  
    end
  end

  def start_sale(end_time = nil, all_currencies = true)
    if all_currencies && prices.present?
      prices.each do { |p| p.start_sale end_time }
    else
      default_price.start_at end_time
    end
  end

  def stop_sale(all_currencies=true)
    if all_currencies && prices.present?
      prices.each do { |p| p.stop_sale }
    else
      default_price.stop_sale  
    end
  end
end