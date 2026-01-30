class UsersController < ApplicationController
  before_action :authenticate_user!
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to edit_profile_path, notice: "Profile has been updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by(id: params[:id])
  rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "User not found"
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender, :birth_date, :avatar)
  end
end
