module Api 
  module V1 
    class UsersController < ApplicationController 
      before_action :check_params 
      
      def create 
        user = User.create(user_params)
        return render_error(user.errors.full_messages.to_sentence) unless user.id
        render json: UserSerializer.new(user), status: 201
      end

      private 

      def user_params 
        params.permit(:email, :password, :password_confirmation)
      end

      def check_params
        errors = []
        errors << 'Email' if params[:email].nil? 
        errors << 'Password' if params[:password].nil? 
        errors << 'Password Confirmation' if params[:password_confirmation].nil?
        render_error("Missing #{errors.join(', ')} in request body") unless errors.empty? 
      end

      def render_error(message)
        render json: {:error => 400, :message => message}, 
                      status: 400
      end
    end
  end
end
