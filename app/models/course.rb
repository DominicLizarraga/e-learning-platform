class Course < ApplicationRecord
  validates :title, :short_description, :language, :price, :level,  presence: true
  validates :description, presence: true
  def to_s
    title
  end

  has_rich_text :description
  belongs_to :user, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  validates :title, uniqueness: true
  has_many :user_lessons, through: :lessons
  # User.find_each { |user| User.reset_counters(user.id, :courses) }

  scope :latest, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }


  extend FriendlyId
  friendly_id :title, use: :slugged

  LANGUAGES = [:"English", :"Russian", :"Polish", :"Spanish"]
  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  LEVELS = [:"Beginner", :"Intermediate", :"Advanced"]
  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0)
    end

  end

  def progress(user)
    unless self.lessons_count == 0
      user_lessons.where(user: user).count/self.lessons_count.to_f*100
    end
  end


  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
  end

end
