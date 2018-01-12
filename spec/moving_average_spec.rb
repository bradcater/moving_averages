require 'moving_average'

describe MovingAverage do

  describe "exponential moving average" do

    # Example taken from
    #   http://stockcharts.com/school/doku.php?id=chart_school:technical_indicators:moving_averages
    EMA_DATA = [22.27, 22.19, 22.08, 22.17, 22.18, 22.13, 22.23, 22.43, 22.24, 22.29].freeze
    EMA = 22.247

    it "should work for single-element Arrays" do
      expect([EMA_DATA[0]].exponential_moving_average.round(3)).to eql(EMA_DATA[0])
      expect([EMA_DATA[0]].ema.round(3)).to eql(EMA_DATA[0])
    end

    it "should work for missing arguments" do
      expect(EMA_DATA.exponential_moving_average.round(3)).to eql(EMA)
      expect(EMA_DATA.ema.round(3)).to eql(EMA)
      expect(EMA_DATA.exponential_moving_average(9).round(3)).to eql(EMA)
      expect(EMA_DATA.ema(9).round(3)).to eql(EMA)
    end

    it "should work for valid arguments" do
      # Example taken from
      #   http://stockcharts.com/school/doku.php?id=chart_school:technical_indicators:moving_averages
      expect(EMA_DATA.exponential_moving_average(9, 10).round(3)).to eql(EMA)
      expect(EMA_DATA.ema(9, 10).round(3)).to eql(EMA)
    end

    it "should raise proper errors for invalid arguments" do
      expect { [1, 2, 3].exponential_moving_average(-1, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
      expect { [1, 2, 3].exponential_moving_average(3, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
      expect { [1, 2, 3].exponential_moving_average(1, -1) }.to raise_exception(MovingAverage::Errors::InvalidTailError, "Given tail is <= 0.")
      expect { [1, 2, 3].exponential_moving_average(1, 3) }.to raise_exception(MovingAverage::Errors::NotEnoughDataError, "Given tail is too large for idx.")
    end

  end

  describe "simple moving average" do

    it "should work for single-element Arrays" do
      expect([1].simple_moving_average).to eq(1)
      expect([1].sma).to eq(1)
    end

    it "should work for missing arguments" do
      expect((1..5).to_a.simple_moving_average).to eq(3)
      expect((1..5).to_a.sma).to eq(3)
      expect((1..5).to_a.simple_moving_average(4)).to eq(3)
      expect((1..5).to_a.sma(4)).to eq(3)
    end

    it "should work for valid arguments" do
      expect((1..5).to_a.simple_moving_average(4, 5)).to eq(3)
      expect((1..5).to_a.sma(4, 5)).to eq(3)
    end

    it "should raise proper errors for invalid arguments" do
      expect { [1, 2, 3].simple_moving_average(-1, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
      expect { [1, 2, 3].simple_moving_average(3, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
      expect { [1, 2, 3].simple_moving_average(1, -1) }.to raise_exception(MovingAverage::Errors::InvalidTailError, "Given tail is <= 0.")
      expect { [1, 2, 3].simple_moving_average(1, 3) }.to raise_exception(MovingAverage::Errors::NotEnoughDataError, "Given tail is too large for idx.")
    end

  end

  describe "smoothed moving average" do

    SMMA_DATA = (1..10).to_a.freeze
    SMMA = 8.5

    it "should raise proper errors for single-element Arrays" do
      expect { [SMMA_DATA[0]].smoothed_moving_average }.to raise_exception(MovingAverage::Errors::InvalidTailError, "Given tail is <= 0.")
      expect { [SMMA_DATA[0]].smma }.to raise_exception(MovingAverage::Errors::InvalidTailError, "Given tail is <= 0.")
    end

    it "should work for missing arguments" do
      expect(SMMA_DATA.smoothed_moving_average.round(1)).to eq(SMMA)
      expect(SMMA_DATA.smma.round(1)).to eq(SMMA)
      expect(SMMA_DATA.smoothed_moving_average(9).round(1)).to eq(SMMA)
      expect(SMMA_DATA.smma(9).round(1)).to eq(SMMA)
    end

    it "should work for valid arguments" do
      expect(SMMA_DATA.smoothed_moving_average(9, 5).round(1)).to eq(SMMA)
      expect(SMMA_DATA.smma(9, 5).round(1)).to eq(SMMA)
    end

    it "should raise proper errors for invalid arguments" do
      expect { [1, 2, 3].smoothed_moving_average(-1, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
      expect { [1, 2, 3].smoothed_moving_average(3, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
      expect { [1, 2, 3].smoothed_moving_average(1, -1) }.to raise_exception(MovingAverage::Errors::InvalidTailError, "Given tail is <= 0.")
      expect { [1, 2, 3].smoothed_moving_average(1, 3) }.to raise_exception(MovingAverage::Errors::NotEnoughDataError, "Given tail is too large for idx.")
    end

  end

  describe "weighted moving average" do

    # Example taken from
    #   http://daytrading.about.com/od/indicators/a/MovingAverages.htm
    WMA_DATA = [1.2900, 1.2900, 1.2903, 1.2904].freeze
    WMA = 1.29025

    it "should work for single-element Arrays" do
      expect([WMA_DATA[0]].weighted_moving_average).to eq(WMA_DATA[0])
      expect([WMA_DATA[0]].wma).to eq(WMA_DATA[0])
    end

    it "should work for missing arguments" do
      expect(WMA_DATA.weighted_moving_average).to eql(WMA)
      expect(WMA_DATA.wma).to eql(WMA)
      expect(WMA_DATA.weighted_moving_average(3)).to eql(WMA)
      expect(WMA_DATA.wma(3)).to eql(WMA)
    end

    it "should work for valid arguments" do
      expect(WMA_DATA.weighted_moving_average(3, 4)).to eql(WMA)
      expect(WMA_DATA.wma(3, 4)).to eql(WMA)
    end

    it "should raise proper errors for invalid arguments" do
      expect { [1, 2, 3].weighted_moving_average(-1, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
      expect { [1, 2, 3].weighted_moving_average(3, 3) }.to raise_exception(MovingAverage::Errors::InvalidIndexError, "Given idx is outside the Array.")
      expect { [1, 2, 3].weighted_moving_average(1, -1) }.to raise_exception(MovingAverage::Errors::InvalidTailError, "Given tail is <= 0.")
      expect { [1, 2, 3].weighted_moving_average(1, 3) }.to raise_exception(MovingAverage::Errors::NotEnoughDataError, "Given tail is too large for idx.")
    end

  end

end
