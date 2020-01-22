require 'rules/lower_case'

RSpec.describe Rules::LowerCase do
  describe '.process(value)' do
    context 'when value is nil' do
      it 'should return nil' do
        value = nil
        expected_result = nil

        expect(Rules::LowerCase.process(value)).to eq(expected_result)
      end
    end

    context 'when value is a number' do
      it 'should return value' do
        value = 1.2
        expected_result = value

        expect(Rules::LowerCase.process(value)).to eq(expected_result)
      end
    end

    context 'when value is a hash' do
      it 'should return value' do
        value = { a: 'a' }
        expected_result = value

        expect(Rules::LowerCase.process(value)).to eq(expected_result)
      end
    end

    context 'when value is a string' do
      it 'should return a lowercase value' do
        value = 'ABC'
        expected_result = 'abc'

        expect(Rules::LowerCase.process(value)).to eq(expected_result)
      end
    end

    context 'when value is an array' do
      it 'should return a lowercase value' do
        value = ['A', 'B']
        expected_result = ['a', 'b']

        expect(Rules::LowerCase.process(value)).to eq(expected_result)
      end
    end
  end
end
