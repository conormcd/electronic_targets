module ShootingStats
  module DataSource
    # An exception to be raised if the type of the data source is unknown or
    # cannot be detected.
    class InvalidDataSourceException < StandardError
    end
  end
end
