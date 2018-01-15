module MovingAverage

  module Errors #:nodoc:

    class EmptyArrayError < ArgumentError
      def message
        'Cannot find a moving average for an empty Array.'
      end
    end

    class InvalidIndexError < IndexError
      def message
        'Given idx is outside the Array.'
      end
    end

    class InvalidTailError < RangeError
      def message
        'Given tail is <= 0.'
      end
    end

    class NotEnoughDataError < ArgumentError
      def message
        'Given tail is too large for idx.'
      end
    end

  end

end
