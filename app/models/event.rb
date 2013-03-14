class Event < ActiveRecord::Base
  attr_accessible :date, :description, :location, :name, :link, :venue
  
  has_and_belongs_to_many :users
  
  scope :approved, where(:approved => true)
  
  validates_presence_of :date
  validates_presence_of :location
  validates_presence_of :name
  
  before_save :generate_slug
  
  def generate_slug
    self.slug = "#{name.parameterize}-#{date.year}-#{date.month}-#{date.day}"
  end
  
  def is_current
    self.date > Time.now
  end
end
