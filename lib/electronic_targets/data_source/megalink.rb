require "sequel"
require "sqlite3"
require "uri"

module ElectronicTargets
  module DataSource
    # Read data from Megalink MLQ files.
    class Megalink
      TARGET_TYPES = {
        4 => Model::Target::ISSF50mRifle.instance,
        21 => Model::Target::ISSF10mRifle.instance,
      }

      attr_accessor :path

      def initialize(path)
        @path = path
        @params = {}
        @shots = []

        raise ArgumentError, "No path to MLQ provided" if @path.nil?
        raise ArgumentError, "#{@path} not found" unless File.exists? @path
      end

      def db
        @db ||= Sequel.connect("sqlite://#{URI.encode(path)}")
      end

      def params
        if @params.empty?
          db.fetch("SELECT * FROM Param") do |param|
            key = param[:Id].to_sym
            value = param[:Data]

            value = value.to_i if value =~ /^-?\d+$/
            value = value.to_f if value =~ /^-?\d+\.\d+$/

            @params[key] = value
          end
        end
        @params
      end

      def shots
        if @shots.empty?
          first_time = 0

          db.fetch("SELECT * FROM Shots") do |db_shot|
            @shots << Model::Shot.new do |shot|
              shot.series = db_shot[:Series]
              shot.horizontal_error = convert(db_shot[:X])
              shot.vertical_error = convert(db_shot[:Y])
              shot.target = target
              if first_time > 0
                shot.time = (db_shot[:TimeStamp] - first_time) / 100.0
              else
                shot.time = 0
                first_time = db_shot[:TimeStamp]
              end
            end
          end
        end
        @shots
      end

      def target
        target_id = params[:TargetID]
        if TARGET_TYPES.has_key? target_id
          TARGET_TYPES[target_id]
        else
          raise ArgumentError, "Unknown target type: #{target_id}"
        end
      end

      def convert(value)
        (([value].pack("N").unpack("g")).shift * scaling_factor).round(2)
      end

      def scaling_factor
        params[:DistanceSimulated].to_f / params[:DistanceActual].to_f
      end
    end
  end
end
