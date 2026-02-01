class Bookmark < ApplicationRecord
  belongs_to :user

  validates :url, presence: true,
                  uniqueness: { scope: :user_id, message: "already bookmarked" }
  validates :metadata_status, inclusion: { in: %w[pending fetched failed] }

  before_validation :normalize_url, if: :url_changed?

  scope :recent, -> { order(created_at: :desc) }
  scope :with_metadata, -> { where(metadata_status: 'fetched') }
  scope :pending_metadata, -> { where(metadata_status: 'pending') }

  def metadata_pending?
    metadata_status == 'pending'
  end

  def metadata_fetched?
    metadata_status == 'fetched'
  end

  def metadata_failed?
    metadata_status == 'failed'
  end

  private

  def normalize_url
    return if url.blank?

    self.url = url.strip
    self.url = "https://#{url}" unless url.match?(/\Ahttps?:\/\//)
  end
end
