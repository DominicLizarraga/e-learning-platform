class Enrollment < ApplicationRecord

  belongs_to :course, counter_cache: true
  belongs_to :user, counter_cache: true
  # User.find_each { |user| User.reset_counters(user.id, :enrollments) }
  validates :user, :course, presence: true
  validates_uniqueness_of :user_id, scope: :user_id
  validates_uniqueness_of :course_id, scope: :course_id

  validate :cant_suscribe_to_own_course

  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  def to_s
    user.to_s + " " + course.to_s
  end

  scope :pending_review, -> { where(rating: [0, nil, ""], review: [0, nil, ""]) }
  scope :reviewed, -> { where.not(review: [0, nil, ""]) }


  after_save do
    unless rating.nil? || rating.zero?
      course.update_rating
    end
  end

  after_destroy do
    course.update_rating
  end


  protected

  def cant_suscribe_to_own_course
    if self.new_record?
      if self.user_id.present?
        if user_id == course.user_id
          errors.add(:base, "You cannot cant suscribe to own course")
        end
      end
    end
  end

end
