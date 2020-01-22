require 'rules/trim_string'

RSpec.describe Rules::TrimString do
  describe '.process(value)' do
    context 'when value is nil' do
      it 'should return nil' do
        value = nil
        expected_result = nil

        expect(Rules::TrimString.process(value)).to eq(expected_result)
      end
    end

    context 'when value is a number' do
      it 'should return value' do
        value = 1.2
        expected_result = value

        expect(Rules::TrimString.process(value)).to eq(expected_result)
      end
    end

    context 'when value is a string' do
      it 'should return a trim value' do
        value = ' value '
        expected_result = 'value'

        expect(Rules::TrimString.process(value)).to eq(expected_result)
      end
    end

    context 'when value is an array' do
      it 'should return a trim value' do
        value = [' a ', 'b', '    c', 'd    ']
        expected_result = ['a', 'b', 'c', 'd']

        expect(Rules::TrimString.process(value)).to eq(expected_result)
      end
    end

    context 'when value is a hash' do
      it 'should return a trim value' do
        value = {
          a: ' a ',
          b: 'b',
          c: '   c',
          d: 'd   '
        }
        expected_result = {
          a: 'a',
          b: 'b',
          c: 'c',
          d: 'd'
        }

        expect(Rules::TrimString.process(value)).to eq(expected_result)
      end
    end
  end
end
