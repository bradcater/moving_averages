# MovingAverage

This gem adds methods to the Array class to compute different types of moving
averages.

## Installation

Add this line to your application's Gemfile:

    gem 'moving_average'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moving_average

## Usage

To compute a simple moving average (SMA), you can use

    a = [1, 2, 3, 4, 5]
    a.simple_moving_average(3, 4) => 2.5

or

    a.sma(3, 4) => 2.5

An exponential moving average (EMA) and a weighted moving average (WMA) may be
computed in the same way.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
