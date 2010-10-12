class Post < Content
  has_slug :scope => :section_id

  validates_presence_of :title

  class << self
    def by_permalink(year, month, day, slug)
      by_archive(year, month, day).where(:slug => slug)
    end

    def by_archive(*args)
      where("DATE(contents.created_at) = ?", Date.new(*args.map(&:to_i)).to_formatted_s(:db))
    end
  end

  # FIXME should be in adva-markup, shouldn't it?
  def filter
    read_attribute(:filter) || (section.respond_to?(:default_filter) ? section.default_filter : nil)
  end

  def permalink
    "#{created_at.year}/#{created_at.month}/#{created_at.day}/#{slug}"
  end

  def to_param(name)
    name == :permalink ? permalink : super()
  end
end
