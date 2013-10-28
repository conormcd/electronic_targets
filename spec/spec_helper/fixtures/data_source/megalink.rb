require 'csv'

module SpecHelper
  module Fixtures
    module DataSource
      class Megalink
        def initialize
          @mlq = {}
          @precomputed = {}
        end

        def fixtures_dir(path)
          File.expand_path("../../../../fixtures/#{path}", __FILE__)
        end

        def mlq_files
          Dir[File.join(fixtures_dir('data_source/megalink/mlq'), "*.mlq")]
        end

        def mlq
          return @mlq unless @mlq.empty?
          mlq_files.each do |path|
            @mlq[File.basename(path)] = path
          end
          @mlq
        end

        def precomputed_files
          dir = fixtures_dir('data_source/megalink/pre-computed')
          Dir[File.join(dir, "*.csv")].each
        end

        def precomputed
          return @precomputed unless @precomputed.empty?
          precomputed_files.each do |path|
            data = []
            header = []
            CSV.foreach(path) do |line|
              if header.count > 0
                data.push(make_hash(line, header))
              else
                header = line.map {|field| field.to_sym}
              end
            end
            @precomputed[File.basename(path)] = data
          end
          @precomputed
        end

        def make_hash(data_line, header_line)
          hsh = {}
          data_line.each_index do |i|
            field = data_line[i]
            field = field.to_i if field =~ /^-?\d+$/
            field = field.to_f if field =~ /^-?\d+\.\d+$/
            hsh[header_line[i]] = field
          end
          hsh
        end
      end
    end
  end
end
