class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_logged_out, only: [:new, :create]

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:'alert-success'] = "Your account information was updated successfully"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:'alert-success'] = "Welcome to the Alpha Blog #{@user.username}, you have successfully signed up!"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  # def destroy # Old destroy breaks the webpage. Took 4 hours to fix. Never remove this code so you can always remember not to make this mistake again. @user.destroy causes current_user to become nil so session is unable to become nil because of comparison between nil and old existing user, so everything breaks after that. Duplicating the variable with .dup to another variable doesn't work either because user_id doesn't get duplicated since it is created by Ruby for each User and can only increment. This is evil. Never uncomment this.
  #   @user.destroy
  #   session[:user_id] = nil if @user == current_user # IMPORTANT if a user is deleted and the session ID is not cleared, the session will be trying to load with an invalid user, which will cause the webpage to have errors and be unable to load without back-end tinkering.
  #   flash[:'alert-success'] = "Account and all associated articles successfully deleted"
  #   #redirect_to(logged_in? && current_user.admin? ? users_path : root_path)
  #   redirect_to articles_path
  # end
  def destroy
    if @user == current_user
      session[:user_id] = nil
    end
    @user.destroy
    flash[:'alert-success'] = "Account and all associated articles successfully deleted"
    if !current_user.nil?
      redirect_to users_path 
    else
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:'alert-danger'] = "You can only edit or delete your own account"
      redirect_to @user
    end
  end

  def require_logged_out
    if logged_in?
      flash[:'alert-danger'] = "You are already logged in as #{current_user.username}"
      redirect_to user_path(current_user)
    end
  end

end