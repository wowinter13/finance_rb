# finance_rb

This package is a ruby native port of the numpy-financial package with some helpful additional functions.

The functions in this package are a scalar version of their vectorised counterparts in the [numpy-financial](https://github.com/numpy/numpy-financial) library.

![tests](https://github.com/wowinter13/finance_rb/actions/workflows/tests.yml/badge.svg) [![Release](https://img.shields.io/github/v/release/wowinter13/finance_rb.svg?style=flat-square)](https://github.com/wowinter13/finance_rb/releases) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![Maintainability](https://api.codeclimate.com/v1/badges/bbca82ad7815794c6718/maintainability)](https://codeclimate.com/github/wowinter13/finance_rb/maintainability)

Currently, only some functions are ported,  
which are as follows:  

| numpy-financial function     | ruby native function ported?   | info|
|:------------------------:    |:------------------:  | :------------------|
| fv                           |   ✅    |   Computes the  future value|
| ipmt                         |   ✅   |   Computes interest payment for a loan|
| pmt                          |  ✅    |   Computes the fixed periodic payment(principal + interest) made against a loan amount|
| ppmt                         |   ✅   |   Computes principal payment for a loan|
| nper                         |    ✅   |    Computes the number of periodic payments|
| pv                           |    ✅  |   Computes the present value of a payment|
| rate                         |   ✅ |    Computes the rate of interest per period|
| irr                          |    ✅    |    Computes the internal rate of return|
| npv                          |  ✅   |   Computes the net present value of a series of cash flow|
| mirr                         |    ✅    |    Computes the modified internal rate of return|


**Things to be done:**

1. Xirr
2. More specs for edge cases
3. Fee, currency protection and other cool stuff for advanced usage
4. Better errors
5. A detailed documentation for all methods

## Documentation

Detailed documentation is available at [rubydoc](https://rubydoc.info/gems/finance_rb).

### Basic usage

There is no need to create a loan class to calculate some basic functions, such as `npv`, `irr`, or `mirr`. Simply call a needed method with required arguments using calculations class.

1. **IRR** (Internal Rate of Return)

    ```ruby
    Finance::Calculations.irr([-4000,1200,1410,1875,1050])
    => 0.14299344106053188
    ```

2. **MIRR** (Modified Internal Rate of Return)

    ```ruby
    Finance::Calculations.mirr([100, 200, -50, 300, -200], 0.05, 0.06)
    => 0.3428233878421769
    ```

3. **NPV** (Net Present Value)

    ```ruby
    Finance::Calculations.net_present_value(0.1, [-100, 6, 6, 6])
    => -85.07888805409468
    ```

### Advanced Usage

Create a loan instance, and pass available parameters for nominal annual rate, duration (in months), and amount of loan.

```ruby

loan = Finance::Loan.new(nominal_rate: 0.1, duration: 12, amount: 1000)
loan.pmt # => -87.9158872300099
```

Available methods: `pmt`, `ipmt`, `ppmt`, `nper`, `pv`, `fv`, `rate`.

## Installation

finance_rb is available as a gem, to install it just install the gem:

    gem install finance_rb

If you're using Bundler, add the gem to Gemfile.

    gem 'finance_rb'

Run `bundle install`.

## Running tests

    bundle exec rspec spec/
    
## Available Functions

** Simple financial functions **
- fv(rate, nper, pmt, pv[, when])	Compute the future value.
- pv(rate, nper, pmt[, fv, when])	Compute the present value.
- npv(rate, values)	Returns the NPV (Net Present Value) of a cash flow series.
- pmt(rate, nper, pv[, fv, when])	Compute the payment against loan principal plus interest.
- ppmt(rate, per, nper, pv[, fv, when])	Compute the payment against loan principal.
- ipmt(rate, per, nper, pv[, fv, when])	Compute the interest portion of a payment.
- irr(values)	Return the Internal Rate of Return (IRR).
- mirr(values, finance_rate, reinvest_rate)	Modified internal rate of return.
- nper(rate, pmt, pv[, fv, when])	Compute the number of periodic payments.
- nrate(nper, pmt, pv, fv[, when, guess, tol, …])	Compute the rate of interest per period.

## Contributing

1. Fork it ( https://github.com/wowinter13/finance_rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT License. See LICENSE for details.
