class User < ApplicationRecord
  # BCrypt authentication
  has_secure_password

  # Validations (application-level, before DB constraints)
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  # Normalize email to lowercase before save
  before_save :normalize_email

  private

  def normalize_email
    self.email = email.downcase.strip
  end
end
