CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                                       # required
    :aws_access_key_id      => ENV['AWS_ID'],                               # required
    :aws_secret_access_key  => ENV['AWS_SECRET']                            # required
    # :region                 => 'us-west-1'  # optional, defaults to 'us-east-1'
  }                                                                       
    
  config.fog_directory    = ENV['AWS_FOLDER']                               # required
  # config.fog_host       = 'https://assets.example.com'                    # optional, defaults to nil
  # config.fog_public     = false                                           # optional, defaults to true
end