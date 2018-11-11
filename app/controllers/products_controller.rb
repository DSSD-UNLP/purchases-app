class ProductsController < ApplicationController
  def index
    @manager  = External::ProductManager.new
    @products = @manager.products
    @types    = @manager.types
  end

  private
end
