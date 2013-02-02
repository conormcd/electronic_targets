require "sequel"
require "sqlite3"

require "shooting_stats/model/card"
require "shooting_stats/model/shot"
require "shooting_stats/model/target"

module ShootingStats
  module DataSource
    # Read data from Megalink MLQ files.
    class Megalink
      attr_accessor :path

      def initialize(path=nil)
        @path = path
        @params = {}
        @shots = []
      end

      def db
        if @db.nil?
          raise "No path to .mlq file provided" if path.nil?
          raise "#{path} does not exist" unless File.exists? path
          @db = Sequel.connect("sqlite://#{path}")
        end
        @db
      end

      def params
        if @params.empty?
          db.fetch("SELECT * FROM Param") do |param|
            @params[param[:Id].to_sym] = param[:Data]
          end
        end
        @params
      end

      def shots
        if @shots.empty?
          first_time = 0

          db.fetch("SELECT * FROM Shots") do |db_shot|
            @shots << Model::Shot.new do |shot|
              shot.horizontal_error = convert(db_shot[:X])
              shot.vertical_error = convert(db_shot[:Y])
              shot.card = Model::Card.new do |c|
                c.name = params[:CardName]
              end
              shot.target = Model::Target::ISSF50mRifle.instance
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

      def convert(value)
        (([value].pack("N").unpack("g")).shift * scaling_factor).round(2)
      end

      def scaling_factor
        params[:DistanceSimulated].to_f / params[:DistanceActual].to_f
      end
    end
  end
end
