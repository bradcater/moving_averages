require 'moving_average'

describe MovingAverage do

  it "exponential moving average should work for valid arguments" do
    # Example taken from
    #   http://stockcharts.com/school/doku.php?id=chart_school:technical_indicators:moving_averages
    a = [22.27, 22.19, 22.08, 22.17, 22.18, 22.13, 22.23, 22.43, 22.24, 22.29]
    a.exponential_moving_average(9, 10).round(3).should eql(22.247)
    a.ema(9, 10).round(3).should eql(22.247)
  end

  it "exponential moving average should raise NotEnoughDataError for invalid arguments" do
    expect { [1, 2, 3].exponential_moving_average(-1, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
    expect { [1, 2, 3].exponential_moving_average(3, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
    expect { [1, 2, 3].exponential_moving_average(1, -1) }.to raise_exception(MovingAverage::Errors::InvalidTailError, "Given tail is <= 0.")
    expect { [1, 2, 3].exponential_moving_average(1, 3) }.to raise_exception(MovingAverage::Errors::NotEnoughDataError, "Given tail is too large for idx.")
  end

  it "simple moving average should work" do
    (1..5).to_a.simple_moving_average(4, 5).should ==(3)
    (1..5).to_a.sma(4, 5).should ==(3)
  end

  it "simple moving average should raise proper errors for invalid arguments" do
    expect { [1, 2, 3].simple_moving_average(-1, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
    expect { [1, 2, 3].simple_moving_average(3, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
    expect { [1, 2, 3].simple_moving_average(1, -1) }.to raise_exception(MovingAverage::Errors::InvalidTailError, "Given tail is <= 0.")
    expect { [1, 2, 3].simple_moving_average(1, 3) }.to raise_exception(MovingAverage::Errors::NotEnoughDataError, "Given tail is too large for idx.")
  end

  it "weighted moving average should work" do
    # Example taken from
    #   http://daytrading.about.com/od/indicators/a/MovingAverages.htm
    vals = [1.2900, 1.2900, 1.2903, 1.2904]
    vals.weighted_moving_average(3, 4).should eql(1.29025)
    vals.wma(3, 4).should eql(1.29025)
  end

  it "weighted moving average should raise proper errors for invalid arguments" do
    expect { [1, 2, 3].weighted_moving_average(-1, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
    expect { [1, 2, 3].weighted_moving_average(3, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
    expect { [1, 2, 3].weighted_moving_average(1, -1) }.to raise_exception(MovingAverage::Errors::InvalidTailError, "Given tail is <= 0.")
    expect { [1, 2, 3].weighted_moving_average(1, 3) }.to raise_exception(MovingAverage::Errors::NotEnoughDataError, "Given tail is too large for idx.")
  end

end
