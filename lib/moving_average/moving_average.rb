class Array

  def valid_for_ma(idx, tail)
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

  def exponential_moving_average(idx, tail)
    valid_for_ma(idx, tail)
    # Taken from
    #   http://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average
    #     p_1 + (1 - alpha)p_2 + (1 - alpha)^2p_3 + ...
    # -----------------------------------------------------
    # 1 + (1 - alpha) + (1 - alpha)^2 + (1 - alpha)^3 + ...
    alpha = 2.0 / (tail + 1)
    n = (1..tail).to_a.map{|tidx| (1 - alpha) ** (tidx - 1) * self[idx - tidx + 1]}.sum
    d = (1..tail).to_a.map{|tidx| (1 - alpha) ** (tidx - 1)}.sum
    n / d
  end
  alias_method :ema, :exponential_moving_average

  def simple_moving_average(idx, tail)
    valid_for_ma(idx, tail)
    self[idx-tail+1..idx].sum.to_f / tail
  end
  alias_method :sma, :simple_moving_average

  def weighted_moving_average(idx, tail)
    valid_for_ma(idx, tail)
    # Taken from
    #   http://en.wikipedia.org/wiki/Moving_average#Weighted_moving_average
    # np_M + (n - 1)p_(M - 1) + (n - 2)p_(M - 3) + ...
    # ------------------------------------------------
    #            n + (n - 1) + (n - 2) + ...
    # The denominator is a triangle number of the form
    # n(n + 1)
    # --------
    #    2
    n = (0..tail-1).to_a.map{|tidx| (tail - tidx) * self[idx - tidx]}.sum
    d = (tail * (tail + 1)) / 2.0
    n / d
  end
  alias_method :wma, :weighted_moving_average
  
  unless method_defined?(:sum)
    def sum
      inject(0){|s, n| s += n}
    end
  end
end
