class CouponsController < ApplicationController
  before_action :set_product

  def new
    @coupon = External::Coupon.new
  end

  def validate
    @coupon = External::Coupon.find(coupon_params[:name])

    if @coupon.valid?
      flash[:success] = t(:success)

      redirect_to products_path
    else
      flash[:danger] = t(:error)

      render :new
    end
  end

  private

  def coupon_params
    params.require(:external_coupon).permit(:name)
  end

  def set_product
    @product = External::Product.find(params[:product_id])
  end
end
