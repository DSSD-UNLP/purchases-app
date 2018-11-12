class ProductsController < ApplicationController
  before_action :set_product, only: :show

  def index
    parameters = index_params
    parameters[:filter] = filter_params

    @manager  = External::ProductManager.new
    @products = @manager.products(parameters)
    @types    = @manager.list_types
  end

  private

  def index_params
    params.permit(:page, :per_page)
  end

  def filter_params
    return unless params[:filter].present?

    params.require(:filter).permit!
  end
end
