# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  validates :text, presence: true
  scope :with_active_users, -> { joins(:user).where.not(users: { id: nil }) }
end
