require 'rails_helper' 

RSpec.describe Api::V1::BackgroundImageService do 
  describe 'with valid location entry' do 
    it 'returns an author\'s image', :vcr do 
      location = 'chicago,il'
      result = Api::V1::BackgroundImageService.get_image(location)

      expect(result).to have_key(:results)
      expect(result[:results]).to be_a(Array)

      result = result[:results][0]
      urls = result[:urls]
      user = result[:user]

      expect(result).to have_key(:id)
      expect(result).to have_key(:description)
      expect(result).to have_key(:urls)
      expect(urls).to be_a(Hash)
      expect(urls).to have_key(:raw)
      expect(urls[:raw]).to include('https://images.unsplash.com')
      expect(result).to have_key(:links)
      expect(result).to have_key(:categories)
      expect(result).to have_key(:user)
      expect(user).to be_a(Hash)
      expect(user).to have_key(:name)
      expect(user[:name]).to be_a(String)
      expect(user).to have_key(:links)
      expect(user[:links]).to be_a(Hash)
      expect(user[:links][:html]).to include('https://unsplash.com')
    end
  end
end
