class Event < ActiveRecord::Base
  paginates_per 20

  validates_presence_of :title
  validates_associated :organizer

  has_paper_trail
  acts_as_taggable

  belongs_to :organizer, :class_name => 'User'
  has_many :news, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_and_belongs_to_many :users, :uniq => true
  has_and_belongs_to_many :associations, :uniq => true

  # Enlève les participations des utilisateurs à l'événement supprimé
  before_destroy do self.users.delete_all end
end
