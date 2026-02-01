module Auth
  class TokenService
    SECRET_KEY = Rails.application.credentials.secret_key_base
    EXPIRATION_TIME = 24.hours

    def self.encode(payload)
      payload[:exp] = EXPIRATION_TIME.from_now.to_i
      JWT.encode(payload, SECRET_KEY, 'HS256')
    end

    def self.decode(token)
      decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
      decoded.first
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end
  end
end
