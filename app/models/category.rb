class Category < ActiveRecord::Base
  validates :name, presence: true
  validates :slug, uniqueness: true, presence: true
  validates :ordinal, numericality: {only_integer: true, greater_than_or_equal_to: 1}

  before_validation :generate_slug

  has_many :articles

  scope :ordered, -> { order(:ordinal) }

  def to_param
    slug
  end

  def generate_slug
    self.slug ||= name.parameterize
  end
end
