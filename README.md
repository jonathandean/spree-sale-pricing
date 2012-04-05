Spree Sale Pricing
==================

A Spree Commerce extension (Rails Engine) that lets you set sale prices on products, either by a fixed sale price or a
percentage off of the original price. Sale prices have a start date, end date and enabled flag to allow you to schedule
sales, have a historical record of sale prices and put sales on hold.

Requirements
------------

This Gem has only been tested with Spree 1.0.0 and Ruby 1.9.3. It might work with other version of Spree but I'm not
sure. It should work with Ruby 1.9.2 but I haven't verified. It does not support Ruby versions earlier than 1.9 for sure.
If you test against other version of Spree or Ruby I'd love to hear about the results :)

Installing
----------

In your Gemfile add the following for the latest released version:

    gem 'spree_sale_pricing'

_OR_ to work from master:

    gem 'spree_sale_pricing', :git => 'git://github.com/jonathandean/spree-sale-pricing.git'

Install the Gem:

    bundle install

Copy the migrations in your app:

    bundle exec rake railties:install:migrations

Run database migrations in your app:

    bundle exec rake db:migrate

Usage
-----

At the moment there is only a Ruby interface because I haven't had time to make an admin interface yet. I hope to be able
to get to that soon.

Simple example assuming you have a product in your database with the price of $20 and you want to put it on sale
immediately for $10:

    product = Spree::Product.first

    puts product.price.to_f              # => 20.0
    puts product.on_sale?                # => false

    product.put_on_sale 10

    puts product.price.to_f              # => 10.0
    puts product.original_price.to_f     # => 20.0
    puts product.on_sale?                # => true

By default it uses the supplied Spree::Calculator::DollarAmountSalePriceCalculator which essentially just returns the
value you give it as the sale price.

You can also give a certain percentage off by specifying that you want to use Spree::Calculator::PercentOffSalePriceCalculator.
Note that the percentage is given as a float between 0 and 1, not the integer amount from 0 to 100.

    product.put_on_sale 0.2, "Spree::Calculator::PercentOffSalePriceCalculator"
    puts product.price.to_f              # => 16.0

This extension gives you all of the below methods on both your Products and Variants. If accessed on the Product when reading values,
it will return values from your Master variant. If accessed on the Product when writing values, it will by default update
all variants including the master variants. If you change the all_variants parameter to false, it will only then write to
the master variant and leave the other variants untouched.

**price**                                             Returns the sale price if currently on sale, the original price if not

**sale_price**                                        Returns the sale price if currently on sale, nil if not

**original_price**                                    Always returns the original price

**on_sale?**                                          Return a boolean indication if it is currently on sale (enabled is set to true and we are currently within the active date range)

**put\_on\_sale(value[, ...])**                       Put this item on sale (see below sections for options and more information)

**create_sale**                                       Alias of ```put_on_sale```

**active_sale**                                       Returns the currently active sale (Spree::SalePrice object) that price and sale_price will use. If there is more than one potentially active sale, the one with the latest created_at timestamp is used. See the section on "Multiple active sales" for the reasoning behind that.

**current_sale**                                      Alias of ```active_sale```

**next_active_sale**                                  Currently returns the latest created Spree::SalePrice object (active or not.) The name is kind of misleading so it should probably be changed. We may also want to make this only return the latest created inactive sale, since that's kind of the original intention of it to be used inside of ```enable_sale``` and ```start_sale```. Needs more thought.

**next_current_sale**                                 Alias of ```next_active_sale```

**enable_sale(all_variants = true)**                  Enable the sale returned by ```next_active_sale``` by setting that Spree::SalePrice object's enabled flag to true. Does not change the start and end dates so it does not necessary mean that the sale will then become active. Therefore, you can enable a sale in this manner and still have it not take effect on the site. (Use ```start_sale``` for that) _Note:_ The all_variants flag is only available on Spree::Product (not on Spree::Variant)

**disable_sale(all_variants = true)**                 Disable the sale returned by ```active_sale``` by setting that Spree::SalePrice object's enabled flag to false. This always makes the sale inactive, regardless of the date range. _Note:_ The all_variants flag is only available on Spree::Product (not on Spree::Variant)

**start_sale(end_time = nil, all_variants = true)**   Start the sale returned by ```next_active_sale``` (and make it active) by setting that Spree::SalePrice object's enabled flag to true and ensuring that the current time is in between the start and end dates. _Note:_ The all_variants flag is only available on Spree::Product (not on Spree::Variant)

**stop_sale(all_variants = true)**                    Stop the sale returned by ```active_sale``` by setting that Spree::SalePrice object's enabled flag to false and the end date to the current time. _Note:_ The all_variants flag is only available on Spree::Product (not on Spree::Variant)

Since you have these methods available to both your products and variants, it is possible to put the product and all
variants on sale or just particular variants. See the explanation of put\_on\_sale below for more information.


Options for put\_on\_sale (create_sale)
---------------------------------------

    put_on_sale(value, calculator_type = "Spree::Calculator::DollarAmountSalePriceCalculator", all_variants = true, start_at = Time.now, end_at = nil, enabled = true)

**value**           (_float_)

This is either the sale price that you want to sell the product for (if using the default DollarAmountSalePriceCalculator)
or the float representation of the percentage off of the original price (between 0 and 1)

**calculator_type** (_string_)    - Default: **"Spree::Calculator::DollarAmountSalePriceCalculator"**

Specify which calculator to use for determining the sale price. The default calculator will take the value as is and use it
as the sale price. You can also pass in another calculator value to determine the sale price differently, such as the
provided "Spree::Calculator::PercentOffSalePriceCalculator", which will take a given percentage off of the original
price.

**all_variants**    (_boolean_)   - Default: **true**

_Only for Spree::Product_. By default it set all of variants (including the master variant) for the product on sale. If you change this value to false
it will only put the master variant on sale. Only change this if you know the implications.

**start_at**        (_DateTime or nil_)  - Default: **Time.now**

Specify the date and time that the sale takes effect. By default it uses the current time. It can also be nil but it's not
recommended because for future reporting reasons you will probably want to know exactly when the sale started.

**end_at**          (_DateTime or nil_)  - Default: **nil**

Specify the end date of the sale or nil to keep the sale running indefinitely. For future reporting reasons it's recommended
to set this at the time you decide to deactivate the sale rather than just setting enabled to false.

**enabled**         (_boolean_)   - Default: **true**

Disable this sale temporarily by setting this to false (overrides the start_at and end_at range). It's not recommended to
use this to stop the sale when you decide to end it because it could impact future reporting needs. It's mainly intended
to keep the sale disabled while you are still working on it and it isn't quite ready, or if you need to disable temporarily
for some reason in the middle of a sale.

Multiple active sales
---------------------

Technically you can have more than one active sale at a time. However, because Spree is going to use product.price or
variant.price throughout (with no additional parameters or means to identify a particular sale), we have to consistently
work with a single sale price so that the customer is always charged the same price as they see on the site. What we do then
is always take the last created sale price. We do this so that if you want to temporarily make a new sale to override a
currently running one, you just add a new active sale. Then when that new sale ends, the old sale will be in effect again
(provided it's still active, of course.) So you can add more than one active sale but only one will actually be used at
a given time.

Testing
-------

Tests are in progress, so there aren't any yet. I know, TDD, blah blah blah.

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test app
    $ bundle exec rspec spec

Copyright (c) 2012 Jonathan Dean, released under the New BSD License
