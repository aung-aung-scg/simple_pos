class Admin::ProductsController < ApplicationController
  include ErrorHandler
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.includes(:category, :product_variants)
                     .order("#{sort_column} #{sort_direction}")
                     .page(params[:page]).per(25)
  end

  def new
    @product = Product.new
    @product.product_variants.build # Build empty variant for form
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_products_path, notice: "Product was successfully created."
    else
      flash.now[:alert] = "Failed to create product."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @product is already set by before_action
  end

  def edit
    # @product is already set by before_action
    @product.product_variants.build if @product.product_variants.empty?
  end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: "Product was successfully updated."
    else
      flash.now[:alert] = "Failed to update product."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.can_be_deleted?
      @product.destroy
      redirect_to admin_products_path, notice: 'Product was successfully deleted.'
    else
      redirect_to admin_products_path,
                  alert: 'Cannot delete product - it has existing orders. Consider archiving instead.'
    end
  end

  def archive
    @product = Product.find(params[:id])
    if @product.archived?
      @product.update_columns(archived: false, archived_at: nil)
    else
      @product.update_columns(archived: true, archived_at: Time.current)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to admin_products_path, notice: "Product #{@product.archived? ? 'archived' : 'unarchived'}" }
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_products_path, alert: "Product not found."
  end

  def sort_column
    %w[id name price created_at updated_at].include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def product_params
    params.require(:product).permit(
      :name,
      :price,
      :description,
      :category_id,
      :gender,
      :image,
      product_variants_attributes: [
        :id,
        :color,
        :size,
        :stock,
        :image,
        :_destroy
      ]
    )
  end
end
