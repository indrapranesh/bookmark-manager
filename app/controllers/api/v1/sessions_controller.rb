module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate_request, only: [:create]

      def create
        user = User.find_by(email: login_params[:email]&.downcase)

        if user&.authenticate(login_params[:password])
          token = Auth::TokenService.encode(user_id: user.id)

          render json: {
            token: token,
            user: { id: user.id, email: user.email }
          }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def destroy
        render json: { message: 'Logged out successfully' }, status: :ok
      end

      private

      def login_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
