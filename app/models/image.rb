class Image < ActiveRecord::Base
  attr_accessible :file, :file_cache
  
  has_one :user
  
  mount_uploader :file, ImageAssetUploader
end
