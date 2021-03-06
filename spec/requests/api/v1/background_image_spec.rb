require 'rails_helper' 

RSpec.describe 'Background Image' do 
  # See rails helper for defined_headers and parse_json 

  describe 'with a valid location entry' do 
    before :each do
      json = File.read('spec/fixtures/get_image.json')
      @image_data = JSON.parse(json, symbolize_names: true)
      @location = 'denver,co'

      allow(Api::V1::BackgroundImageService).to receive(:get_image).with(@location).and_return(@image_data)

      get "/api/v1/backgrounds?location=#{@location}", headers: defined_headers

      expect(response.status).to eq 200
      @response = JSON.parse(response.body)
      @response = @response['data']
    end

    it 'returns 3 root attributes' do 
      expect(@response['id']).to eq(nil)
      expect(@response['type']).to eq('image')
      expect(@response['attributes']).to be_a(Hash)
    end

    it 'returns an image attributes for the location' do 
      image = @response['attributes']['image']
      credits = @response['attributes']['credit']

      expect(image).to be_a(Hash)
      expect(image).to have_key('location')
      expect(image['location']).to eq(@location)
      expect(image).to have_key('image_url')
      expect(image['image_url']).to include('https://images.unsplash.com')

      expect(credits).to be_a(Hash)
      expect(credits['source']).to eq('https://unsplash.com')
      expect(credits['author']).to eq('Dylan LaPierre')
      expect(credits['author_url']).to include('https://unsplash.com/')
    end
  end

  describe 'with an invalid location entry' do 
    it 'returns an error message' do 
      @location = ''
      error = {:error => 400, 
               :message => "No results found for \'#{@location}\'"}

      allow(Api::V1::BackgroundImageFacade).to receive(:get_image).with(@location).and_return(error)

      get "/api/v1/backgrounds?location=#{@location}", headers: defined_headers

      response_body = parse_json

      expect(response.status).to eq 400
      expect(response_body[:error]).to eq(400)
      expect(response_body[:message]).to eq("No results found for \'#{@location}\'")
    end
  end
end
