class PurchasesController < ApplicationController
  before_action :set_product
  before_action :set_coupon

  def new
    binding.pry
  end

  def create
  end

  private

  def set_coupon
    return unless params[:name].present?

    @coupon = External::Coupon.find(params[:name])
    @coupon = nil unless @coupon.valid?
  end

  def set_product
    @product = External::Product.find(params[:product_id])
  end
end
