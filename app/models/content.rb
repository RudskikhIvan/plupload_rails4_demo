class Content < ActiveRecord::Base

  mount_uploader :file, FileUploader

  before_create :prepare_tags

  validates :title, :file, :presence => true

  scope :by_tag, ->(tag){ where("tags LIKE '% #{tag.downcase} %'") }

  default_scope { order(:id => 'desc') }

  def prepare_tags
    self.tags=" #{tags.gsub(/\s+/, ' ').downcase} " if tags.present?
  end

end
