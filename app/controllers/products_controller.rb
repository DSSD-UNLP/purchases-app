class ProductsController < ApplicationController
  def index
    @products = External::Product.all
  end

  private
end
