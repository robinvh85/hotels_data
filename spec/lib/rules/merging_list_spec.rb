require 'rules/merging_list'

RSpec.describe Rules::MergingList do
  describe '.process(old_value, new_value)' do
    context 'when new_value is not array' do
      it 'should return old_value' do
        old_value = ['a']
        new_value = nil
        expected_result = old_value

        expect(Rules::MergingList.process(old_value, new_value)).to eq(expected_result)
      end
    end

    context 'when old_value is not array' do
      it 'should return new_value' do
        old_value = 'a'
        new_value = ['b']
        expected_result = new_value

        expect(Rules::MergingList.process(old_value, new_value)).to eq(expected_result)
      end
    end

    context 'when both params are arrays' do
      context 'when have no duplicated value' do
        it 'should return correctly' do
          old_value = ['a', 'b']
          new_value = ['c', 'd']
          expected_result = ['a', 'b', 'c', 'd']

          expect(Rules::MergingList.process(old_value, new_value)).to eq(expected_result)
        end
      end

      context 'when have duplicated value' do
        it 'should return correctly' do
          old_value = ['a', 'b']
          new_value = ['b', 'c']
          expected_result = ['a', 'b', 'c']

          expect(Rules::MergingList.process(old_value, new_value)).to eq(expected_result)
        end
      end
    end
  end
end
