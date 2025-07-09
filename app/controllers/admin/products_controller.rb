class Admin::ProductsController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: "Product successfully created."
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def show
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_products_path, notice: "Product successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    result = @product.destroy
    if result
      redirect_to admin_products_path, notice: "Product successfully deleted."
    else
      redirect_to admin_products_path, alert: "Failed to delete product."
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description,
      product_variants_attributes: [:id, :color, :size, :stock, :image, :_destroy]
    )
  end
end
