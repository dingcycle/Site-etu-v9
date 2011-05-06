class Event < ActiveRecord::Base
  belongs_to :organizer, :class_name => 'User'
  has_and_belongs_to_many :users

  has_many :comments, :as => :commentable
end
