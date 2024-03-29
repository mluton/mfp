class Article < ActiveRecord::Base
  validates :title, presence: true
  validates :short_title, presence: true, length: {maximum: 50}
  validates :slug, uniqueness: true, presence: true
  validates :description, presence: true, length: {minimum: 10, maximum: 500} # Roughy between 3 and 75 words
  validates :body, presence: true
  validates :ordinal, numericality: {only_integer: true, greater_than_or_equal_to: 1}

  before_validation :generate_slug
  after_update :clear_cache

  belongs_to :category, touch: true

  def previous
    Article.where('ordinal < ? and category_id = ?', self.ordinal, self.category_id).order(:ordinal).last
  end

  def next
    Article.where('ordinal > ? and category_id = ?', self.ordinal, self.category_id).order(:ordinal).first
  end

  def to_param
    slug
  end

  def generate_slug
    self.slug ||= title.parameterize
  end

  def clear_cache
    Luton::Cache.delete("article_with_id_#{self.slug}")
    Luton::Cache.delete("category_for_article_id_#{self.slug}")
  end
end
