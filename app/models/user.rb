class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :username, :email, :password, :password_confirmation, :name, :twitter, :website, :bio, :image_id, :category, :facebook, :pinterest, :linkedin, :github, :googleplus, :dribbble, :company
  
  CATEGORIES = {"web_software" => "Web & Software", "graphic_design" => "Graphic Design", "architecture_interior_design" => "Architecture & Interior Design", "photography" => "Photography", "music_film_art" => "Music/Film/Art", "fashion" => "Fashion", "writing" => "Writing", "vc" => "Venture Capital", "community" => "Community Connector", "non_profit" => "Non-Profit"}
  
  scope :random, order("RANDOM()")

  validates_presence_of :username
  validates_presence_of :category
  validates_presence_of :email
  validates_presence_of :name
  validates :email, :format => { :with => /@/ }
  validates :username, :format => { :with => /^(\w|-)*$/, :message => "can only contain letters, numbers, underscores, and dashes" }
  validates :website, :format => { :with => /^http/ }, :allow_blank => true
  validates_exclusion_of :username, :in => %w(category login logout add profile quiz beta)
  validates_inclusion_of :category, :in => CATEGORIES.map{|k,v| k}
  validates_uniqueness_of :username
  validates_uniqueness_of :email
  validates_length_of :bio, :within => 0..140
  validates_length_of :password, :within => 4..99, :allow_blank => :allow_blank_password
  
  belongs_to :image  
  
  has_and_belongs_to_many :events
  
  def allow_blank_password
    !new_record?
  end
  
  def linkedin_url
    format_social_link(linkedin, "linkedin.com", "http://linkedin.com/in/$USERNAME")
  end
  
  def facebook_url
    format_social_link(facebook, "facebook.com", "http://facebook.com/$USERNAME")
  end
  
  def twitter_url
    format_social_link(twitter.gsub(/^@/, ""), "twitter.com", "http://twitter.com/$USERNAME")
  end
  
  def dribbble_url
    format_social_link(dribbble, "dribbble.com", "http://dribbble.com/$USERNAME")
  end
  
  def github_url
    format_social_link(github, "github.com", "http://github.com/$USERNAME")
  end
  
  def pinterest_url
    format_social_link(pinterest, "pinterest.com", "http://pinterest.com/$USERNAME")
  end
  
protected
  def format_social_link(input, domain, example)
    # If "domain" is present, they probably added the whole URL.
    if input =~ /#{domain}/
      
      # If it starts with a valid protocol, use the link as is.
      if input =~ /^https?:\/\//
        input
        
      # If just the protocol is absent, add it.
      elsif input =~ /^((www\.)|(#{domain}))/
        "http://#{input}"
        
      # Otherwise I don't know what the fuck is going on.
      else
        input
      end
      
    # Sane people just used their username.
    else
      "#{example.gsub("$USERNAME", input)}"
    end
  end
end
