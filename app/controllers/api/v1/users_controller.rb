module Api 
  module V1 
    class UsersController < ApplicationController 
      
      def create 
        user = User.create(user_params)
        return render_error(user.errors.full_messages.to_sentence) unless user.id
        render json: UserSerializer.new(user), status: 201
      end

      private 

      def user_params 
        params.permit(:email, :password, :password_confirmation)
      end

      def render_error(message)
        render json: {:error => 400, :message => message}, 
                      status: 400
      end
    end
  end
end
