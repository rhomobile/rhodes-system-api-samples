class Image
  include Rhom::PropertyBag

  enable :sync
    
  property :image_uri, :blob
end
