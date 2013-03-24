class Array

  def idx_and_tail_or_defaults(idx, tail) #:nodoc:
    if tail.nil?
      tail = self.size
      if idx.nil?
        idx = self.size - 1
      end
    end
    [idx, tail]
  end; private :idx_and_tail_or_defaults

  def valid_for_ma(idx, tail) #:nodoc:
    unless idx >= 0 && idx < self.size
      raise MovingAverage::Errors::InvalidIndexError
    end
    unless tail > 0
      raise MovingAverage::Errors::InvalidTailError
    end
    unless idx - tail >= -1
      raise MovingAverage::Errors::NotEnoughDataError
    end
    true
  end; private :valid_for_ma

  # Compute the exponential moving average (EMA) of the values of an Array.
  #
  # Formally, the EMA can be computed as n / d, where
  #
  #     n = p_1 + (1 - alpha)p_2 + (1 - alpha)^2p_3 + ... + (1 - alpha)^zp_(z + 1)
  #
  # and
  #
  #     d = 1 + (1 - alpha) + (1 - alpha)^2 + (1 - alpha)^3 + ... + (1 - alpha)^z
  #
  # where
  #
  #     alpha = 2 / (z + 1)
  #
  # Formula taken from
  # http://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average
  #
  # ==== Parameters
  #
  # * +idx+ - Optional, the index of the last datum to consider.
  # * +tail+ - Optional, the number of data to consider.
  def exponential_moving_average(idx=nil, tail=nil)
    idx, tail = idx_and_tail_or_defaults(idx, tail)
    valid_for_ma(idx, tail)
    alpha = 2.0 / (tail + 1)
    n = (1..tail).to_a.map{|tidx| (1 - alpha) ** (tidx - 1) * self[idx - tidx + 1]}.sum
    d = (1..tail).to_a.map{|tidx| (1 - alpha) ** (tidx - 1)}.sum
    n / d
  end
  alias_method :ema, :exponential_moving_average

  # Compute the simple moving average (SMA) of the values of an Array.
  #
  # ==== Parameters
  #
  # * +idx+ - Optional, the index of the last datum to consider.
  # * +tail+ - Optional, the number of data to consider.
  def simple_moving_average(idx=nil, tail=nil)
    idx, tail = idx_and_tail_or_defaults(idx, tail)
    valid_for_ma(idx, tail)
    self[idx-tail+1..idx].sum.to_f / tail
  end
  alias_method :sma, :simple_moving_average

  # Compute the smoothed moving average of the values of an Array.
  #
  # Formally, given that the first value for the SMMA is the SMA, subsequent
  # values can be computed as
  #
  #     (sma - smma_i-1 + a[i])
  #     -----------------------
  #               n
  #
  # where
  #
  #     smma_i-1
  #
  # is the smoothed moving average of the previous index.
  #
  # Formula taken from
  # https://mahifx.com/indicators/smoothed-moving-average-smma
  #
  # ==== Parameters
  #
  # * +idx+ - Optional, the index of the last datum to consider.
  # * +tail+ - Optional, the number of data to consider.
  def smoothed_moving_average(idx=nil, tail=nil)
    # Set these manually here since we need the leading SMA.
    if tail.nil?
      idx = self.size - 1 if idx.nil?
      tail = idx / 2
      tail += 1 if idx.odd?
    end
    idx, tail = idx_and_tail_or_defaults(idx, tail)
    valid_for_ma(idx, tail)
    valid_for_ma(idx - tail, tail)
    smma1 = self[idx - 2 * tail + 1..idx - tail].sma
    (idx - tail + 1..idx).to_a.each do |tidx|
      prevsum = self[tidx - tail + 1..tidx].sum
      smma1 = (prevsum - smma1 + self[idx - (idx - tidx)]) / tail
    end
    smma1
  end
  alias_method :smma, :smoothed_moving_average

  # Compute the weighted moving average of the values of an Array.
  #
  # Formally, the WMA can be computed as n / d, where
  #
  #     n = zp_M + (z - 1)p_(M - 1) + (z - 2)p_(M - 3) + ...
  #
  # and
  #
  #     d = z + (z - 1) + (z - 2) + ...
  #
  # The denominator is a triangle number of the form
  #
  #     z(z + 1) / 2
  #
  # Formula taken from
  # http://en.wikipedia.org/wiki/Moving_average#Weighted_moving_average
  #
  # ==== Parameters
  #
  # * +idx+ - Optional, the index of the last datum to consider.
  # * +tail+ - Optional, the number of data to consider.
  def weighted_moving_average(idx=nil, tail=nil)
    idx, tail = idx_and_tail_or_defaults(idx, tail)
    valid_for_ma(idx, tail)
    n = (0..tail-1).to_a.map{|tidx| (tail - tidx) * self[idx - tidx]}.sum
    d = (tail * (tail + 1)) / 2.0
    n / d
  end
  alias_method :wma, :weighted_moving_average
  
  unless method_defined?(:sum)
    # Compute the sum of the values of an Array.
    def sum
      inject(0){|s, n| s += n}
    end
  end
end
