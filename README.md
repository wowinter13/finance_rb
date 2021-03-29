# finance_rb

This package is a ruby native port of the numpy-financial package with some helpful additional functions.

The functions in this package are a scalar version of their vectorised counterparts in the [numpy-financial](https://github.com/numpy/numpy-financial) library.

[![Release](https://img.shields.io/github/v/release/wowinter13/finance_rb.svg?style=flat-square)](https://github.com/wowinter13/finance_rb/releases) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![Maintainability](https://api.codeclimate.com/v1/badges/bbca82ad7815794c6718/maintainability)](https://codeclimate.com/github/wowinter13/finance_rb/maintainability)

Currently, only some functions are ported,  
which are as follows:  

| numpy-financial function     | ruby native function ported?   | info|
|:------------------------:    |:------------------:  | :------------------|
| fv                           |       |   Computes the  future value|
| ipmt                         |       |   Computes interest payment for a loan|
| pmt                          |  ✅    |   Computes the fixed periodic payment(principal + interest) made against a loan amount|
| ppmt                         |       |   Computes principal payment for a loan|
| nper                         |       |    Computes the number of periodic payments|
| pv                           |       |   Computes the present value of a payment|
| rate                         |     |    Computes the rate of interest per period|
| irr                          |    ✅    |    Computes the internal rate of return|
| npv                          |  ✅   |   Computes the net present value of a series of cash flow|
| mirr                         |    ✅    |    Computes the modified internal rate of return|

## Installation

finance_rb is available as a gem, to install it just install the gem:

    gem install finance_rb

If you're using Bundler, add the gem to Gemfile.

    gem 'finance_rb'

Run `bundle install`.

## Running tests

    bundle exec rspec spec/

## Contributing

1. Fork it ( https://github.com/wowinter13/finance_rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT License. See LICENSE for details.