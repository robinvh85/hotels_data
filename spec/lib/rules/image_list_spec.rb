require 'rules/image_list'

RSpec.describe Rules::ImageList do
  describe '.process(value)' do
    context 'when value is not array' do
      it 'should return value' do
        value = 'value'
        expected_result = value

        expect(Rules::ImageList.process(value)).to eq(expected_result)
      end
    end

    context 'when value is array' do
      context 'when item is not a hash' do
        it 'should return empty' do
          value = ['a']
          expected_result = []

          expect(Rules::ImageList.process(value)).to eq(expected_result)
        end
      end

      context 'when item is a valid hash' do
        it 'should return correctly' do
          value = [{
            "url"=>"http://test.com/test1.jpg",
            "caption"=>"caption 1"
          },{
            "url"=>"http://test.com/test2.jpg",
            "caption"=>"caption 2"
          }]
          expected_result = [{
            "link"=>"http://test.com/test1.jpg",
            "description"=>"caption 1"
          },{
            "link"=>"http://test.com/test2.jpg",
            "description"=>"caption 2"
          }]

          expect(Rules::ImageList.process(value)).to eq(expected_result)
        end
      end
    end
  end
end
