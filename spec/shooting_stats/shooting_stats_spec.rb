require 'spec_helper'

require 'shooting_stats'

def bad_command_lines
  [
    [sample_mlq],
    ['--foo', sample_mlq, 'list'],
  ]
end

def good_command_lines
  [
    [sample_mlq, 'list'],
    ['-t', 'mlq', sample_mlq, 'list'],
    [sample_mlq, '-t', 'mlq', 'list'],
  ]
end

def sample_mlq
  @sample_mlq = SpecHelper::Fixtures::DataSource::Megalink.new.mlq.values.first
  if @sample_mlq =~ /^#{Dir.pwd}/
    @sample_mlq = @sample_mlq.sub(/^#{Dir.pwd}\/?/, '')
  end
end

describe ShootingStats::Runner do
  describe '#configure_from!' do
    before do
      @runner = ShootingStats::Runner.new
    end

    describe 'does not raise an error when given good arguments' do
      good_command_lines.each do |args|
        it "#{args.join(' ')}" do
          expect {
            @runner.configure_from!(args)
          }.to_not raise_error
        end
      end
    end

    describe 'raises an OptionParser::ParseError when given bad arguments' do
      it '(no arguments)' do
        expect {
          @runner.configure_from!([])
        }.to raise_error OptionParser::ParseError
      end

      bad_command_lines.each do |args|
        it "#{args.join(' ')}" do
          expect {
            @runner.configure_from!(args)
          }.to raise_error OptionParser::ParseError
        end
      end
    end
  end
end
