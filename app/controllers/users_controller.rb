class UsersController < ApplicationController
  before_action :set_user,             only: [:show, :edit, :update, :destroy]
  before_action :require_current_user, only: [:edit, :update]
  before_action :require_user_or_admin, only: :destroy

  def index
    @users = User.all
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)    
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        flash[:success] = 'Welcome to A Popcorn Culture!'
        format.html { redirect_to @user }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = 'Your account has been updated successfully.'
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    bouncer = @user.id
    @user.destroy
    respond_to do |format|
      session[:user_id] = nil if bouncer == session[:user_id]
      flash[:danger] = 'User and all articles by user have been deleted.'
      format.html { redirect_to users_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def require_current_user
      if current_user != @user && current_user.admin?
        flash[:danger] = "Access dinied. I think we both know why."
        redirect_to root_path
      end
      
    end

    def require_user_or_admin
      if logged_in? and !current_user.admin? && !current_user != @user
        flash[:danger] = "Only admin users can perform that action."
        redirect_to root_path
      end
    end
end
