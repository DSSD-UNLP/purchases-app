class ProductsController < ApplicationController
  before_action :set_product, only: :show

  def index
    @manager  = External::ProductManager.new
    @products = @manager.products(index_params)
    @types    = @manager.list_types
  end

  private

  def index_params
    params.permit(:page, :per_page)
  end
end
