module Spree
  class Calculator::DollarAmountSalePriceCalculator < Spree::Calculator
    # TODO validate that the sale price is less than the original price
    def self.description
      "Calculates the sale price for a Variant by returning the provided fixed sale price"
    end

    def compute(sale_price)
      sale_price.value
    end
  end
end