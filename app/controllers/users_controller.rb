class UsersController < ApplicationController
  before_action :authorize, only: :show
  rescue_from ActiveRecord::RecordInvalid, with: :validation_failed

  def create
    user = User.create!(user_params)
    session[:user_id] = user.id
    if user.valid?
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find(session[:user_id])
    render json: user, status: :created
  end


  private
  def validation_failed(exception)
    render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
    
  end
  def authorize
    render json: {error: "Not authorized"}, status: :unauthorized unless session.include? :user_id
  end
  def user_params
    params.permit(:username, :password, :password_confirmation, :image_url, :bio)
  end
end
