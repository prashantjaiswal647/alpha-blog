class CategoriesController < ApplicationController
    before_action :set_category, only: [:show, :edit, :update, :destroy]
    before_action :require_admin, except: [:index, :show]
  
    def new
      @category = Category.new
    end
  
    def create
      @category = Category.new(category_params)
      if @category.save
        flash[:'alert-success'] = "Category was successfully created"
        redirect_to @category
      else
        render 'new'
      end
    end
  
    def destroy
      @category.destroy
      flash[:'alert-success'] = "Category was deleted successfully"
      redirect_to categories_path
    end
  
    def edit
    end
  
    def update
      if @category.update(category_params)
        flash[:'alert-success'] = "Category name was updated successfully"
        redirect_to @category
      else
        render 'edit'
      end
    end
  
    def index
      @categories = Category.paginate(page: params[:page], per_page: 5)
    end
  
    def show
      @articles = @category.articles.paginate(page: params[:page], per_page: 5)
    end
  
    private
  
    def category_params
      params.require(:category).permit(:name)
    end
  
    def require_admin
      if !(logged_in? && current_user.admin?)
        flash[:'alert-danger'] = "Only admins can perform that action"
        redirect_to categories_path
      end
    end
  
    def set_category
      @category = Category.find(params[:id])
    end
  
  end