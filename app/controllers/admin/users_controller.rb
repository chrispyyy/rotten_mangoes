class Admin::UsersController < ApplicationController
  before_filter :require_admin

  def index
    @users = User.order(:firstname).page(params[:page]).per(1)
  end

end
