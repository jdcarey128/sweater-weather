module Api 
  module V1 
    class SessionsController < ApplicationController
      before_action :check_params 

      def create 
        user = User.find_by(email: params[:email])
        return render_error unless user 
        if user.authenticate(params[:password])
          render json: UserSerializer.new(user)
        else 
          render_error
        end
      end
      
      
      private 
      
      def check_params 

        if params[:email].nil? && params[:password].nil?
          return render_error('Missing Email and Password in request body')
        elsif params[:email].nil?
          return render_error('Missing Email in request body')
        elsif params[:password].nil?
          return render_error('Missing Password in request body')
        elsif params[:email].empty? && params[:password].empty?
          return render_error('Email and Password can\'t be blank')
        elsif params[:email].empty?
          return render_error('Email can\'t be blank')
        elsif params[:password].empty?
          return render_error('Password can\'t be blank')
        end
      end

      def render_error(message = 'The email password combination is invalid')
        render json: {:error => 400, :message => message},
                      status: 400
      end
    end
  end
end
