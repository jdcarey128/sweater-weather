require 'rails_helper' 

RSpec.describe Api::V1::Restaurant do 
  it 'exists and has attributes' do 
    json = File.read('spec/fixtures/get_restaurant_info.json')
    restaurant_info = JSON.parse(json, symbolize_names: true)
    result = Api::V1::Restaurant.new(restaurant_info)

    expect(result).to be_a(Api::V1::Restaurant)
    expect(result.name).to eq('Snarfburger')
    expect(result.address).to eq("2000 Arapahoe Ave","Boulder, CO 80302")
  end
end
