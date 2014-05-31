require "sequel"
require "sqlite3"
require "uri"

module ElectronicTargets
  module DataSource
    # Read data from Megalink MLQ files.
    class Megalink < FileBacked
      TARGET_TYPES = {
        4 => Model::Target::ISSF50mRifle.instance,
        21 => Model::Target::ISSF10mRifle.instance,
      }

      def db
        @db ||= Sequel.connect("sqlite://#{URI.encode(file)}")
      end

      def params
        @params ||= Hash[db[:Param].all.map{ |param|
          [param[:Id].to_sym, try_to_i(param[:Data])]
        }]
      end

      def shots
        first_time = 0
        @shots ||= db[:Shots].all.map{ |db_shot|
          Model::Shot.new do |shot|
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
        }
      end

      def target
        target_id = params[:TargetID]
        if TARGET_TYPES.has_key? target_id
          TARGET_TYPES[target_id]
        else
          raise ArgumentError, "Unknown target type: #{target_id}"
        end
      end

      def distance
        params[:DistanceActual]
      end

      def convert(value)
        (([value].pack("N").unpack("g")).shift * scaling_factor).round(2)
      end

      def scaling_factor
        params[:DistanceSimulated].to_f / params[:DistanceActual].to_f
      end

      def try_to_i(value)
        value = value.to_i if value =~ /^-?\d+$/
        value
      end
    end
  end
end
