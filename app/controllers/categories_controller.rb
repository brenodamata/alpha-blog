class CategoriesController < ApplicationController
	before_action :require_admin, except: [:index, :show]
	before_action :get_category, only: [:show, :edit, :update]

	def index
		@categories = Category.paginate(page: params[:page], per_page: 5)
	end

	def show
		@category_articles = @category.articles.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
	end

	def new
    @category = Category.new
	end

	def create
		@category = Category.new(category_params)
		if @category.save
			flash[:success] = "New '#{@category.name}' category created."
			redirect_to categories_path
		else
			render 'new'
		end
	end

	def edit

	end

	def update
		if @category.update(category_params)
			flash[:success] = "Category name was successfully updated"
			redirect_to category_path(@category)
		else
			render 'edit'
		end
	end

	protected

	def category_params
		params.require(:category).permit(:name)
	end

	def get_category
		@category = Category.find(params[:id])
	end

	def require_admin
		if !logged_in? || (logged_in? and !current_user.admin?)
			flash[:danger] = "Only admins can create categories"
			redirect_to categories_path
		end
	end
end