require "rails_helper"

RSpec.describe "Hotels APIs", :type => :request do
  describe 'GET /api/hotels/search' do
    before {
      create(:hotel, hotel_id: "h1", destination_id: 10, detail: {"id"=>"h1", "destination_id"=>10, "name":"hotel 1"})
      create(:hotel, hotel_id: "h2", destination_id: 10, detail: {"id"=>"h2", "destination_id"=>10, "name":"hotel 2"})
      create(:hotel, hotel_id: "h3", destination_id: 11, detail: {"id"=>"h3", "destination_id"=>11, "name":"hotel 3"})
    }

    let!(:params) {}
    subject { post "/api/hotels/search", params: params }

    context 'when have no params' do
      it "should return error bad_request" do
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when have only param destination_id' do
      context 'when not matched destination_id' do
        let(:params) { {destination_id: 1} }

        it "should be success and empty data" do
          subject
          body = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          expect(body).to eq([])
        end
      end

      context 'when matched destination_id' do
        let(:params) { {destination_id: 11} }

        it "should be success and have 1 hotel" do
          subject
          body = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          expect(body.length).to eq(1)
          expect(body[0]["destination_id"]).to eq(11)
        end
      end

      context 'when matched destination_id and have 2 hotels' do
        let(:params) { {destination_id: 10} }

        it "should be success and have 2 hotels" do
          subject
          body = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          expect(body.length).to eq(2)
          expect(body[0]["destination_id"]).to eq(10)
          expect(body[1]["destination_id"]).to eq(10)
        end
      end
    end

    context 'when have only param hotel_ids' do
      context 'when not matched hotel_ids' do
        let(:params) { {hotel_ids: ['h0']} }

        it "should be success and return empty data" do
          subject
          body = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          expect(body).to eq([])
        end
      end

      context 'when matched 1 hotel_ids' do
        let(:params) { {hotel_ids: ['h1']} }

        it "should be success and return 1 hotel" do
          subject
          body = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          expect(body.length).to eq(1)
          expect(body[0]['id']).to eq('h1')
        end
      end

      context 'when matched 2 hotel_ids' do
        let(:params) { {hotel_ids: ['h1', 'h2']} }

        it "should be success and return 2 hotels" do
          subject
          body = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          expect(body.length).to eq(2)
          expect(body[0]["id"]).to eq('h1')
          expect(body[1]["id"]).to eq('h2')
        end
      end
    end

    context 'when have both param hotel_ids and destination_id' do
      context 'when matched destination_id but not matched hotel_ids' do
        let(:params) { {destination_id: 10, hotel_ids: ['h5']} }

        it "should be success and return 0 hotels" do
          subject
          body = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          expect(body.length).to eq(0)
        end
      end

      context 'when matched destination_id and matched 1 hotel_ids' do
        let(:params) { {destination_id: 10, hotel_ids: ['h1', 'h5']} }

        it "should be success and return 1 hotels" do
          subject
          body = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          expect(body.length).to eq(1)
        end
      end

      context 'when matched destination_id and matched 2 hotel_ids' do
        let(:params) { {destination_id: 10, hotel_ids: ['h1', 'h2', 'h5']} }

        it "should be success and return 2 hotels" do
          subject
          body = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          expect(body.length).to eq(2)
        end
      end
    end
  end
end
