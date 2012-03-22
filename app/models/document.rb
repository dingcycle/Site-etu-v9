class Document < ActiveRecord::Base
  attr_accessible :asset, :documentable_id, :documentable_type
  validates_attachment_presence :asset

  has_paper_trail
  has_attached_file :asset

  belongs_to :documentable, :polymorphic => true

  # Est-ce une image ?
  def image?
    !(asset_file_name =~ /\.(png|jpg|jpeg|gif)$/).nil?
  end
end
