class ArticlesController < ApplicationController
  before_action :set_article,          only:   [:show, :edit, :update, :destroy]
  before_action :require_user,         except: [:show, :index]
  before_action :require_current_user, only:   [:edit, :update, :destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
  end

  def show
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    
    respond_to do |format|
      if @article.save
        flash[:success] = 'Article was successfully created.'
        format.html { redirect_to @article }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        flash[:success] = 'Article was successfully updated.'
        format.html { redirect_to @article }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      flash[:danger] = 'Article was successfully destroyed.'
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :description, category_ids: [])
    end

    def require_current_user
      if current_user != @article.user && !current_user.admin?
        flash[:danger] = "You can only modified your own articles."
        redirect_to root_path
      end
    end
end
