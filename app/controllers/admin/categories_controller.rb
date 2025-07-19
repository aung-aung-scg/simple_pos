class Admin::CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  layout "admin"

  def index
    @categories = Category.left_joins(:products)
                        .select('categories.*, COUNT(products.id) as products_count')
                        .group('categories.id')
                        .order("#{sort_column} #{sort_direction}")
                        .page(params[:page]).per(10)
  end

  def show
  end

  def new
    @category = Category.new
    load_parent_categories
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: 'Category was successfully created.'
    else
      load_parent_categories
      render :new
    end
  end

  def edit
    load_parent_categories(exclude_current: true)
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: 'Category was successfully updated.'
    else
      load_parent_categories(exclude_current: true)
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: 'Category was successfully deleted.'
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :parent_id, :position)
  end

    def sort_column
      %w[id name products_count created_at].include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

  def load_parent_categories(exclude_current: false)
    @parent_categories = Category.where(parent_id: nil)
    @parent_categories = @parent_categories.where.not(id: @category.id) if exclude_current && @category
  end
end
