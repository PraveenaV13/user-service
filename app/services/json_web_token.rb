require 'jwt'

class JsonWebToken
	SECRET_KEY = Rails.application.secret_key_base

	# Encode JWT token with expiration
	def self.encode(payload, exp = 24.hours.from_now)
		payload[:exp] = exp.to_i
		JWT.encode(payload, SECRET_KEY, 'HS256')
	end

	# Decode JWT token
	def self.decode(token)
		decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
		HashWithIndifferentAccess.new(decoded[0])
	rescue
		nil
	end
end