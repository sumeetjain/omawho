class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_login
  before_filter :categories_with_users
  before_filter :set_randomization_seed
  before_filter :application_configuration
  
  # Change these settings to customize Omawho for your locale.
  def application_configuration
    # MOST IMPORTANT SETTING EVER, RIGHT?
    @site_title = "Omawho"
    
    # What location do you serve?
    @site_location = "Omaha, Nebraska"
    
    # Optional - Your Twitter handle.
    @site_twitter = "omawho_ne"
    
    # This is the URL shared by the Facebook "Like" button.
    @site_url = "http://omawho.com"
  end
  
  def categories_with_users
    active_categories = User.uniq.pluck(:category)
    @all_active_categories = User::CATEGORIES.select {|k,v| active_categories.include?(k)}
  end
  
  def set_randomization_seed
    # If random seed is not set, set it.
    if cookies[:random_seed].nil?
      cookies[:random_seed] = {:value => rand, :expires => 1.hour.from_now }
    end
  end
  
protected

  def not_authenticated
    redirect_to root_path, :alert => "Please login first."
  end
end
