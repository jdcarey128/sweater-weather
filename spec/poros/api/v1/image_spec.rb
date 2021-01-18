require 'rails_helper'

RSpec.describe Api::V1::Image do 
  it 'exists and has attributes' do 
    json = File.read('spec/fixtures/get_image.json')
    image_data = JSON.parse(json, symbolize_names: true)

    image = Api::V1::Image.new(image_data)

    expect(image).to be_a(Api::V1::Image)
    expect(image.image_url).to eq("https://images.unsplash.com/photo-1602276119625-89aa4061cc35?ixid=MXwxOTkzNTd8MHwxfHNlYXJjaHwxfHxjaGljYWdvLGlsfGVufDB8fHw&ixlib=rb-1.2.1")
    expect(image.author).to eq("Dylan LaPierre")
    expect(image.author_url).to eq('https://unsplash.com/@drench777')
    expect(image.source).to eq('https://unsplash.com')
  end
end
