require 'rules/better_length'

RSpec.describe Rules::BetterLength do
  describe '.process(old_value, new_value)' do
    context 'when old_value is nil' do
      it 'should return new_value' do
        old_value = nil
        new_value = 'new_value'
        expected_result = new_value

        expect(Rules::BetterLength.process(old_value, new_value)).to eq(expected_result)
      end
    end

    context 'when new_value is nil' do
      it 'should return old_value' do
        old_value = 'old_value'
        new_value = nil
        expected_result = old_value

        expect(Rules::BetterLength.process(old_value, new_value)).to eq(expected_result)
      end
    end

    context 'when new_value length > old_value length' do
      context 'when string params' do
        it 'should return new_value' do
          old_value = 'old_value'
          new_value = 'new_value better'
          expected_result = new_value

          expect(Rules::BetterLength.process(old_value, new_value)).to eq(expected_result)
        end
      end

      context 'when array params' do
        it 'should return new_value' do
          old_value = ['old', 'value']
          new_value = ['new', 'value', 'better']
          expected_result = new_value

          expect(Rules::BetterLength.process(old_value, new_value)).to eq(expected_result)
        end
      end
    end

    context 'when new_value length < old_value length' do
      context 'when string params' do
        it 'should return old_value' do
          old_value = 'old_value better'
          new_value = 'new_value'
          expected_result = old_value

          expect(Rules::BetterLength.process(old_value, new_value)).to eq(expected_result)
        end
      end

      context 'when array params' do
        it 'should return new_value' do
          old_value = ['old', 'value', 'better']
          new_value = ['new', 'value']
          expected_result = old_value

          expect(Rules::BetterLength.process(old_value, new_value)).to eq(expected_result)
        end
      end
    end

    context 'when new_value length == old_value length' do
      context 'when string params' do
        it 'should return old_value' do
          old_value = 'old_value'
          new_value = 'new_value'
          expected_result = old_value

          expect(Rules::BetterLength.process(old_value, new_value)).to eq(expected_result)
        end
      end

      context 'when array params' do
        it 'should return new_value' do
          old_value = ['old', 'value']
          new_value = ['new', 'value']
          expected_result = old_value

          expect(Rules::BetterLength.process(old_value, new_value)).to eq(expected_result)
        end
      end
    end
  end
end
