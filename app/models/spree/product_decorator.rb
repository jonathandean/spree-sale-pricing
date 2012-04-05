Spree::Product.class_eval do

  # Essentially all read values here are delegated to reading the value on the Master variant
  # All write values will write to all variants (including the Master) unless that method's all_variants parameter is set to false, in which case it will only write to the Master variant

  # TODO Should the all_variants flag be on option you set on creating the sale and then it always behaves as such? Seems unsafe to pass this flag one way during create and use a different value for it later (they can actively bypass by accessing each variant directly and changing the values)

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

  def active_sale
    master.active_sale
  end
  alias :current_sale :active_sale

  def next_active_sale
    master.next_active_sale
  end
  alias :next_current_sale :next_active_sale

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

  def enable_sale(all_variants = true)
    if all_variants && variants.present?
      variants.each do |v|
        v.enable_sale
      end
    end
    master.enable_sale
  end

  def disable_sale(all_variants = true)
    if all_variants && variants.present?
      variants.each do |v|
        v.disable_sale
      end
    end
    master.disable_sale
  end

  def start_sale(end_time = nil, all_variants = true)
    if all_variants && variants.present?
      variants.each do |v|
        v.start_sale(end_time)
      end
    end
    master.start_sale(end_time)
  end

  def stop_sale(all_variants = true)
    if all_variants && variants.present?
      variants.each do |v|
        v.stop_sale
      end
    end
    master.stop_sale
  end
end