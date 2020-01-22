require 'utils'

RSpec.describe Utils do
  describe '.convert_to_dotted_hash(data_hash, parent_key)' do
    context 'when params are invalid' do
      context 'when data_hash is not a hash' do
        it 'should return empty hash' do
          data_hash = [1,2,3]
          expected_result = {}

          expect(Utils.convert_to_dotted_hash(data_hash)).to eq(expected_result)
        end
      end
    end

    context 'when data_hash is a hash' do
      context 'when have no parent_key' do
        it 'should return correctly' do
          data_hash = {people: {person: {name: 'My Name'}}}
          expected_result = {'people.person.name'=>'My Name'}

          expect(Utils.convert_to_dotted_hash(data_hash)).to eq(expected_result)
        end
      end

      context 'when have parent_key' do
        it 'should return correctly' do
          data_hash = {people: {person: {name: 'My Name'}}}
          parent_key = 'parent'
          expected_result = {'parent.people.person.name'=>'My Name'}

          expect(Utils.convert_to_dotted_hash(data_hash, parent_key)).to eq(expected_result)
        end
      end
    end
  end

  describe '.build_map_keys(schema_keys, parent_key)' do
    context 'when params are invalid' do
      context 'when schema_keys is not a hash' do
        it 'should return empty hash' do
          schema_keys = [
            id: %i[Id hotel_id id],
            location: {
              lat: %i[Latitude lat],
              address: %i[Address location.address]
            }
          ]

          expected_result = {}

          expect(Utils.build_map_keys(schema_keys)).to eq(expected_result)
        end
      end
    end

    context 'when schema_keys is valid' do
      context 'when have no parent_key' do
        it 'should return correctly' do
          schema_keys = {
            id: %i[Id hotel_id id],
            location: {
              lat: %i[Latitude lat],
              address: %i[Address location.address]
            }
          }

          expected_result = {
            "Id"=>"id",
            "hotel_id"=>"id",
            "id"=>"id",
            "Latitude"=>"location.lat",
            "lat"=>"location.lat",
            "Address"=>"location.address",
            "location.address"=>"location.address"
          }

          expect(Utils.build_map_keys(schema_keys)).to eq(expected_result)
        end
      end

      context 'when have parent_key' do
        it 'should return correctly' do
          schema_keys = {
            id: %i[Id hotel_id id],
            location: {
              lat: %i[Latitude lat],
              address: %i[Address location.address]
            }
          }
          parent_key = 'parent'

          expected_result = {
            "Id"=>"parent.id",
            "hotel_id"=>"parent.id",
            "id"=>"parent.id",
            "Latitude"=>"parent.location.lat",
            "lat"=>"parent.location.lat",
            "Address"=>"parent.location.address",
            "location.address"=>"parent.location.address"
          }

          expect(Utils.build_map_keys(schema_keys, parent_key)).to eq(expected_result)
        end
      end
    end
  end

  describe '.merge_nested_hash_with_key(data_hash, key, value)' do
    context 'when params are invalid' do
      context 'when data_hash is not Hash' do
        it 'should be return empty hash' do
          data_hash = ["other", "value"]
          key = "people.person.name"
          value = "My Name"

          expected_result = {}

          expect(Utils.merge_nested_hash_with_key(data_hash, key, value)).to eq(expected_result)
        end
      end

      context 'when key empty' do
        it 'should be return empty hash' do
          data_hash = ["other", "value"]
          key = ""
          value = "My Name"

          expected_result = {}

          expect(Utils.merge_nested_hash_with_key(data_hash, key, value)).to eq(expected_result)
        end
      end
    end

    context 'when params are valid' do
      context 'when data_hash is valid' do
        it 'should be return correctly' do
          data_hash = {"other"=>"value"}
          key = "people.person.name"
          value = "My Name"

          expected_result = {
            "other"=>"value",
            "people"=>{
              "person"=>{
                "name"=>"My Name"
              }
            }
          }

          expect(Utils.merge_nested_hash_with_key(data_hash, key, value)).to eq(expected_result)
        end
      end

      context 'when key is not a nested key' do
        it 'should be return correctly' do
          data_hash = {"other"=>"value"}
          key = "name"
          value = "My Name"

          expected_result = {
            "other"=>"value",
            "name"=>"My Name"
          }

          expect(Utils.merge_nested_hash_with_key(data_hash, key, value)).to eq(expected_result)
        end
      end
    end
  end

  describe '.transform_data_with_map(data_hash, mapped_keys)' do
    context 'when params are invalid' do
      context 'when data_hash is not Hash' do
        it 'should be return empty hash' do
          data_hash = ["Latitude"]
          mapped_keys = {"Latitude"=>"location.lat"}

          expected_result = {}

          expect(Utils.transform_data_with_map(data_hash, mapped_keys)).to eq(expected_result)
        end
      end

      context 'when mapped_keys is not Hash' do
        it 'should be return empty hash' do
          data_hash = {"Latitude"=>1.2}
          mapped_keys = ["Latitude", "location.lat"]

          expected_result = {}

          expect(Utils.transform_data_with_map(data_hash, mapped_keys)).to eq(expected_result)
        end
      end
    end

    context 'when params are valid' do
      it 'should return correctly' do
        data_hash = {"Latitude"=>1.2}
        mapped_keys = {"Latitude"=>"location.lat"}
        expected_result = {"location"=>{"lat"=>1.2}}

        expect(Utils.transform_data_with_map(data_hash, mapped_keys)).to eq(expected_result)
      end
    end
  end
end
