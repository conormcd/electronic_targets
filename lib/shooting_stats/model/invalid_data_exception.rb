module ShootingStats
  module Model
    # An exception to be raised if a Shot, Card or Target is constructed with
    # missing or obviously wrong data.
    class InvalidDataException < StandardError
    end
  end
end
