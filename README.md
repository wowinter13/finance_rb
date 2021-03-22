# finance_rb

This package is a ruby native port of the numpy-financial package with some helpful additional functions.

The functions in this package are a scalar version of their vectorised counterparts in  the [numpy-financial](https://github.com/numpy/numpy-financial) library.

Currently, only some functions are ported,  
which are as follows:  

| numpy-financial function     | ruby native function ported?   | info|
|:------------------------:    |:------------------:  | :------------------|
| fv                           |    |   Computes the  future value|
| ipmt                         |    |   Computes interest payment for a loan|
| pmt                          |    |   Computes the fixed periodic payment(principal + interest) made against a loan amount|
| ppmt                         |    |   Computes principal payment for a loan|
| nper                         |    |    Computes the number of periodic payments|
| pv                           |      |   Computes the present value of a payment|
| rate                         |      |    Computes the rate of interest per period|
| irr                          |       |    Computes the internal rate of return|
| npv                          |  ✅   |   Computes the net present value of a series of cash flow|
| mirr                         |       |    Computes the modified internal rate of return|