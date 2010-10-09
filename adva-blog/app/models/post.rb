class Post < Content
  has_slug :scope => :section_id

  validates_presence_of :title

  belongs_to :site
  belongs_to :section

  class << self
    def by_permalink(year, month, day, slug)
      by_archive(year, month, day).where(:slug => slug)
    end

    def by_archive(*args)
      where("DATE(contents.created_at) = ?", Date.new(*args.map(&:to_i)).to_formatted_s(:db))
    end
  end

  def filter
    read_attribute(:filter) || section.try(:default_filter)
  end

  def permalink
    "#{created_at.year}/#{created_at.month}/#{created_at.day}/#{slug}"
  end

  def to_param(name)
    name == :permalink ? permalink : super()
  end
end
