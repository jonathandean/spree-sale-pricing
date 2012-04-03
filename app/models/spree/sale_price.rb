module Spree
  class SalePrice < ActiveRecord::Base
    # TODO validations
    # TODO use a calculator to allow different types of sales (%off, set dollar amount, etc.)

    scope :active, lambda{
      where("enabled = true AND (start_at <= ? OR start_at IS NULL) AND (end_at >= ? OR end_at IS NULL)", Time.now, Time.now)
    }

    def price
      value
    end
  end
end
