module Spree
  class SalePrice < ActiveRecord::Base
    # TODO validations
    belongs_to :variant, :class_name => "Spree::Variant"
    has_one :calculator, :class_name => "Spree::Calculator", :as => :calculable, :dependent => :destroy
    accepts_nested_attributes_for :calculator
    validates :calculator, :presence => true

    scope :active, lambda {
      where("enabled = true AND (start_at <= ? OR start_at IS NULL) AND (end_at >= ? OR end_at IS NULL)", Time.now, Time.now)
    }

    # TODO make this work or remove it
    def self.calculators
      Rails.application.config.spree.calculators.send(self.to_s.tableize.gsub('/', '_').sub('spree_', ''))
    end

    def calculator_type
      calculator.class.to_s if calculator
    end

    def calculator_type=(calculator_type)
      clazz = calculator_type.constantize if calculator_type
      self.calculator = clazz.new if clazz and not self.calculator.is_a? clazz
    end

    def price
      calculator.compute self
    end
  end
end
