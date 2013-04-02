require 'spec_helper'

require 'shooting_stats'

def sample_mlq
  sample_mlq = SpecHelper::Fixtures::DataSource::Megalink.new.mlq.values.first
  if sample_mlq =~ /^#{Dir.pwd}/
    sample_mlq = sample_mlq.sub(/^#{Dir.pwd}\/?/, '')
  end
  sample_mlq
end

describe ShootingStats::Runner do
  describe '#configure!' do
    shared_examples '#configure!' do |good_or_bad, args|
      args_string = args.empty? ? 'no arguments' : args.join(' ')
      context "when given #{args_string}" do
        before do
          @runner = ShootingStats::Runner.new(args)
        end

        it 'sets the help message' do
          begin
            @runner.configure!
          rescue OptionParser::ParseError
          ensure
            @runner.help_message.should_not be_nil
          end
        end

        if good_or_bad == :good
          it 'does not raise an OptionParser::ParseError' do
            expect {
              @runner.configure!
            }.to_not raise_error OptionParser::ParseError
          end
        else
          it 'raises an OptionParser::ParseError' do
            expect {
              @runner.configure!
            }.to raise_error OptionParser::ParseError
          end
        end
      end
    end

    it_should_behave_like '#configure!', :good, [sample_mlq, 'list']
    it_should_behave_like '#configure!', :good,
      ['-t', 'mlq', sample_mlq, 'list']
    it_should_behave_like '#configure!', :good,
      [sample_mlq, '-t', 'mlq', 'list']
    it_should_behave_like '#configure!', :bad, []
    it_should_behave_like '#configure!', :bad, [sample_mlq]
    it_should_behave_like '#configure!', :bad,
      ['--foo', sample_mlq, 'list']
  end
end
