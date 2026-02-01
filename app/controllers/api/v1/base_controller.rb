module Api
  module V1
    class BaseController < ApplicationController
      attr_reader :current_user
      before_action :authenticate_request

      private

      def authenticate_request
        token = extract_token_from_header
        return render_unauthorized('Token missing') unless token

        payload = Auth::TokenService.decode(token)
        return render_unauthorized('Invalid or expired token') unless payload

        @current_user = User.find_by(id: payload['user_id'])
        return render_unauthorized('User not found') unless @current_user
      end

      def extract_token_from_header
        auth_header = request.headers['Authorization']
        return nil unless auth_header
        auth_header.split(' ').last
      end

      def render_unauthorized(message = 'Unauthorized')
        render json: { error: message }, status: :unauthorized
      end

      def render_validation_errors(errors)
        render json: { errors: errors }, status: :unprocessable_entity
      end
    end
  end
end
