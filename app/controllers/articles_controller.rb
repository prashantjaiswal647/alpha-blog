class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy] # set_article private method, below, is used before these actions are executed. This follows DRY principles. Don't Repeat Yourself
  before_action :require_user, except: [:show, :index] # require_user from application_controller
  before_action :require_same_user, only: [:edit, :update, :destroy] # IMPORTANT this must be below require_user since this uses current_user, which doesn't work if there is no user logged in (which is what require_user checks for)

  def show
  end

  def index
    # @articles = Article.all
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params) # This makes an article by requiring the inputs with params, but only permitting :title and :description hash keys to come through, as a security feature (SEE article_params METHOD BELOW, DRY principle was applied later!). It used to be params[:article]
    @article.user = current_user
    # render plain: @article.inspect # To see the creation for testing purposes
    if @article.save
      flash[:'alert-success'] = "Article was created successfully" # There are two types of flash, notice and alert. Alert is usually for when something goes wrong. This is to show that the article was successfully created.
      redirect_to @article # Below is longhand, this is shorthand since this is so commonly used.
      # redirect_to article_path(@article) # use rails routes --expanded in console, go up to the show action, then see that the prefix is 'article', meaning article_path, and that it needs the ID, so we give @article which Rails knows to get the ID of the article given, then to redirect_to it and show that view.
    else
      render 'new'
    end
  end

  def update
    if @article.update(article_params)
      flash[:'alert-success'] = "Article was updated successfully"
      redirect_to @article # Send to the article
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    flash[:'alert-success'] = "Article was deleted successfully"
    redirect_to articles_path # Send to the 'index' table of Articles
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  def require_same_user
    if current_user != @article.user && !current_user.admin?
      flash[:'alert-danger'] = "You can only edit or delete your own articles"
      redirect_to @article
    end
  end

end