# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  has_many :outgoing_mentions, dependent: :destroy
  has_many :mentioning_reports, through: :outgoing_mentions, source: :mentioned_report
  has_many :reverse_of_mentions, class_name: 'Mention', foreign_key: 'mentioned_report_id', dependent: :destroy,
                                 inverse_of: 'mentioned_report'
  has_many :mentioned_reports, through: :reverse_of_mentions, source: :report
  after_save :create_mention

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def create_mention
    Report.transaction do
      outgoing_mentions.destroy_all
      ids = content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.uniq
      mentioned_report_ids = Report.where(id: ids).where.not(id:).pluck(:id)
      mentioned_report_ids.each do |id|
        outgoing_mentions.create!(mentioned_report_id: id)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("メンションの作成に失敗しました: #{e.message}")
  end
end
