class Course < ActiveRecord::Base
  validates_presence_of :name

  has_paper_trail
  acts_as_taggable

  belongs_to :owner, :class_name => 'User'
  has_many :annals, :dependent => :destroy
  has_many :timesheets, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy

  def users
    timesheets.map { |t| t.users }.flatten.uniq
  end
end
