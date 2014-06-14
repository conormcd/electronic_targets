require "spec_helper"

describe ElectronicTargets::DataSource do
  describe ".from_file" do
    shared_examples_for 'a valid call' do
      let(:data_source) { ElectronicTargets::DataSource.from_file(*args) }

      it 'does not raise an error' do
        expect { data_source }.to_not raise_error
      end

      it 'returns a data source' do
        expect(data_source).to respond_to :shots
      end
    end

    shared_examples_for 'an invalid call' do
      it 'raises an ArgumentError' do
        expect {
          ElectronicTargets::DataSource.from_file(*args)
        }.to raise_error ArgumentError
      end
    end

    let(:mlq_file) { megalink_fixtures.mlq_files.first }
    let(:other_file) { megalink_fixtures.precomputed_files.first }

    context 'when given a file with a known extension' do
      it_behaves_like 'a valid call' do
        let(:args) { [mlq_file] }
      end
    end

    context 'when given a bad file name' do
      it_behaves_like 'an invalid call' do
        let(:args) { ['/does/not/exist'] }
      end
    end

    context 'when given a file with an unknown extension' do
      it_behaves_like 'an invalid call' do
        let(:args) { [other_file] }
      end
    end

    context 'when given a bad file type' do
      it_behaves_like 'an invalid call' do
        let(:args) { [mlq_file, 'not-megalink'] }
      end
    end
  end
end
