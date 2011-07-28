class Post < Content
  has_slug :scope => :section_id

  before_validation { |r| r.published_at = Time.now.to_datetime unless r.published_at }

  validates_presence_of :title

  class << self
    def by_permalink(year, month, day, slug)
      by_archive(year, month, day).where(:slug => slug)
    end

    def by_archive(*args)
      where("DATE(contents.published_at) = ?", Date.new(*args.map(&:to_i)).to_formatted_s(:db))
    end
  end

  def previous
    section.posts.order(:published_at).where(Post.arel_table[:published_at].lt(published_at)).first
  end

  def next
    section.posts.order(:published_at).where(Post.arel_table[:published_at].gt(published_at)).last
  end

  def permalink
    "#{published_at.year}/#{published_at.month}/#{published_at.day}/#{slug}"
  end

  def to_param(name=nil)
    name == :permalink ? permalink : super()
  end
end
