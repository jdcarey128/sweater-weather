class ImageSerializer
  include FastJsonapi::ObjectSerializer
  set_type :image 
  attribute :image do |obj|
    {
      location: obj.image.location,
      image_url: obj.image.image_url
    }
  end
  attribute :credit do |obj|
    {
      source: obj.image.source,
      author: obj.image.author,
      author_url: obj.image.author_url
    }
  end
end
