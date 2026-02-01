module Api
  module V1
    class UsersController < BaseController
      skip_before_action :authenticate_request, only: [:create]

      def create
        user = User.new(user_params)

        if user.save
          token = Auth::TokenService.encode(user_id: user.id)

          render json: {
            token: token,
            user: { id: user.id, email: user.email }
          }, status: :created
        else
          render_validation_errors(user.errors.full_messages)
        end
      end

      def show
        render json: { user: { id: current_user.id, email: current_user.email } }
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
