Spree::Variant.class_eval do

  # TODO also accept a class reference for calculator type instead of only a string
  def put_on_sale(value, calculator_type = "Spree::Calculator::DollarAmountSalePriceCalculator", all_currencies = true, start_at = Time.now, end_at = nil, enabled = true)
    run_on_prices(all_currencies) { |p| p.put_on_sale value, calculator_type, start_at, end_at, enabled }
  end
  alias :create_sale :put_on_sale

  # TODO make update_sale method

  def active_sale_in(currency)
    price_in(currency).active_sale
  end
  alias :current_sale_in :active_sale_in

  def next_active_sale_in(currency)
    price_in(currency).next_active_sale
  end
  alias :next_current_sale_in :next_active_sale_in

  def sale_price_in(currency)
    Spree::Price.new variant_id: self.id, currency: currency, amount: price_in(currency).sale_price
  end
  
  def discount_percent_in(currency)
    price_in(currency).discount_percent
  end
  
  def on_sale_in?(currency)
    price_in(currency).on_sale?
  end

  def original_price_in(currency)
    Spree::Price.new variant_id: self.id, currency: currency, amount: price_in(currency).original_price
  end

  def enable_sale(all_currencies = true)
    run_on_prices(all_currencies) { |p| p.enable_sale }
  end

  def disable_sale(all_currencies = true)
    run_on_prices(all_currencies) { |p| p.disable_sale }
  end

  def start_sale(end_time = nil, all_currencies = true)
    run_on_prices(all_currencies) { |p| p.start_sale end_time }
  end

  def stop_sale(all_currencies=true)
    run_on_prices(all_currencies) { |p| p.stop_sale }
  end
  
  private
   
  def run_on_prices(all_currencies, &block)
    if all_currencies && prices.present?
      prices.each { |p| block.call p }
    else
      block.call default_price  
    end
  end
end