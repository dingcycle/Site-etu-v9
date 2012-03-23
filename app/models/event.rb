class Event < ActiveRecord::Base
  paginates_per 20

  attr_accessible :name, :description, :location, :start_at, :end_at, :owner_id
  validates_presence_of :name

  default_scope :order => 'start_at DESC'
  has_paper_trail

  belongs_to :owner, :class_name => 'User'

  has_many :news, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  has_many :events_user, :dependent => :destroy
  has_many :users, :through => :events_user, :uniq => true

  has_many :assos_event, :dependent => :destroy
  has_many :assos, :through => :assos_event, :uniq => true

  # Enlève les participations des utilisateurs à l'événement supprimé
  before_destroy do self.users.delete_all end

  # Traduit l'événement en un hash exploitable par FullCalendar
  def to_fullcalendar
    return { 'title' => name,
             'start_at' => start_at,
             'end_at' => end_at,
             'object' => self,
             'alt' => name }
  end

  def self.make_agenda
    Event.all.map(&:to_fullcalendar)
  end

  # Les images d'un événement sont les documents qui ont un format d'image
  def images
    documents.select(&:image?)
  end
end
