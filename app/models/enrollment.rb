class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, :course, presence: true
  validates_uniqueness_of :user_id, scope: :user_id
  validates_uniqueness_of :course_id, scope: :course_id

  validate :cant_suscribe_to_own_course
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
