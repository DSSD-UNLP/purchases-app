class ProductsController < ApplicationController
  before_action :set_product, only: :show

  def index
    parameters = index_params.merge(filter_params)

    @products = External::Product.all(parameters)
    @types    = External::ProductType.all(page_size: 10)
  end

  private

  def index_params
    params.permit(:page, :page_size)
  end

  def filter_params
    return unless params[:filter].present?

    params.require(:filter).permit!
  end
end
