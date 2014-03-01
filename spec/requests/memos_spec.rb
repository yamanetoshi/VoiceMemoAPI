require 'spec_helper'

describe "Memos" do
  describe "GET /memos/hoge.json" do
    let(:path) { '/memos/hoge.json' }

    it 'returns 200' do
      get path
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
end
