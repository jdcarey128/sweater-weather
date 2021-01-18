require 'rails_helper' 

RSpec.describe Api::V1::BackgroundImageFacade do 
  describe 'with valid location entry' do 
    it 'returns an image object' do 
      location = 'chicago,il' 
      json = File.read('spec/fixtures/get_image.json')
      image_data = JSON.parse(json, symbolize_names: true)

      allow(Api::V1::BackgroundImageService).to receive(:get_image).with(location).and_return(image_data)

      result = Api::V1::BackgroundImageFacade.get_image(location)
      
      expect(result).to be_a(Api::V1::Image)
      expect(result.image_url).to be_a(String)
      expect(result.author).to be_a(String)
      expect(result.source).to be_a(String)
      expect(result.author_url).to be_a(String)
    end
  end

  describe 'error handling' do 
    it 'returns an error message with invalid entry' do 
      location = '' 
      image_data = {:error => 400, 
                    :message => "No results found for \'#{location}\'"}

      allow(Api::V1::BackgroundImageService).to receive(:get_image).with(location).and_return(image_data)

      result = Api::V1::BackgroundImageFacade.get_image(location)

      expect(result).to be_a(Hash)
      expect(result[:error]).to eq(400)
      expect(result[:message]).to eq("No results found for \'#{location}\'")
    end
  end
end
