require 'spec_helper'

describe "Memos" do
  describe "GET /memos/hoge.json" do
    let(:path) { '/memos/hoge.json' }
    let(:postpath) { '/write/hoge.json' }

    before do
      @params = { :memo => { :id => 'hoge',
          :val => 'hogehoge' }}
    end

    it 'returns 200' do
      get path
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'returns key list' do
      post postpath, @params
      get path

      expect(json.length).to eq(1)
    end
  end

  describe "GET /memo/hoge/0001.json" do
    let(:path) { '/memos/hoge.json' }
    let(:postpath) { '/write/hoge.json' }

    before do
      @params = { :memo => { :id => 'hoge',
          :val => 'hogehoge' }}
    end

    it 'returns 200' do
      post postpath, @params
      get path

      $dpath = '/memo/'
      $dpath << @params[:memo][:id]
      $dpath << '/'
      $dpath << json[0].split(':')[2]
      $dpath << '.json'

      get $dpath

      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'returns post data' do
      post postpath, @params
      get path

      $dpath = '/memo/'
      $dpath << @params[:memo][:id]
      $dpath << '/'
      $dpath << json[0].split(':')[2]
      $dpath << '.json'

      get $dpath
      json = JSON.parse(response.body)

      expect(json['data']).to eq('hogehoge')
    end
  end

  describe "POST /write/hoge.json" do
    let(:postpath) { '/write/hoge.json' }

    before do
      @params = { :memo => { :id => 'hoge',
          :val => 'hogehoge' }}
    end

    it 'returns 200' do
      post postpath, @params
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'adds record' do
      post postpath, @params
      get '/memos/hoge'
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
    end
  end

  describe "UPDATE /memo/hoge/0001.json" do
    let(:path) { '/memos/hoge.json' }
    let(:postpath) { '/write/hoge.json' }

    before do
      @params = { :memo => { :id => 'hoge',
          :val => 'hogehoge' }}

      post postpath, @params

      get path
      json = JSON.parse(response.body)
    end

    it 'returns 200' do
      $dpath = '/memo/hoge/'
      $dpath << json[0].split(':')[2]
      $dpath << '.json'

      put $dpath, { 'val' => 'fugafuga' }

      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'updates record' do
      $dpath = '/memo/hoge/'
      $dpath << json[0].split(':')[2]
      $dpath << '.json'

      put $dpath, { 'val' => 'fugafuga' }
      get $dpath

      json = JSON.parse(response.body)

      expect(json['data']).to eq('fugafuga')
    end
  end

  describe "DELETE /memo/hoge/0001.json" do
    let(:path) { '/memos/hoge.json' }
    let(:postpath) { '/write/hoge.json' }

    before do
      @params = { :memo => { :id => 'hoge',
          :val => 'hogehoge' }}

      post postpath, @params

      get path
      json = JSON.parse(response.body)
    end

    it 'returns 200' do
      $dpath = '/memo/hoge/'
      $dpath << json[0].split(':')[2]
      $dpath << '.json'

      delete $dpath

      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'deletes record' do
      $dpath = '/memo/hoge/'
      $dpath << json[0].split(':')[2]
      $dpath << '.json'

      delete $dpath
      get $dpath

      json = JSON.parse(response.body)

      expect(json[:data]).to eq(nil)
    end
  end
end
