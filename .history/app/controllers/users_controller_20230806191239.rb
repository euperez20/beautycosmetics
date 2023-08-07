class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update]

  
  def show
    # @user ya está asignado por el before_action
  end

  def edit
    # @user ya está asignado por el before_action
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    # Verificar si la acción es la de logout, en cuyo caso no asignar @user
    return if params[:action] == "destroy" && params[:controller] == "devise/sessions"

    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :address,:province_id)
  end
end
