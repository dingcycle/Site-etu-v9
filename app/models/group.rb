class Group < ActiveRecord::Base
  attr_accessible :name, :parent_id
  validates_presence_of :name

  has_paper_trail
  acts_as_nested_set :dependent => :destroy

  has_many :groups_user, :dependent => :destroy
  has_many :users, :through => :groups_user, :uniq => true
end
