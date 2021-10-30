class Lesson < ApplicationRecord
  belongs_to :course
  validates :title, :context, :course, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

end
