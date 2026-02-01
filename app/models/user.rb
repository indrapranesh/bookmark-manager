class User < ApplicationRecord
  has_secure_password
  has_many :bookmarks, dependent: :destroy

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save :normalize_email

  private

  def normalize_email
    self.email = email.downcase.strip
  end
end
