class Event < ActiveRecord::Base
  belongs_to :organizers, class_name: "User"

  has_many :taggings
  has_many :tags, through: :taggings

  def self.tagged_with(name)
    Tag.find_by_name!(name).events
  end

  def self.tag_counts
    Tag.select("tags.name, count(taggings.tag_id) as count").
    joins(:taggings).group("taggings.tag_id")
  end

  def all_tags
    tags.map(&:name).join(", ")
  end

  def all_tags=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

end
